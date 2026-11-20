extends SceneTree

func _initialize() -> void: call_deferred("run")

func run() -> void:
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	assert(not game.persistence)
	game.stage = 2
	game.calendar.slot = 16
	game.calendar.ranks.L = 3
	game.calendar.seen = ["M01","M02"]
	game.resident_activity("L")
	assert(game.calendar.slot == 17 and game.calendar.ranks.L == 4)
	assert(game.calendar.collection.has("L02"))
	var screen = game.ui.get_child(0)
	assert(screen.scene_file_path == "res://visual/study/tea.tscn")
	assert(screen.get_node("Time/Value").text == "Après-midi → Soir")
	assert(screen.get_node("Bond/Value").text == "Lian · Lien 3 → 4")
	assert(screen.get_node("Reward/Name").text == "Fil de soie")
	assert(screen.get_node("Reward/Cost").text == "1 Qi")
	assert(screen.get_node("Reward/Art").texture.resource_path == "res://assets/ui/tea/silk.png")
	var state = game.calendar.snapshot()
	screen.advance()
	screen.advance()
	assert(game.calendar.snapshot() == state)
	assert(not game.busy and game.mode == "garden")
	game.clear_ui()
	game.reduced_motion = true
	screen = load("res://visual/study/tea.tscn").instantiate()
	game.ui.add_child(screen)
	screen.setup(game,[])
	assert(not screen.get_node("Reward").visible and screen.get_node("NoCard").visible)
	assert(not screen.get_node("Steam").visible and not screen.get_node("Petals").visible)
	assert(not screen.get_node("Petals").is_processing())
	assert(game.calendar.snapshot() == state)
	screen.advance()
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.3).timeout
	print("TEA LAYERS: PASS — real Lian activity, actual rewards, one commit, continue, no reward, reduced motion, no persistence")
	quit()
