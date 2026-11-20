extends RefCounted
const Effects = preload("res://game/combat/card_effects.gd")
const Deck = preload("res://game/combat/deck_state.gd")
var deck = Deck.new()
# Views retain dictionary compatibility during migration, but this is the only state.
var state: Dictionary
func _init(name_value: String = "", health: int = 45, appearance: int = 0) -> void:
	state = {"name":name_value,"appearance":appearance,"hp":health,"max_hp":health,"guard":0,"poison":0,"enraged":false,"intent":{},"exposed":false}

var energy = 3
var bonus = 0
var played = 0
var strength = 0
func begin_turn(qi: int, draw: int) -> void:
	energy = qi
	state.guard = 0
	played = 0
	bonus = 0
	Effects.begin_turn(self,draw)

const Cards = preload("res://game/cards.gd")
const Balance = preload("res://game/balance.gd")
var cards: Dictionary = Cards.catalog()
var tuning: Dictionary = Balance.COMBAT.duplicate(true)
var relation_ranks: Dictionary = {}
func prepare_deck(values: Array, seed_value: int, qi: int = 3, draw: int = 5, ranks: Dictionary = {}, balance: Dictionary = {}) -> String:
	var error = Cards.validate(values)
	if error != "": return error
	relation_ranks = ranks.duplicate()
	tuning = Balance.COMBAT.duplicate(true) if balance.is_empty() else balance.duplicate(true)
	cards = Cards.catalog(relation_ranks,tuning)
	deck = Deck.new()
	deck.rng.seed = seed_value
	deck.initial_size = values.size()
	deck.pile = values.duplicate()
	deck.shuffle(deck.pile)
	deck.draw_cards(draw)
	energy = qi
	bonus = 0
	played = 0
	strength = 0
	return ""

func card_cost(id: String) -> int:
	return Effects.cost(cards[id],self)
