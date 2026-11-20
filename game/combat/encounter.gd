extends RefCounted
# One rules engine for 1..3 characters on each side. Views/adapters never own rules.
const Effects = preload("res://game/combat/card_effects.gd")
const Cards = preload("res://game/cards.gd")
const Team = preload("res://game/combat/team_state.gd")
const Character = preload("res://game/combat/character_state.gd")
const DefaultPolicy = preload("res://game/combat/duel_policy.gd")
var allies = Team.new()
var enemies = Team.new()
var units: Array = []
var config: Dictionary = {}
var policy = DefaultPolicy.new()
var actor = 0
var turn = 0
var finished: Array = []
var queue: Array = []
var events: Array = []
var log_lines: Array[String] = []
var resolving = false
var outcome = ""
var guard_received: Array = []
var antidotes_initial = 0
var antidotes = 0

func configure(friends, foes, rules: Dictionary = {}, encounter_policy = null) -> String:
	if not friends is Team or not foes is Team: return "Équipe invalide."
	if friends.members.size() < 1 or friends.members.size() > 3 or foes.members.size() < 1 or foes.members.size() > 3: return "Une équipe contient de 1 à 3 personnages."
	var identities: Array = []
	for member in friends.members+foes.members:
		if not member is Character or identities.has(member): return "Personnage absent ou présent plusieurs fois."
		identities.append(member)
	var proposed = {"qi":3,"draw":5,"defeat_on_leader":true,"discard_before_enemy":false,"consume_guard":true}
	proposed.merge(rules,true)
	for field in ["qi","draw"]:
		if not proposed[field] is int or proposed[field] < 0: return "Règles de recharge invalides."
	for field in ["defeat_on_leader","discard_before_enemy","consume_guard"]:
		if not proposed[field] is bool: return "Règle de combat invalide."
	var chosen = DefaultPolicy.new() if encounter_policy == null else encounter_policy
	if not chosen is RefCounted: return "Politique de rencontre invalide."
	for method in ["reset","announce","check_special","resolve_special","after_round"]:
		if not chosen.has_method(method): return "Politique de rencontre incomplète."
	allies = friends
	enemies = foes
	config = proposed
	policy = chosen
	policy.reset()
	units.clear()
	for member in identities: units.append(member.state)
	actor = 0
	turn = 0
	finished.clear()
	queue.clear()
	events.clear()
	log_lines.clear()
	resolving = false
	outcome = ""
	guard_received = []
	for member in allies.members: guard_received.append(0)
	antidotes = antidotes_initial
	announce()
	return ""

func living(team: int) -> Array:
	if team not in [0,1]: return []
	var result: Array = []
	var begin = 0 if team == 0 else allies.members.size()
	var end = allies.members.size() if team == 0 else units.size()
	for i in range(begin,end):
		if units[i].hp > 0: result.append(i)
	return result

func announce() -> void:
	for unit in units: unit.intent = {}
	if not living(0).is_empty() and not living(1).is_empty(): policy.announce(self)

func target_kind(source: int, index: int) -> String:
	if source < 0 or source >= allies.members.size(): return "invalid"
	var member = allies.members[source]
	if index < 0 or index >= member.deck.hand.size(): return "invalid"
	var id: String = member.deck.hand[index]
	return Cards.target_kind(id,member.cards[id])

func valid_target(source: int, index: int, target: int) -> bool:
	if target < 0 or target >= units.size() or units[target].hp <= 0: return false
	match target_kind(source,index):
		"ally": return target < allies.members.size()
		"enemy": return target >= allies.members.size()
		"self": return target == source
	return false

func can_play(source: int, index: int) -> bool:
	if resolving or outcome != "" or source != actor or source < 0 or source >= allies.members.size() or finished.has(source): return false
	var member = allies.members[source]
	if member.state.hp <= 0 or index < 0 or index >= member.deck.hand.size(): return false
	return member.card_cost(member.deck.hand[index]) <= member.energy

static func damage_for(member, target, id: String) -> int:
	return Effects.damage(member.cards[id],member,target)

func play(source: int, index: int, target: int) -> bool:
	if not can_play(source,index) or not valid_target(source,index,target): return false
	var member = allies.members[source]
	var id: String = member.deck.hand[index]
	var card: Dictionary = member.cards[id]
	var kind = target_kind(source,index)
	var foe_index: int = target if kind == "enemy" else (living(1)[0] if not living(1).is_empty() else -1)
	if foe_index < 0: return false
	var foe = enemies.members[foe_index-allies.members.size()]
	member.energy -= member.card_cost(id)
	member.deck.hand.remove_at(index)
	var damage = damage_for(member,foe,id)
	if damage > 0:
		foe.state.hp = maxi(0,foe.state.hp-maxi(0,damage-foe.state.guard))
		foe.state.guard = maxi(0,foe.state.guard-damage)
		member.bonus = 0
	var receiver = target if kind == "ally" else source
	units[receiver].guard += card.block
	if receiver != source: guard_received[receiver] += card.block
	Effects.apply_play(card,member,foe)
	member.played += 1
	if card.persistent: member.deck.active.append(id)
	elif card.exhaust: member.deck.removed.append(id)
	else: member.deck.discard.append(id)
	log_lines.append("%s → %s" % [card.name,units[target].name])
	check_outcome()
	return true

func check_outcome() -> void:
	if outcome != "" or units.is_empty(): return
	if (config.defeat_on_leader and units[0].hp <= 0) or living(0).is_empty(): outcome = "defeat"
	elif living(1).is_empty(): outcome = "victory"
	else: policy.check_special(self)

func can_select_actor(index: int) -> bool:
	return index >= 0 and index < allies.members.size() and units[index].hp > 0 and not finished.has(index) and not resolving and outcome == "" and (index == actor or allies.members[actor].played == 0 or finished.has(actor))
func select_actor(index: int) -> bool:
	if not can_select_actor(index): return false
	actor = index
	return true
func end_actor_turn() -> bool:
	if units.is_empty(): return false
	if resolving or outcome != "" or finished.has(actor): return false
	finished.append(actor)
	for i in living(0):
		if not finished.has(i): select_actor(i); return false
	return begin_resolution()

func begin_resolution() -> bool:
	if units.is_empty(): return false
	if resolving or outcome != "": return false
	for i in living(0):
		if not finished.has(i): return false
	resolving = true
	for i in range(allies.members.size(),units.size()): units[i].guard = 0
	if config.discard_before_enemy:
		for member in allies.members:
			member.deck.discard.append_array(member.deck.hand)
			member.deck.hand.clear()
			member.bonus = 0
		for unit in units: unit.exposed = false
	queue.clear()
	for kind in ["guard","coat","attack"]:
		for i in range(allies.members.size(),units.size()):
			var announced: Dictionary = units[i].intent
			if announced.is_empty(): continue
			if kind == "guard" and announced.get("secondary_guard",0) > 0:
				queue.append({"source":i,"target":i,"kind":"guard","value":announced.secondary_guard,"poison":0})
			if announced.kind == kind or (kind == "attack" and announced.kind == "poison"): queue.append(announced.duplicate())
	return true

func resolve_next() -> Dictionary:
	if not resolving or outcome != "" or queue.is_empty(): return {}
	var action: Dictionary = queue.pop_front()
	var source: Dictionary = units[action.source]
	var target: Dictionary = units[action.target]
	action["cancelled"] = source.hp <= 0 or target.hp <= 0
	if action.cancelled:
		log_lines.append("%s : action annulée (hors combat)." % source.name)
		return action
	if policy.resolve_special(self,action): pass
	elif action.kind == "guard":
		target.guard += action.value
		log_lines.append("%s protège %s : +%d garde." % [source.name,target.name,action.value])
	else:
		var damage = maxi(0,action.value-target.guard)
		if config.consume_guard: target.guard = maxi(0,target.guard-action.value)
		target.hp = maxi(0,target.hp-damage)
		if action.kind == "poison":
			log_lines.append("%s → %s : %d dégâts directs." % [source.name,target.name,damage])
			target.poison += action.poison
			log_lines.append("%s → %s : +%d poison (total %d), garde ignorée." % [source.name,target.name,action.poison,target.poison])
		else: log_lines.append("%s → %s : %d dégâts." % [source.name,target.name,damage])
	check_outcome()
	return action

func finish_round() -> void:
	if not resolving or (not queue.is_empty() and outcome == ""): return
	queue.clear()
	resolving = false
	if outcome != "": return
	for index in range(units.size()):
		var unit: Dictionary = units[index]
		if unit.hp > 0 and unit.poison > 0:
			var amount: int = unit.poison
			unit.hp = maxi(0,unit.hp-amount)
			unit.poison -= 1
			events.append({"kind":"poison","target":index,"value":amount})
			log_lines.append("Poison : %s perd %d PV, garde ignorée." % [unit.name,amount])
	check_outcome()
	if outcome != "": return
	turn += 1
	policy.after_round(self)
	for member in allies.members:
		member.deck.discard.append_array(member.deck.hand)
		member.deck.hand.clear()
		member.begin_turn(config.qi,config.draw)
	for unit in units: unit.exposed = false
	finished.clear()
	actor = living(0)[0]
	announce()

func use_antidote(target: int) -> bool:
	if resolving or outcome != "" or antidotes <= 0 or finished.has(actor): return false
	if target < 0 or target >= allies.members.size() or units[target].hp <= 0 or units[target].poison <= 0: return false
	units[target].poison = 0
	antidotes -= 1
	return true
