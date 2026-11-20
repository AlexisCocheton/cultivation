extends RefCounted

const Effects = preload("res://game/combat/card_effects.gd")
const Encounter = preload("res://game/combat/encounter.gd")
const Team = preload("res://game/combat/team_state.gd")
const DuelPolicy = preload("res://game/combat/duel_policy.gd")
var encounter = Encounter.new()
var duel_policy = DuelPolicy.new()

const Character = preload("res://game/combat/character_state.gd")
var character = Character.new("Recrue")
var opponent = Character.new("Adversaire",30)

const Cards = preload("res://game/cards.gd")
const Balance = preload("res://game/balance.gd")
var tuning: Dictionary:
	get: return character.tuning
	set(value): character.tuning = value
var cards: Dictionary:
	get: return character.cards
	set(value): character.cards = value
var rng: RandomNumberGenerator:
	get: return character.deck.rng
var hp: int:
	get: return character.state.hp
	set(value): character.state.hp = value
var max_hp: int:
	get: return character.state.max_hp
	set(value): character.state.max_hp = value
var enemy_hp: int:
	get: return opponent.state.hp
	set(value): opponent.state.hp = value
var enemy_max: int:
	get: return opponent.state.max_hp
	set(value): opponent.state.max_hp = value
var energy: int:
	get: return character.energy
	set(value): character.energy = value
var block: int:
	get: return character.state.guard
	set(value): character.state.guard = value
var enemy_block: int:
	get: return opponent.state.guard
	set(value): opponent.state.guard = value
var bonus: int:
	get: return character.bonus
	set(value): character.bonus = value
var played: int:
	get: return character.played
	set(value): character.played = value
var exposed: bool:
	get: return opponent.state.exposed
	set(value): opponent.state.exposed = value
var turn: int:
	get: return encounter.turn
	set(value): encounter.turn = value
var phase: int:
	get: return duel_policy.phase
	set(value): duel_policy.phase = value
var profile: String:
	get: return duel_policy.profile
	set(value): duel_policy.profile = value
var training_level: int:
	get: return duel_policy.training_level
	set(value): duel_policy.training_level = value
# Experimental knob only. Zero exactly preserves the approved rules.
var boss_pressure: int:
	get: return duel_policy.boss_pressure
	set(value): duel_policy.boss_pressure = value
var outcome: String:
	get: return encounter.outcome
	set(value): encounter.outcome = value
var hand: Array:
	get: return character.deck.hand
	set(value): character.deck.hand = value
var pile: Array:
	get: return character.deck.pile
	set(value): character.deck.pile = value
var discard: Array:
	get: return character.deck.discard
	set(value): character.deck.discard = value
var removed: Array:
	get: return character.deck.removed
	set(value): character.deck.removed = value
var active: Array:
	get: return character.deck.active
	set(value): character.deck.active = value
var initial_deck_size: int:
	get: return character.deck.initial_size
	set(value): character.deck.initial_size = value
var strength: int:
	get: return character.strength
	set(value): character.strength = value
var hand_limit: int:
	get: return character.deck.hand_limit
	set(value): character.deck.hand_limit = value
var relation_ranks: Dictionary:
	get: return character.relation_ranks
	set(value): character.relation_ranks = value

func start(deck: Array, foe: String, seed_value: int, repairs: int = 0, meal: bool = false, practice_level: int = 0) -> String:
	var error = Cards.validate(deck)
	if error != "": return error
	if foe not in ["partenaire","offensif","defensif","inspecteur","visiteuse"]: return "Profil inconnu."
	profile = foe
	training_level = clampi(practice_level,0,4) if foe == "partenaire" else 0
	error = character.prepare_deck(deck,seed_value,3,5,relation_ranks,tuning)
	if error != "": return error
	max_hp = 50 if meal and foe == "inspecteur" else 45
	hp = max_hp
	enemy_max = {"partenaire":30,"visiteuse":40,"offensif":38,"defensif":44,"inspecteur":84-3*clampi(repairs,0,6)}[foe] + 4*training_level
	enemy_hp = enemy_max
	block = 0
	enemy_block = 0
	exposed = false
	character.state.poison = 0
	opponent.state.poison = 0
	var friends = Team.new()
	var foes = Team.new()
	friends.add(character)
	foes.add(opponent)
	encounter = Encounter.new()
	return encounter.configure(friends,foes,{"qi":3,"draw":5,"discard_before_enemy":true,"consume_guard":false},duel_policy)

func actor_index() -> int: return encounter.allies.members.find(character)
func target_kind(index: int) -> String: return encounter.target_kind(actor_index(),index)
func can_play(index: int) -> bool: return encounter.can_play(actor_index(),index)
func valid_target(index: int, target: int) -> bool: return encounter.valid_target(actor_index(),index,target)

func shuffle(values: Array) -> void:
	character.deck.shuffle(values)

func draw_cards(number: int) -> void:
	character.deck.draw_cards(number)

func intent() -> Dictionary:
	return duel_policy.intent(turn,tuning)

func damage_for(id: String) -> int:
	return Encounter.damage_for(character,opponent,id)

func play(index: int) -> bool:
	var foe_index = encounter.enemies.members.find(opponent)
	var target = encounter.allies.members.size()+foe_index if target_kind(index) == "enemy" and foe_index >= 0 else actor_index()
	return encounter.play(actor_index(),index,target)

func end_turn() -> void:
	if outcome != "": return
	# Tests/tools may adjust profile or turn directly; refresh the announced policy.
	encounter.announce()
	if not encounter.end_actor_turn(): return
	while not encounter.queue.is_empty() and outcome == "": encounter.resolve_next()
	encounter.finish_round()

func bot_index() -> int:
	# Fixed, transparent one-step heuristic. Not a model of human skill.
	var best = -1
	var best_score = -1.0
	for i in range(hand.size()):
		var id: String = hand[i]
		var c: Dictionary = cards[id]
		if character.card_cost(hand[i]) > energy:
			continue
		var damage = maxi(0,damage_for(id)-enemy_block)
		var useful_block = mini(c.block,maxi(0,intent().damage-block))
		var score = damage + useful_block*1.1 + c.draw*2.2
		score += Effects.bot_bonus(c,character)
		if damage >= enemy_hp and Effects.survives_play(c,character): score += 100
		score /= maxf(1.0,character.card_cost(hand[i]))
		if score > best_score:
			best_score = score
			best = i
	return best
