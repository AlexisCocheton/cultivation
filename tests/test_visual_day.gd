extends SceneTree

var game

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
	game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.learn()
	game.selected = 0
	game.replace_card("L01")
	game.start_combat()
	game.battle.outcome = "victory"
	game.finish_combat()
	assert(game.calendar.slot == 5 and game.calendar.supplies == 7)
	game.hub()
	game.activities_ui()
	await capture("activities-preview")
	assert(game.do_activity("hall") == "")
	assert(game.calendar.slot == 6 and game.calendar.buildings.hall == 1 and game.calendar.supplies == 4)
	assert(game.scenery.get_shader_parameter("restoration") == Vector3(1,0,0))
	assert(game.do_activity("work") != "")
	assert(game.calendar.slot == 6)
	assert(game.do_activity("M02","E02") == "")
	assert(game.calendar.collection.has("E02") and not game.calendar.collection.has("E01"))
	assert(game.do_activity("work") == "")
	assert(game.do_activity("hall") == "")
	assert(game.calendar.slot == 9 and game.calendar.supplies == 3 and game.calendar.buildings.hall == 2)
	assert(game.scenery.get_shader_parameter("restoration") == Vector3.ONE)
	assert(game.calendar.reason("work") == "") # J4 is now available.
	await capture("day-result")
	game.hub()
	await capture("restored-day")
	var path = "user://test_sequence_roundtrip_%d.json" % Time.get_ticks_usec()
	assert(game.Progress.save_progress(game.calendar,game.stage,true,true,path))
	assert(game.Progress.save_progress(game.calendar,game.stage,false,false,path))
	var payload = game.Progress.read_progress(path)
	assert(payload.stage == 3 and payload.state.slot == 9 and payload.state.buildings.hall == 2)
	var restored = game.Calendar.new()
	restored.restore(payload.state)
	assert(restored.deck == game.calendar.deck and restored.collection == game.calendar.collection)
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string("{broken")
	file.close()
	payload = game.Progress.read_progress(path)
	assert(payload.muted == true and payload.state.slot == 9)
	game.calendar = restored
	game.deck_tab = "collection"
	game.selected = 1
	game.deck_ui()
	game.show_deck_detail("E02")
	await capture("deck-collection-preview")
	assert(game.calendar.deck.size() == 12)
	var grid = game.ui.find_children("*","GridContainer",true,false)[0]
	assert(grid.get_child_count() == game.calendar.collection.size())
	game.deck_detail.hide()
	grid.get_child(0).get_node("Card").pressed.emit()
	assert(game.inspected_card == "B01")
	game.deck_detail.hide()
	var equipped = game.calendar.deck.duplicate()
	var draft_menu = game.ui.get_child(0)
	draft_menu.remove_card(equipped[0])
	assert(game.calendar.deck == equipped and draft_menu.draft.size() == 11)
	draft_menu.cancel()
	assert(game.calendar.deck == equipped)
	game.start_combat()
	assert(game.free_duel)
	game.battle.outcome = "victory"
	game.finish_combat()
	assert(game.calendar.slot == 9 and game.calendar.supplies == 3)
	print("VISUAL DAY TESTS: PASS — activities, calendar gate, restoration, save backup, deck and free replay")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.4).timeout
	quit()
