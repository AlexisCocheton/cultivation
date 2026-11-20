extends RefCounted
# Runtime piles belong to a character, never to an encounter or its view.
var hand: Array = []
var pile: Array = []
var discard: Array = []
var removed: Array = []
var active: Array = []
var initial_size = 12
var hand_limit = 10

var rng = RandomNumberGenerator.new()
func shuffle(values: Array) -> void:
	for i in range(values.size()-1,0,-1):
		var j = rng.randi_range(0,i)
		var temp = values[i]
		values[i] = values[j]
		values[j] = temp

func draw_cards(number: int) -> void:
	for i in range(number):
		if hand.size() >= hand_limit:
			return
		if pile.is_empty():
			pile = discard.duplicate()
			discard.clear()
			shuffle(pile)
		if pile.is_empty():
			return
		hand.append(pile.pop_back())

