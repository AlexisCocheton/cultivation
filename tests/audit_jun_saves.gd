extends SceneTree

func _initialize() -> void: call_deferred("run")

func run() -> void:
	var Battle = load("res://game/battle.gd")
	var Cards = load("res://game/cards.gd")
	var decks = {"depart":Cards.PRESETS["Départ"].duplicate(),"premiere_technique":Cards.PRESETS["Départ"].duplicate()}
	decks.premiere_technique[0] = "L01"
	var results: Array = []
	for key in decks:
		for level in range(5):
			var wins = 0
			var hp = 0
			var turns = 0
			for seed_value in range(100):
				var battle = Battle.new()
				assert(battle.start(decks[key],"partenaire",seed_value,0,false,level) == "")
				var steps = 0
				while battle.outcome == "" and steps < 500:
					var index = battle.bot_index()
					if index >= 0: assert(battle.play(index))
					else: battle.end_turn()
					steps += 1
				assert(battle.outcome != "")
				wins += int(battle.outcome == "victory")
				hp += battle.hp
				turns += battle.turn+1
			results.append({"deck":key,"palier":level,"victoires_sur_100":wins,"pv_fin_moyens":hp/100.0,"tours_moyens":turns/100.0})
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	var path = "user://audit_duel_%d.json" % Time.get_ticks_usec()
	game.save_path = path
	game.persistence = true
	game.learn()
	game.selected = 0
	game.replace_card("L01")
	game.completed_duels = 2
	game.muted = true
	game.reduced_motion = true
	assert(game.save_progress())
	var original = game.calendar.snapshot()
	game.start_combat()
	game.battle.hp = 1
	game.completed_duels = 99
	# The exact loader used at startup restores the pre-duel checkpoint.
	assert(game.load_progress())
	assert(game.completed_duels == 2 and game.muted and game.reduced_motion)
	assert(game.calendar.snapshot() == original)
	game.start_combat()
	assert(game.battle.hp == 45 and game.battle.enemy_max == 38)
	game.battle.outcome = "victory"
	game.finish_combat()
	assert(game.completed_duels == 3)
	assert(game.load_progress() and game.completed_duels == 3)
	game.start_combat()
	assert(game.battle.training_level == 3)
	game.leave_combat()
	assert(game.load_progress() and game.completed_duels == 3)
	# Force both backups to contain this same known-good checkpoint.
	assert(game.save_progress())
	assert(game.save_progress())
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string("{broken")
	file.close()
	assert(game.load_progress() and game.completed_duels == 3)
	var payload = game.Progress.read_progress(path)
	payload.completed_duels = -1
	file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string(JSON.stringify(payload))
	file.close()
	assert(game.load_progress() and game.completed_duels == 3)
	# A second slot remains separate from the test slot, including its backup.
	var other_path = path+".other"
	assert(game.Progress.save_progress(game.calendar,game.stage,false,false,other_path,0))
	assert(game.Progress.read_progress(other_path).completed_duels == 0)
	assert(game.Progress.read_progress(path).completed_duels == 3)
	file = FileAccess.open("res://tests/jun_audit_results.json",FileAccess.WRITE)
	file.store_string(JSON.stringify({"simulations":1000,"bot":"heuristique une étape ; pas un joueur humain","results":results,"saves":"PASS: startup loader, interrupted duel, next tier, abandoned duel, malformed JSON, invalid counter, backup, separate slots"},"\t"))
	file.close()
	print("JUN/SAVES AUDIT: PASS — 1000 completed simulations; checkpoint, reload, backup and slot isolation")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.3).timeout
	quit()
