extends SceneTree

func _initialize() -> void: call_deferred("run")

func run() -> void:
	var Battle = load("res://prototypes/battle.gd")
	var Cards = load("res://prototypes/cards.gd")
	var battle = Battle.new()
	for level in range(7):
		assert(battle.start(Cards.PRESETS["Départ"],"partenaire",42,0,false,level) == "")
		var capped = mini(level,4)
		assert(battle.enemy_max == 30+4*capped and battle.hp == 45)
		assert(battle.intent().damage == 6+capped and battle.intent().block == 0)
		battle.turn = 1
		assert(battle.intent().damage == 0 and battle.intent().block == 5+capped)
		battle.turn = 2
		assert(battle.intent().damage == 9+capped)
	assert(battle.start(Cards.PRESETS["Départ"],"offensif",42,0,false,4) == "")
	assert(battle.enemy_max == 38 and battle.training_level == 0)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.learn()
	game.selected = 0
	game.replace_card("L01")
	game.start_combat()
	game.leave_combat()
	assert(game.completed_duels == 0)
	game.start_combat()
	game.battle.outcome = "victory"
	game.finish_combat()
	game.finish_combat()
	assert(game.completed_duels == 1 and game.calendar.slot == 5)
	game.start_combat()
	assert(game.battle.training_level == 1 and game.battle.enemy_max == 34)
	game.battle.outcome = "defeat"
	game.finish_combat()
	assert(game.completed_duels == 2 and game.calendar.slot == 5)
	var path = "user://jun_progression_test_%d.json" % Time.get_ticks_usec()
	assert(game.Progress.save_progress(game.calendar,game.stage,false,false,path,game.completed_duels))
	assert(game.Progress.read_progress(path).completed_duels == 2)
	# Existing version-2 saves migrate without losing the calendar or deck.
	var old = game.Progress.read_progress(path)
	old.erase("completed_duels")
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string(JSON.stringify(old))
	file.close()
	var migrated = game.Progress.read_progress(path)
	assert(migrated.completed_duels == 1 and migrated.state.slot == 5)
	game.restart()
	assert(game.completed_duels == 0)
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.3).timeout
	print("JUN PROGRESSION: PASS — tutorial, four capped steps, intents, quit, defeat, duplicate guard, persistence, migration, reset")
	quit()
