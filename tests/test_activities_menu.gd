extends SceneTree

func _initialize() -> void: call_deferred("run")

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
	game.activities_ui()
	var screen = game.ui.get_child(0)
	assert(screen.get_node("Choices/Work/Action").disabled)
	game.learn()
	game.calendar.supplies = 1
	game.activities_ui()
	screen = game.ui.get_child(0)
	assert(screen.get_node("Choices/Hall/Action").disabled)
	assert(screen.get_node("Choices/Hall/Availability").text == "Réserves insuffisantes.")
	assert(screen.get_node("Choices/Lian/Action").disabled)
	# Journal is read-only and reports the real tutorial action.
	screen.get_node("Journal").pressed.emit()
	screen = game.ui.get_child(0)
	assert(screen.summary and game.calendar.slot == 4)
	assert("Première technique avec Lian" in screen.get_node("Summary/Log").text)
	screen.get_node("Continue").pressed.emit()
	screen = game.ui.get_child(0)
	assert(not screen.summary and game.calendar.slot == 4)
	# Display and commit agree on the kitchen's actual work reward.
	game.calendar.buildings.kitchen = 1
	game.activities_ui()
	screen = game.ui.get_child(0)
	assert(screen.get_node("Choices/Work/Detail").text == "+3 réserves")
	screen.get_node("Choices/Work/Action").pressed.emit()
	assert(game.calendar.slot == 5 and game.calendar.supplies == 4)
	game.activities_ui()
	screen = game.ui.get_child(0)
	screen.get_node("Choices/Rest/Action").pressed.emit()
	screen = game.ui.get_child(0)
	assert(screen.summary and game.calendar.slot == 6)
	assert(screen.get_node("Title").text == "Bilan du jour 2")
	assert("Repos" in screen.get_node("Summary/Log").text)
	await capture("activities-day-two")
	screen.get_node("Continue").pressed.emit()
	screen = game.ui.get_child(0)
	assert(screen.get_node("Event").visible and not screen.get_node("Choices").visible)
	assert(screen.get_node("Event/Chibi").texture != null)
	var art1 = screen.get_node("Event/E01Art").texture
	var art2 = screen.get_node("Event/E02Art").texture
	assert(art1.region != art2.region)
	assert(art2.region == load("res://visual/deck/tile.gd").illustration("E02").region)
	await capture("activities-oath")
	screen.get_node("Event/E01").pressed.emit()
	assert(game.calendar.slot == 7 and game.calendar.collection.has("E01") and not game.calendar.collection.has("E02"))
	game.activities_ui()
	screen = game.ui.get_child(0)
	screen.get_node("Choices/Shen/Action").pressed.emit()
	assert(game.mode == "study" and game.calendar.slot == 8)
	var overlay = game.ui.get_child(0)
	overlay.advance()
	overlay.advance()
	game.activities_ui()
	game.ui.get_child(0).get_node("Choices/Rest/Action").pressed.emit()
	screen = game.ui.get_child(0)
	assert(screen.summary and game.calendar.slot == 9)
	screen.get_node("Continue").pressed.emit()
	assert(game.mode == "activities" and game.calendar.slot == 9)
	assert(game.ui.get_child(0).get_node("Merchant").visible)
	print("ACTIVITIES MENU: PASS — costs, locks, journal, daily recap, oath, chibi, cap, deck")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.3).timeout
	quit()
