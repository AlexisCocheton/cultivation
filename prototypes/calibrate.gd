extends SceneTree

const Battle = preload("res://prototypes/battle.gd")
const Cards = preload("res://prototypes/cards.gd")

func _initialize() -> void:
	var results: Array = []
	var cases = {
		"reference":{},
		"pression2_palier1":{"pressure":2,"ramp":1},
		"pression2_palier2":{"pressure":2,"ramp":2},
		"pression3_palier1":{"pressure":3,"ramp":1},
		"pression2_palier1_lian":{"pressure":2,"ramp":1,"lian_combo":12,"lian_finisher":18},
		"pression2_palier2_lian":{"pressure":2,"ramp":2,"lian_combo":12,"lian_finisher":18},
		"pression2_palier1_lian_shen":{"pressure":2,"ramp":1,"lian_combo":12,"lian_finisher":18,"cards":{"H01":{"block":8},"H03":{"block":10}}},
		"pression2_palier2_lian_shen":{"pressure":2,"ramp":2,"lian_combo":12,"lian_finisher":18,"cards":{"H01":{"block":8},"H03":{"block":10}}},
		"pression3_palier1_lian_shen":{"pressure":3,"ramp":1,"lian_combo":12,"lian_finisher":18,"cards":{"H01":{"block":8},"H03":{"block":10}}}}
	for case_name in cases:
		for deck_name in Cards.PRESETS:
			for repairs in [0,3,6]:
				var wins = 0
				var turns = 0
				var health = 0
				for seed_value in range(100):
					var b = Battle.new()
					b.tuning = cases[case_name]
					b.start(Cards.PRESETS[deck_name],"inspecteur",seed_value,repairs)
					while b.outcome == "" and b.turn < 50:
						var count = 0
						while b.outcome == "" and count < 50:
							var index = b.bot_index()
							if index < 0: break
							b.play(index)
							count += 1
						b.end_turn()
					wins += int(b.outcome == "victory")
					turns += b.turn+1
					health += b.hp
				var row = {"case":case_name,"deck":deck_name,"repairs":repairs,"samples":100,"wins":wins,"mean_turns":turns/100.0,"mean_hp":health/100.0}
				results.append(row)
				if repairs == 3: print(row)
	var file = FileAccess.open("res://prototypes/balance_results.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"cases":cases,"results":results,"seeds":"0..99","meal":false,"agent":"battle.bot_index"},"\t"))
	quit()
