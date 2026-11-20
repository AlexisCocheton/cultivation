extends SceneTree
var game
func _initialize() -> void: call_deferred("run")
func shot(name: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/painted-ui/activities-"+name+".png")
func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	assert(not game.persistence)
	game.stage = 3
	game.calendar.slot = 10
	game.calendar.seen = ["M01","M02"]
	game.calendar.ranks = {"J":2,"L":2,"H":2}
	game.activities_ui(false,true)
	DisplayServer.window_set_title("Activités — nouvelle composition (test sans sauvegarde)")
	if not OS.get_cmdline_user_args().has("--capture"): return
	var screen = game.ui.get_child(0)
	assert(screen.get_node("Confirm").disabled)
	assert(not screen.get_node("Notice").visible)
	assert(not screen.get_node("SelectionTitle").visible)
	assert(screen.get_node("Merchant").visible)
	await shot("empty")
	screen.select_action("L")
	await shot("selected")
	root.size = Vector2i(960,624)
	await shot("960")
	root.size = Vector2i(1280,832)
	screen.get_node("Merchant").pressed.emit()
	assert(game.mode == "merchant")
	game.activities_ui(false,true)
	game.ui.get_child(0).get_node("Journal").pressed.emit()
	assert(game.ui.get_child(0).summary)
	await shot("summary")
	game.calendar.slot = 6
	game.activities_ui(false,true)
	await shot("event")
	game.calendar.slot = 16
	game.calendar.ranks = {"L":4,"J":4,"H":4}
	game.calendar.story.prepared = false
	game.activities_ui(false,true)
	await shot("day6-high-ranks")
	root.size = Vector2i(960,624)
	await shot("day6-high-ranks-960")
	root.size = Vector2i(1280,832)
	game.calendar.slot = 13
	game.calendar.ranks = {"L":2,"J":2,"H":2}
	game.calendar.story.invites = []
	game.activities_ui(false,true)
	await shot("invitations")
	print("ACTIVITY PRESENTATION: PASS — isolated, empty, selected, merchant, journal, event, two sizes")
	game.sound.stop()
	game.set_process(false)
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.8).timeout
	quit()
