extends SceneTree
var checks = 0
var failures = 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func run() -> void:
	root.size = Vector2i(1280,832)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.learn()
	game.calendar.grant("Q01")
	game.calendar.grant("Q02")
	game.save_path = "user://deck_draft_%d.json" % Time.get_ticks_usec()
	game.persistence = true
	check(game.save_progress(),"Initial fixture save")
	var original = game.calendar.snapshot()
	var bytes = FileAccess.get_file_as_string(game.save_path)
	game.deck_ui()
	var menu = game.ui.get_child(0)
	check(menu.draft == game.calendar.deck,"Initial draft")
	check(menu.get_node("Scroll/Grid").get_child_count() == game.calendar.collection.size(),"Collection always visible")
	menu.get_node("Scroll/Grid").get_child(0).get_node("Card").pressed.emit()
	check(game.inspected_card == "B01" and menu.get_node("Detail").visible,"Click inspects without adding")
	menu.get_node("Detail").hide()
	menu.get_node("DeckScroll/Rows").get_child(0).get_node("Remove").pressed.emit()
	check(menu.draft.size() == 11 and menu.get_node("Save").disabled,"Draft below minimum")
	check(game.calendar.snapshot() == original and FileAccess.get_file_as_string(game.save_path) == bytes,"Edit changes neither model nor file")
	menu.get_node("Cancel").pressed.emit()
	check(game.mode == "hub" and game.calendar.snapshot() == original,"Cancel leaves party unchanged")
	game.deck_ui()
	menu = game.ui.get_child(0)
	check(menu.draft.size() == 12,"Reopen discards draft")
	menu.add_card("L01")
	check(menu.draft.size() == 13 and game.calendar.deck.size() == 12,"Add acquired technique")
	menu.add_card("L01")
	check(menu.draft.size() == 13,"Duplicate guard")
	menu.add_card("Q01")
	menu.add_card("Q02")
	check(menu.draft.has("Q01") and not menu.draft.has("Q02"),"Equipment slot guard")
	menu.remove_card("Q01")
	menu.add_card("Q02")
	check(menu.equipment().weapon == "Q02","Explicit equipment exchange")
	menu.get_node("Save").pressed.emit()
	menu.commit()
	check(game.calendar.deck.size() == 14 and game.calendar.loadout.weapon == "Q02" and game.stage == 2,"Save applies draft once")
	check(game.calendar.slot == original.slot and game.calendar.supplies == original.supplies,"No time consumed")
	var saved = game.Progress.read_progress(game.save_path)
	check(saved.state.deck.size() == 14 and saved.state.loadout.weapon == "Q02","File matches deck")
	game.deck_ui()
	menu = game.ui.get_child(0)
	menu.get_node("Filters/Demonic").pressed.emit()
	check(menu.get_node("Empty").visible and menu.draft.size() == 14,"Empty filter")
	menu.get_node("Filters/All").pressed.emit()
	menu.remove_card("Q02")
	menu.remove_card("L01")
	menu.commit()
	check(game.calendar.deck.size() == 12 and game.calendar.loadout.weapon == "","Equipment removal saved")
	game.deck_ui()
	menu = game.ui.get_child(0)
	menu.add_card("L01")
	game.save_path = "user://missing_directory/deck.json"
	menu.commit()
	check(game.calendar.deck.size() == 12 and menu.draft.size() == 13 and not menu.committing,"Failed save rolls back model")
	check(menu.get_node("Error").text.contains("Échec"),"Error explains recovery")
	game.persistence = false
	menu.cancel()
	game.deck_ui()
	menu = game.ui.get_child(0)
	for id in game.Cards.catalog(): game.calendar.grant(id)
	menu.refresh()
	while menu.draft.size() < 20:
		var before = menu.draft.size()
		for id in game.calendar.collection:
			if menu.add_reason(id) == "": menu.add_card(id); break
		if before == menu.draft.size(): break
	check(menu.draft.size() == 20 and menu.add_reason("H02") != "","Full deck cap")
	menu.refresh()
	if DisplayServer.get_name() != "headless":
		Input.warp_mouse(Vector2(10,10))
		var motion = InputEventMouseMotion.new()
		motion.position = Vector2(10,10)
		root.push_input(motion)
		for control in menu.find_children("*","Control",true,false): control.tooltip_text = ""
		await create_timer(0.3).timeout
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/deck-draft-menu.png")
	game.queue_free()
	await process_frame
	print("DECK DRAFT: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
