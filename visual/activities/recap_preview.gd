extends SceneTree
var game
func _initialize() -> void: call_deferred("run")
func capture(name: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/painted-ui/recap-"+name+".png")
func show_reference_day() -> void:
	game.calendar.slot = 6
	game.calendar.supplies = 4
	game.calendar.history = [
		{"slot":3,"action":"L","supplies":1,"before":{"supplies":1,"ranks":{"L":1},"buildings":{}},"ranks":{"L":2},"gained":["L01"]},
		{"slot":4,"action":"work","supplies":4,"before":{"supplies":1,"ranks":{},"buildings":{}}},
		{"slot":5,"action":"rest","supplies":4,"before":{"supplies":4,"ranks":{},"buildings":{}}}]
	game.activities_ui(true,true)
func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	assert(not game.persistence)
	game.stage = 3
	show_reference_day()
	DisplayServer.window_set_title("Bilan — calques (test sans sauvegarde)")
	if not OS.get_cmdline_user_args().has("--capture"): return
	var screen = game.ui.get_child(0)
	assert(not screen.get_node("Notice").visible)
	assert(screen.get_node("Continue").text == "Continuer")
	await capture("day2")
	screen.get_node("Summary/Rows/Morning/Card").pressed.emit()
	assert(screen.get_node("Detail").visible)
	assert(screen.get_node("Detail/Name").text == game.Cards.catalog()["L01"].name)
	await capture("card")
	screen.get_node("Detail/Close").pressed.emit()
	assert(not screen.get_node("Detail").visible)
	root.size = Vector2i(960,624)
	await capture("960")
	root.size = Vector2i(1280,832)
	game.calendar.slot = 4
	game.activities_ui(true,true)
	await capture("partial")
	game.calendar.history = [{"slot":3,"action":"work","supplies":8}]
	game.activities_ui(true,true)
	assert("après" in game.ui.get_child(0).get_node("Summary/Rows/Morning/Outcome").text)
	await capture("legacy")
	game.calendar.slot = 21
	game.calendar.history = [{"slot":18,"action":"M03","supplies":4,"before":{"supplies":1,"ranks":{"L":1,"J":1,"H":1},"buildings":{"hall":0}},"ranks":{"L":2,"J":2,"H":2},"buildings":{"hall":1},"gained":["L01","H02"]}]
	game.activities_ui(true,true)
	await capture("long-final")
	var final_screen = game.ui.get_child(0)
	assert("url=L01" in final_screen.get_node("Summary/Rows/Morning/Outcome").text)
	final_screen.get_node("Summary/Rows/Morning/Outcome").meta_clicked.emit("L01")
	assert(final_screen.get_node("Detail/Name").text == game.Cards.catalog()["L01"].name)
	final_screen.get_node("Detail/Close").pressed.emit()
	assert(game.ui.get_child(0).get_node("Notice").visible)
	assert(game.ui.get_child(0).get_node("Continue").text == "Composer mon deck")
	print("RECAP PASS: day2, detail, 960, partial, legacy, long rewards, final cap; isolated")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.5).timeout
	quit()
