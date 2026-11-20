extends SceneTree
var game
func _initialize() -> void: call_deferred("run")
func capture(name: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/painted-ui/oath-"+name+".png")
func prepare() -> void:
	game.calendar.slot = 6
	game.calendar.supplies = 4
	game.calendar.seen = ["M01"]
	game.calendar.collection.erase("E01")
	game.calendar.collection.erase("E02")
	game.activities_ui(false,true)
func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	assert(not game.persistence)
	game.stage = 3
	prepare()
	DisplayServer.window_set_title("Serment de l’aube — calques (test sans sauvegarde)")
	if not OS.get_cmdline_user_args().has("--capture"): return
	var screen = game.ui.get_child(0)
	assert(screen.get_node("Event/E01Name").text == game.Cards.catalog()["E01"].name)
	assert(screen.get_node("Event/E02Cost").text == "1")
	await capture("1280")
	root.size = Vector2i(960,624)
	await capture("960")
	root.size = Vector2i(1280,832)
	screen.get_node("Journal").pressed.emit()
	assert(game.ui.get_child(0).summary and game.calendar.slot == 6)
	game.ui.get_child(0).get_node("Continue").pressed.emit()
	assert(game.ui.get_child(0).get_node("OathTitle") != null)
	game.ui.get_child(0).get_node("Back").pressed.emit()
	assert(game.mode == "hub" and game.calendar.slot == 6)
	for id in ["E01","E02"]:
		prepare()
		var choice_screen = game.ui.get_child(0)
		choice_screen.get_node("Event/"+id).pressed.emit()
		assert(game.calendar.slot == 7)
		assert(game.calendar.supplies == 4 + game.calendar.Balance.EVENT_RESERVES)
		assert(game.calendar.collection.has(id))
		assert(not game.calendar.collection.has("E02" if id == "E01" else "E01"))
		choice_screen.choose_oath(id)
		assert(game.calendar.slot == 7)
	print("OATH PASS: two sizes, actual card data, journal, back, both exclusive rewards, one period, double-click guard; isolated")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.5).timeout
	quit()
