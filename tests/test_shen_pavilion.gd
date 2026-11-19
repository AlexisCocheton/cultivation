extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func capture(name: String) -> void:
	if DisplayServer.get_name() == "headless": return
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/"+name+".png")

func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	var slot = game.calendar.slot
	game.ui.get_child(0).get_node("PavilionEntry").pressed.emit()
	await process_frame
	await process_frame
	assert(game.location == "pavilion" and game.pavilion_scene.visible)
	assert(not game.garden_scene.visible and not game.player.visible)
	assert(game.ui.get_child(0).get_node("Study").disabled)
	await capture("shen-pavilion")
	var clock = game.pavilion_scene.elapsed
	await create_timer(0.3).timeout
	assert(game.pavilion_scene.elapsed > clock)
	game.ui.get_child(0).get_node("Effects").pressed.emit()
	await process_frame
	await process_frame
	assert(not game.pavilion_scene.get_node("Tea").visible and not game.pavilion_scene.get_node("Incense").visible)
	clock = game.pavilion_scene.elapsed
	await create_timer(0.2).timeout
	assert(game.pavilion_scene.elapsed == clock)
	game.ui.get_child(0).get_node("Effects").pressed.emit()
	game.ui.get_child(0).get_node("Person").pressed.emit()
	assert(game.mode == "dialogue" and not game.ui.get_child(0).get_node("Portrait").visible)
	await capture("shen-pavilion-dialogue")
	assert(game.pavilion_scene.expression == "serious")
	for expression in ["kind","neutral"]:
		game.ui.get_child(0).get_node("Choice").pressed.emit()
		assert(game.pavilion_scene.expression == expression)
		await create_timer(0.3).timeout
		assert(not game.pavilion_scene.get_node("Previous").visible)
		await capture("shen-expression-"+expression)
	assert(game.calendar.slot == slot)
	game.ui.get_child(0).get_node("Back").pressed.emit()
	assert(game.mode == "pavilion")
	game.ui.get_child(0).get_node("Deck").pressed.emit()
	game.ui.get_child(0).get_node("Back").pressed.emit()
	assert(game.mode == "pavilion")
	game.ui.get_child(0).get_node("Gate").pressed.emit()
	assert(game.mode == "hub" and not game.pavilion_scene.visible)
	assert(game.calendar.slot == slot)
	game.learn()
	game.pavilion_ui()
	assert(not game.ui.get_child(0).get_node("Study").disabled)
	game.ui.get_child(0).get_node("Study").pressed.emit()
	assert(game.calendar.slot == slot+2 and game.calendar.ranks.H == 1)
	assert(game.calendar.collection.has("H01") and game.mode == "study")
	game.ui.get_child(0).advance()
	game.ui.get_child(0).advance()
	assert(game.mode == "pavilion" and not game.busy)
	game.calendar.slot = game.Progress.END_SLOT
	game.pavilion_ui()
	assert(game.ui.get_child(0).get_node("Study").disabled)
	game.garden_ui()
	assert(not game.pavilion_scene.visible and game.garden_scene.visible)
	print("SHEN PAVILION: PASS — entry, effects, dialogue, return, free navigation, study reward and period, end cap")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.3).timeout
	quit()
