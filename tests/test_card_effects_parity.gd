extends SceneTree
# Frozen immediately before data-driven effects/cache migration, after approved B06 change.
const Battle = preload("res://game/battle.gd")
const Cards = preload("res://game/cards.gd")
const FIXTURE = "res://tests/card_effects_parity_baseline.json"
func _initialize() -> void: call_deferred("run")
func deck_of(size: int) -> Array:
	var deck = Cards.PRESETS["Départ"].duplicate()
	var extra = ["B03","B05","B06","B08","H01","H02","L01","J01"]
	while deck.size() < size: deck.append(extra[deck.size()-12])
	return deck
func state(b) -> Dictionary:
	return {"hp":b.hp,"max_hp":b.max_hp,"block":b.block,"enemy_hp":b.enemy_hp,"enemy_block":b.enemy_block,"energy":b.energy,"bonus":b.bonus,"played":b.played,"strength":b.strength,"turn":b.turn,"hand":b.hand,"pile":b.pile,"discard":b.discard,"removed":b.removed,"active":b.active,"limit":b.hand_limit,"exposed":b.exposed,"outcome":b.outcome}
func run() -> void:
	var records: Dictionary = {}
	for id in Cards.catalog():
		for size in [12,16,20]:
			for rank in [0,5]:
				for played in [0,2]:
					for exposed in [false,true]:
						var b = Battle.new()
						b.relation_ranks = {"J":rank,"L":rank,"H":rank}
						assert(b.start(deck_of(size),"partenaire",17) == "")
						b.hp = 30
						b.block = 3
						b.enemy_hp = 100
						b.enemy_block = 4
						b.hand = [id]
						b.played = played
						b.exposed = exposed
						b.bonus = 2
						b.strength = 1
						b.active = ["B07","H02"]
						var case_name = "%s/deck%d/rank%d/played%d/exposed%s" % [id,size,rank,played,str(exposed)]
						assert(b.play(0))
						records[case_name+"/play"] = JSON.stringify(state(b)).sha256_text()
						b.end_turn()
						records[case_name+"/next_turn"] = JSON.stringify(state(b)).sha256_text()
	if OS.get_cmdline_user_args().has("--capture-baseline"):
		if FileAccess.file_exists(FIXTURE): push_error("Refusing to overwrite immutable fixture"); quit(1); return
		var file = FileAccess.open(FIXTURE,FileAccess.WRITE)
		file.store_string(JSON.stringify(records,"  "))
		file.close()
		print("Captured card effects parity: %d states" % records.size())
		quit(); return
	var expected = JSON.parse_string(FileAccess.get_file_as_string(FIXTURE))
	var failures = 0
	if expected.size() != records.size(): failures += 1; push_error("Card effect case count changed")
	for case_name in records:
		if expected.get(case_name) != records[case_name]:
			failures += 1
			if failures <= 12: push_error("Effect parity drift: "+case_name)
	print("Card effects parity: %d states, %d failures" % [records.size(),failures])
	quit(1 if failures else 0)
