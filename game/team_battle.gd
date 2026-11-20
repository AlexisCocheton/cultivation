extends RefCounted

# Shared team combat rules; persistence belongs to the campaign controller.
const Encounter = preload("res://game/combat/encounter.gd")
const TerritoryPolicy = preload("res://game/combat/territory_policy.gd")
var encounter = Encounter.new()
var territory_policy = TerritoryPolicy.new()
const Team = preload("res://game/combat/team_state.gd")
var allies = Team.new()
var enemies = Team.new()
const Solo = preload("res://game/battle.gd")
const DECK = ["B01","B01","B02","B02","B03","B04","B05","B06","B07","B08","L01","E05"]
var core:
	get: return cores[actor] if not cores.is_empty() else null
var cores: Array = []
var antidotes_initial: int:
	get: return encounter.antidotes_initial
	set(value): encounter.antidotes_initial = value
var antidotes: int:
	get: return encounter.antidotes
	set(value): encounter.antidotes = value
var guard_received: Array:
	get: return encounter.guard_received
	set(value): encounter.guard_received = value
var actor: int:
	get: return encounter.actor
	set(value): encounter.actor = value
var finished: Array:
	get: return encounter.finished
	set(value): encounter.finished = value
var relation_ranks: Dictionary = {}
var party: Array = ["J","L"]
const COMPANION_DECKS = {
	"J":
	["B01","B01","B02","B02","B03","B08","J01","J02","J03","B04","B05","B06"],
	"L":["B01","B02","B03","B05","B05","B08","L01","L02","L03","E05","B06","B07"],
	"H":["B01","B01","B02","B02","B03","B05","B06","B07","B08","H01","H02","H03"]}

var units: Array:
	get: return encounter.units
	set(value): encounter.units = value
var queue: Array:
	get: return encounter.queue
	set(value): encounter.queue = value
var resolving: bool:
	get: return encounter.resolving
	set(value): encounter.resolving = value
var outcome: String:
	get: return encounter.outcome
	set(value): encounter.outcome = value
var log_lines: Array[String]:
	get: return encounter.log_lines
	set(value): encounter.log_lines = value
const CAPTAIN_DAMAGE = 12
const DAGGER_DAMAGE = 9
const SPEAR_DAMAGE = 8
const COAT_TURN = 1 # Zero-based: announced and applied during the second round.
const POISON_DOSE = 9
var coated: bool:
	get: return territory_policy.coated
	set(value): territory_policy.coated = value
var pill_used: bool:
	get: return territory_policy.pill_used
	set(value): territory_policy.pill_used = value
var pill_target: int:
	get: return territory_policy.pill_target
	set(value): territory_policy.pill_target = value
var events: Array:
	get: return encounter.events
	set(value): encounter.events = value

func start(seed_value: int = 7, deck: Array = DECK, showcase: bool = true) -> String:
	if party.size() != 2 or party[0] == party[1] or not COMPANION_DECKS.has(party[0]) or not COMPANION_DECKS.has(party[1]): return "Équipe invalide."
	var recruit = Solo.new()
	recruit.relation_ranks = relation_ranks.duplicate()
	var error = recruit.start(deck,"partenaire",seed_value)
	if error != "": return error
	cores = [recruit]
	for i in range(2):
		var companion = Solo.new()
		companion.relation_ranks = relation_ranks.duplicate()
		companion.start(COMPANION_DECKS[party[i]],"partenaire",seed_value+100+i)
		cores.append(companion)
	for member in cores:
		member.pile.append_array(member.hand)
		member.hand.clear()
		member.shuffle(member.pile)
		member.draw_cards(4)
		member.energy = 2
	# Only the standalone lab arranges a teaching hand. Campaign uses the real deck.
	if showcase and deck == DECK:
		if not recruit.hand.has("E05"):
			var support_index = recruit.pile.find("E05")
			recruit.pile[support_index] = recruit.hand[3]
			recruit.hand[3] = "E05"
		var has_attack = false
		for id in recruit.hand: has_attack = has_attack or recruit.cards[id].damage > 0
		if not has_attack:
			var attack_index = recruit.pile.find("B01")
			recruit.pile[attack_index] = recruit.hand[1]
			recruit.hand[1] = "B01"
	var names = ["Recrue",{"J":"Jun","L":"Lian","H":"Shen"}[party[0]],{"J":"Jun","L":"Lian","H":"Shen"}[party[1]],"Capitaine","Assaillante","Protecteur"]
	var health = [45,{"J":32,"L":28,"H":34}[party[0]],{"J":32,"L":28,"H":34}[party[1]],38,27,32]
	var appearance = [0,{"J":1,"L":2,"H":6}[party[0]],{"J":1,"L":2,"H":6}[party[1]],3,4,5]
	allies = Team.new()
	enemies = Team.new()
	for i in range(6):
		var member = cores[i].character if i < 3 else Solo.Character.new()
		member.state = {"name":names[i],"appearance":appearance[i],"hp":health[i],"max_hp":health[i],"guard":0,"poison":0,"enraged":false,"intent":{},"exposed":false}
		if i < 3: allies.add(member)
		else: enemies.add(member)

	var inventory = antidotes_initial
	encounter = Encounter.new()
	encounter.antidotes_initial = inventory
	territory_policy = TerritoryPolicy.new()
	error = encounter.configure(allies,enemies,{"qi":2,"draw":4},territory_policy)
	if error != "": return error
	for member in cores: member.encounter = encounter
	return ""

func living(team: int) -> Array: return encounter.living(team)
func announce() -> void: encounter.announce()
func target_kind(index: int) -> String: return encounter.target_kind(actor,index)
func can_play(index: int) -> bool: return encounter.can_play(actor,index)
func valid_target(index: int, target: int) -> bool: return encounter.valid_target(actor,index,target)
func play(index: int, target: int) -> bool:
	if not encounter.can_play(actor,index) or not valid_target(index,target): return false
	var foe = target if target >= allies.members.size() else living(1)[0]
	core.opponent = enemies.members[foe-allies.members.size()]
	return encounter.play(actor,index,target)
func check_outcome() -> void: encounter.check_outcome()
func can_select_actor(index: int) -> bool: return encounter.can_select_actor(index)
func select_actor(index: int) -> bool: return encounter.select_actor(index)
func end_actor_turn() -> bool: return encounter.end_actor_turn()
func begin_resolution() -> bool: return encounter.begin_resolution()
func resolve_next() -> Dictionary: return encounter.resolve_next()
func finish_round() -> void: encounter.finish_round()
func use_antidote(target: int) -> bool: return encounter.use_antidote(target)

func report() -> Dictionary:
	var members: Array = []
	for i in range(1,3):
		members.append({"id":party[i-1],"name":units[i].name,"hp":units[i].hp,"guard_received":guard_received[i],"poison":units[i].poison})
	return {"members":members,"antidote_used":antidotes_initial-antidotes,"rounds":core.turn+1}
