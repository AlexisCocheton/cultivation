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
	game.resident_activity("J")
	assert(game.calendar.slot == 3 and not game.busy)
	game.learn()
	game.talk(2)
	game.ui.get_child(0).get_node("Activity").pressed.emit()
	assert(game.mode == "resident_activity" and game.busy)
	assert(game.calendar.slot == 5 and game.calendar.collection.has("J01"))
	var overlay = game.ui.get_child(0)
	assert(overlay.gained == ["J01"])
	game.resident_activity("J")
	assert(game.calendar.slot == 5)
	await create_timer(0.9).timeout
	assert(overlay.get_node("Chibi").frame == 2)
	await capture("chibi-jun-training")
	await create_timer(2.5).timeout
	assert(overlay.finished and overlay.get_node("Chibi").frame == 3)
	assert("Jun" in overlay.get_node("Result").text)
	overlay.advance()
	assert(game.mode == "hub" and not game.busy)
	game.resident_activity("J")
	assert(game.calendar.slot == 5 and not game.busy)
	# Day 3 afternoon: real second relationship unlock with Lian.
	game.calendar.slot = 7
	game.garden_ui()
	game.ui.get_child(0).get_node("Activity").pressed.emit()
	assert(game.calendar.slot == 8 and game.calendar.collection.has("L02"))
	overlay = game.ui.get_child(0)
	assert(overlay.gained == ["L02"])
	await create_timer(0.9).timeout
	assert(overlay.get_node("Chibi").frame == 6)
	await capture("chibi-lian-tea")
	overlay.advance()
	assert(overlay.finished and game.calendar.slot == 8)
	overlay.advance()
	assert(game.mode == "garden" and not game.busy)
	assert(game.ui.get_child(0).get_node("Activity").disabled)
	game.reduced_motion = true
	game.resident_activity("J")
	assert(game.calendar.slot == 9 and game.calendar.collection.has("J02"))
	overlay = game.ui.get_child(0)
	assert(overlay.finished)
	overlay.advance()
	assert(game.mode == "activities" and not game.busy)
	game.resident_activity("L")
	assert(game.calendar.slot == 9)
	print("RESIDENT CHIBI: PASS — Jun/Lian, actual rewards, once-only cost, skip, return, reduced motion, cap")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.3).timeout
	quit()
