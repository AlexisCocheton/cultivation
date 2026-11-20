extends SceneTree
var checks = 0
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		push_error(message)
		quit(1)
		assert(ok,message)
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
	game.stage = 3
	game.calendar.slot = 12
	game.save_path = "user://day7_%d.json" % Time.get_ticks_usec()
	game.persistence = true
	for i in range(6): check(game.do_activity("rest") == "","Days 5 and 6 reachable")
	check(game.calendar.slot == 18,"Day 7 morning")
	check(game.calendar.reason("rest") != "","Mandatory encounter blocks skipping")
	game.activities_ui()
	check(game.mode == "territory","Encounter introduction")
	await capture("day7-intro")
	var before = game.calendar.snapshot()
	check(game.calendar.act("M03",false) != "" and game.calendar.snapshot() == before,"Defeat cannot consume event")
	check(game.do_activity("M03") != "" and game.calendar.snapshot() == before,"No auto-win from activity menu")
	check(game.start_territory(),"Start campaign fight")
	var screen = game.ui.get_child(0)
	var actual: Array = screen.battle.core.hand + screen.battle.core.pile
	actual.sort()
	var expected = game.calendar.deck.duplicate()
	expected.sort()
	check(actual == expected and not actual.has("E05"),"Uses equipped deck without lab gifts")
	check(game.Progress.read_progress(game.save_path).state.slot == 18,"Pre-fight checkpoint")
	check(not game.finish_territory(),"Cannot commit unfinished fight")
	await capture("day7-combat")
	screen.battle.units[0].hp = 0
	screen.battle.check_outcome()
	screen.refresh()
	check(screen.get_node("Restart").visible,"Retry on defeat")
	screen.restart()
	check(screen.battle.outcome == "" and not screen.battle.pill_used and not screen.battle.coated,"Retry resets tricks")
	check(game.calendar.snapshot() == before,"Retry preserves campaign")
	screen.leave()
	check(game.mode == "hub" and game.load_progress() and game.calendar.snapshot() == before,"Exit/reload returns to preparation")
	game.activities_ui()
	var good_path = game.save_path
	game.save_path = "user://missing-day7-folder/save.json"
	check(not game.start_territory() and game.mode == "territory","Cannot start without checkpoint")
	game.save_path = good_path
	check(game.start_territory(),"Restart after checkpoint recovered")
	screen = game.ui.get_child(0)
	for i in [3,4,5]: screen.battle.units[i].hp = 0
	screen.battle.check_outcome()
	screen.refresh()
	game.save_path = "user://missing-day7-folder/save.json"
	check(not game.finish_territory() and game.calendar.snapshot() == before,"Failed result save rolls back")
	game.save_path = good_path
	check(game.finish_territory(),"Victory commits")
	check(game.calendar.slot == 19 and game.calendar.seen.count("M03") == 1,"One period and one completion")
	check(game.calendar.supplies == before.supplies + game.calendar.Balance.EVENT_RESERVES,"Reward once")
	check(not game.finish_territory(),"Double completion blocked")
	check(game.load_progress() and game.calendar.slot == 19,"Victory survives reload")
	game.story_ack("return_seen",true)
	game.story_ack("candidates","essai")
	check(game.do_activity("rest") == "" and game.do_activity("rest") == "","Day 7 afternoon and evening")
	game.hub()
	check(game.calendar.slot == 21 and game.mode == "spy_arrival","Day 8 arrival follows")
	# Real saves are read and rewritten only to isolated test paths.
	for profile in ["play-user","parcours-test-user"]:
		var source = "res://tools/%s/Godot/app_userdata/Les Cendres du Prunier/sequence_visuelle_v2.json" % profile
		var raw = FileAccess.get_file_as_string(source)
		var saved = game.Progress.read_progress(source)
		check(not saved.is_empty(),"Existing save readable")
		game.calendar.restore(saved.state)
		var preserved = game.calendar.snapshot()
		game.save_path = good_path+profile
		check(game.save_progress() and game.load_progress() and game.calendar.snapshot() == preserved,"Existing save roundtrip")
		check(FileAccess.get_file_as_string(source) == raw,"Personal save untouched")
	print("Day 7 territory: %d checks passed" % checks)
	game.queue_free()
	await process_frame
	quit()
