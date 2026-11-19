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
	game.learn()
	game.pavilion_ui()
	var slot = game.calendar.slot
	game.ui.get_child(0).get_node("Study").pressed.emit()
	assert(game.mode == "study" and game.busy)
	assert(game.calendar.slot == slot+1 and game.calendar.collection.has("H01"))
	game.study_with_shen()
	assert(game.calendar.slot == slot+1)
	var overlay = game.ui.get_child(0)
	assert(overlay.gained == ["H01"])
	await create_timer(0.5).timeout
	await capture("study-chibi-notes")
	await create_timer(3.25).timeout
	assert(overlay.get_node("Chibi").frame >= 4)
	await capture("study-chibi-revelation")
	overlay.get_node("Continue").pressed.emit()
	assert(overlay.finished and game.calendar.slot == slot+1)
	await capture("study-chibi-result")
	overlay.get_node("Continue").pressed.emit()
	assert(game.mode == "pavilion" and not game.busy)
	game.reduced_motion = true
	game.calendar.slot = 7
	game.pavilion_ui()
	game.study_with_shen()
	assert(game.mode == "study")
	overlay = game.ui.get_child(0)
	assert(overlay.finished)
	overlay.advance()
	assert(not game.busy)
	print("CHIBI STUDY: PASS — real frames, revelation, skip, duplicate guard, single period, reduced motion")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.3).timeout
	quit()
