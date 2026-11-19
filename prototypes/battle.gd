extends RefCounted

const Cards = preload("res://prototypes/cards.gd")
const Balance = preload("res://prototypes/balance.gd")
var tuning: Dictionary = Balance.COMBAT.duplicate(true)
var cards = Cards.catalog()
var rng = RandomNumberGenerator.new()
var hp = 45
var max_hp = 45
var enemy_hp = 30
var enemy_max = 30
var energy = 3
var block = 0
var enemy_block = 0
var bonus = 0
var played = 0
var exposed = false
var turn = 0
var phase = 0
var profile = "partenaire"
var training_level = 0
# Experimental knob only. Zero exactly preserves the approved rules.
var boss_pressure = 0
var outcome = ""
var hand: Array = []
var pile: Array = []
var discard: Array = []
var removed: Array = []

func start(deck: Array, foe: String, seed_value: int, repairs: int = 0, meal: bool = false, practice_level: int = 0) -> String:
	var error = Cards.validate(deck)
	if error != "":
		return error
	if foe not in ["partenaire","offensif","defensif","inspecteur"]:
		return "Profil inconnu."
	profile = foe
	training_level = clampi(practice_level,0,4) if foe == "partenaire" else 0
	cards = Cards.catalog()
	for id in tuning.get("cards",{}):
		for field in tuning.cards[id]: cards[id][field] = tuning.cards[id][field]
	rng.seed = seed_value
	max_hp = 50 if meal and foe == "inspecteur" else 45
	hp = max_hp
	enemy_max = {"partenaire":30,"offensif":38,"defensif":44,"inspecteur":84-3*clampi(repairs,0,6)}[foe]
	enemy_max += 4 * training_level
	enemy_hp = enemy_max
	energy = 3
	block = 0
	enemy_block = 0
	bonus = 0
	played = 0
	exposed = false
	turn = 0
	phase = 0
	outcome = ""
	hand.clear()
	discard.clear()
	removed.clear()
	pile = deck.duplicate()
	shuffle(pile)
	draw_cards(5)
	return ""

func shuffle(values: Array) -> void:
	for i in range(values.size()-1,0,-1):
		var j = rng.randi_range(0,i)
		var temp = values[i]
		values[i] = values[j]
		values[j] = temp

func draw_cards(number: int) -> void:
	for i in range(number):
		if hand.size() >= 10:
			return
		if pile.is_empty():
			pile = discard.duplicate()
			discard.clear()
			shuffle(pile)
		if pile.is_empty():
			return
		hand.append(pile.pop_back())

func intent() -> Dictionary:
	var cycles = {
		"partenaire":[Vector2i(6,0),Vector2i(0,5),Vector2i(9,0)],
		"offensif":[Vector2i(8,0),Vector2i(11,0),Vector2i(0,4)],
		"defensif":[Vector2i(0,10),Vector2i(7,0),Vector2i(10,0)],
		"inspecteur":[Vector2i(8,0),Vector2i(5,8),Vector2i(12,0)]}
	var cycle: Array = cycles[profile]
	if profile == "inspecteur" and phase == 1:
		cycle = [Vector2i(10,0),Vector2i(7,6),Vector2i(14,0)]
	var value: Vector2i = cycle[turn % 3]
	if profile == "partenaire":
		if value.x > 0: value.x += training_level
		if value.y > 0: value.y += training_level
	var extra = 0
	if profile == "inspecteur":
		extra = boss_pressure + int(tuning.get("pressure",0)) + int(turn / 3) * int(tuning.get("ramp",0))
	return {"damage":value.x + extra,"block":value.y}

func damage_for(id: String) -> int:
	var damage: int = cards[id].damage
	if id == "L01" and played >= 2:
		damage = int(tuning.get("lian_combo",10))
	if id == "L03" and played >= 2:
		damage = int(tuning.get("lian_finisher",cards[id].damage))
	if damage > 0:
		damage += bonus
		if exposed:
			damage = int(floor(damage * 1.5))
	return damage

func play(index: int) -> bool:
	if outcome != "" or index < 0 or index >= hand.size():
		return false
	var id: String = hand[index]
	var card: Dictionary = cards[id]
	if card.cost > energy:
		return false
	energy -= card.cost
	hand.remove_at(index)
	var damage = damage_for(id)
	if damage > 0:
		enemy_hp = maxi(0,enemy_hp-maxi(0,damage-enemy_block))
		enemy_block = maxi(0,enemy_block-damage)
		bonus = 0
	block += card.block
	if id == "J02":
		exposed = true
	if id == "B08":
		bonus += 2
	if id == "H02":
		bonus += 3
	if id == "Q04":
		energy = mini(5,energy+1)
	if id == "O01":
		hp = mini(max_hp,hp+6)
	if id == "J03":
		hp = maxi(0,hp-2)
	draw_cards(card.draw)
	if (id == "L03" and played >= 2) or (id == "E06" and exposed):
		draw_cards(1)
	played += 1
	if card.exhaust:
		removed.append(id)
	else:
		discard.append(id)
	if hp <= 0:
		outcome = "defeat"
	elif enemy_hp <= 0:
		outcome = "victory"
	return true

func end_turn() -> void:
	if outcome != "":
		return
	var announced = intent()
	discard.append_array(hand)
	hand.clear()
	exposed = false
	bonus = 0
	enemy_block = announced.block
	hp = maxi(0,hp-maxi(0,announced.damage-block))
	if hp <= 0:
		outcome = "defeat"
		return
	turn += 1
	if profile == "inspecteur" and enemy_hp * 2 <= enemy_max:
		phase = 1
	energy = 3
	block = 0
	played = 0
	draw_cards(5)

func bot_index() -> int:
	# Fixed, transparent one-step heuristic. Not a model of human skill.
	var best = -1
	var best_score = -1.0
	for i in range(hand.size()):
		var id: String = hand[i]
		var c: Dictionary = cards[id]
		if c.cost > energy:
			continue
		var damage = maxi(0,damage_for(id)-enemy_block)
		var useful_block = mini(c.block,maxi(0,intent().damage-block))
		var score = damage + useful_block*1.1 + c.draw*2.2
		if id == "J02": score += 5.0 if energy >= 2 else 0.0
		if id in ["B08","H02"]: score += 3.0 if energy >= 1 else 0.0
		if id == "Q04": score += 6.0
		if id == "O01": score += mini(6,max_hp-hp)*1.2
		if id == "J03": score -= 2.5
		if damage >= enemy_hp and not (id == "J03" and hp <= 2): score += 100
		score /= maxf(1.0,c.cost)
		if score > best_score:
			best_score = score
			best = i
	return best
