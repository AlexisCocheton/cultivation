extends RefCounted

const State = preload("res://scripts/state.gd")
var hp = 40
var enemy_hp = 36
var energy = 3
var block = 0
var turn = 0
var draw_pile: Array = []
var discard: Array = []
var hand: Array = []
var boss = false

func start(cards: Array, is_boss: bool) -> void:
	boss = is_boss
	enemy_hp = 56 if boss else 36
	draw_pile = cards.duplicate()
	draw_pile.shuffle()
	new_turn()

func intent() -> int:
	return [7, 11, 5][turn % 3] + (3 if boss else 0)

func new_turn() -> void:
	energy = 3
	block = 0
	for i in range(5):
		if draw_pile.is_empty():
			draw_pile = discard.duplicate()
			discard.clear()
			draw_pile.shuffle()
		if not draw_pile.is_empty():
			hand.append(draw_pile.pop_back())

func play(index: int) -> bool:
	if index < 0 or index >= hand.size() or hp <= 0 or enemy_hp <= 0:
		return false
	var card = State.CARDS[hand[index]]
	if energy < card.cost:
		return false
	energy -= card.cost
	enemy_hp = maxi(0, enemy_hp - card.damage)
	block += card.block
	discard.append(hand.pop_at(index))
	return true

func end_turn() -> void:
	hp = maxi(0, hp - maxi(0, intent() - block))
	discard.append_array(hand)
	hand.clear()
	turn += 1
	if hp > 0:
		new_turn()
