extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.garden_ui()
	game.talk(1)
	var slot = game.calendar.slot
	var keys = ["listening/thoughtful","listening/neutral","listening/amused","explaining/smile"]
	for i in range(4):
		assert(game.garden_scene.displayed_key == keys[i])
		assert(game.calendar.slot == slot)
		await create_timer(0.3).timeout
		assert(not game.garden_scene.get_node("Previous").visible)
		if DisplayServer.get_name() != "headless":
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png("res://tests/lian-expression-%d.png" % i)
		game.ui.get_child(0).get_node("Choice").pressed.emit()
	assert(game.stage == 1 and game.calendar.slot == slot+1)
	assert(game.calendar.collection.has("L01"))
	game.garden_ui()
	game.talk(1)
	for key in ["listening/thoughtful","listening/amused","explaining/smile"]:
		assert(game.garden_scene.displayed_key == key)
		game.ui.get_child(0).get_node("Choice").pressed.emit()
	assert(game.mode == "deck" and game.calendar.slot == slot+1)
	print("LIAN EXPRESSIONS: PASS — four real variants, transitions, first lesson and repeat advice, period charged only at confirmation")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.4).timeout
	quit()
