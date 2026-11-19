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
	game.learn()
	game.selected = 0
	game.replace_card("L01")
	game.calendar.slot = 9
	game.completed_duels = 3
	game.calendar.supplies = 8
	var original = game.calendar.snapshot()
	# Build an old save without touching either user's real save.
	var path = "user://day4_migration_%d.json" % Time.get_ticks_usec()
	var old_payload = {"version":2,"state":original,"stage":2,"muted":true,"reduced":true,"completed_duels":3}
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string(JSON.stringify(old_payload))
	file.close()
	game.save_path = path
	game.persistence = true
	assert(game.load_progress())
	assert(game.calendar.snapshot() == original and game.completed_duels == 3)
	game.activities_ui()
	assert(not game.ui.get_child(0).summary)
	assert(game.ui.get_child(0).get_node("Merchant").visible)
	game.ui.get_child(0).get_node("Merchant").pressed.emit()
	assert(game.mode == "merchant" and game.calendar.slot == 9)
	game.reduced_motion = false
	await capture("day4-merchant")
	var shop = game.ui.get_child(0)
	shop.select("Q01")
	shop.get_node("Buy").pressed.emit()
	shop.commit("Q01") # double click on the old instance must be harmless
	assert(game.calendar.slot == 10 and game.calendar.supplies == 5)
	assert(game.calendar.collection.has("E03") and game.calendar.collection.has("Q01"))
	assert(game.calendar.seen.count("S01") == 1 and not game.calendar.deck.has("Q01"))
	assert(FileAccess.file_exists(path+".before-day4"))
	assert(JSON.parse_string(FileAccess.get_file_as_string(path+".before-day4")).state.slot == 9)
	assert(game.Progress.read_progress(path).version == game.Progress.VERSION)
	game.deck_tab = "collection"
	game.selected = 1
	game.deck_ui()
	game.show_deck_detail("Q01")
	var deck_menu = game.ui.get_child(0)
	deck_menu.get_node("Detail").hide()
	deck_menu.remove_card(game.calendar.deck[1])
	deck_menu.add_card("Q01")
	deck_menu.commit()
	assert(game.calendar.loadout.weapon == "Q01" and game.calendar.deck.size() == 12)
	assert(game.calendar.slot == 10)
	await capture("day4-equipped")
	game.merchant_ui()
	shop = game.ui.get_child(0)
	shop.select("Q01")
	assert(shop.get_node("Buy").disabled)
	shop.select("Q02")
	shop.get_node("Buy").pressed.emit()
	assert(game.calendar.slot == 11 and game.calendar.supplies == 2)
	game.selected = 5
	game.replace_card("Q02")
	assert(game.calendar.loadout.weapon == "Q02" and not game.calendar.deck.has("Q01"))
	assert(game.calendar.deck.size() == 12)
	game.merchant_ui()
	shop = game.ui.get_child(0)
	shop.select("Q03")
	assert(shop.get_node("Buy").disabled)
	shop.commit("Q03")
	assert(game.calendar.slot == 11 and game.calendar.supplies == 2)
	# Same replacement preview/commit keeps weapon + talisman slots valid.
	game.calendar.grant("Q03")
	game.selected = 5
	game.replace_card("Q03")
	assert(game.calendar.loadout.weapon == "Q02" and game.calendar.loadout.talisman == "Q03")
	var weapon_index = game.calendar.deck.find("Q02")
	game.selected = weapon_index
	game.replace_card("B01")
	assert(game.calendar.loadout.weapon == "" and game.calendar.deck.size() == 12)
	assert(game.calendar.validate_deck(game.calendar.deck,game.calendar.loadout) == "")
	var before_reload = game.calendar.snapshot()
	assert(game.load_progress() and game.calendar.snapshot() == before_reload)
	game.hub()
	assert(game.do_activity("rest") == "")
	assert(game.calendar.slot == 12 and game.ui.get_child(0).summary)
	assert(game.do_activity("rest") != "")
	await capture("day4-result")
	# Visit without purchase works at zero reserves, once, and awards E03.
	var calendar = game.Calendar.new()
	calendar.slot = 9
	calendar.supplies = 0
	assert(calendar.act("S01",true,"Q01") != "" and calendar.slot == 9)
	assert(calendar.act("S01",true,"") == "")
	assert(calendar.slot == 10 and calendar.supplies == 0 and calendar.collection.has("E03"))
	assert(calendar.act("S01",true,"") != "")
	assert(calendar.act("buy:BAD") != "")
	# Read real user saves, migrate copies only, and verify the sources stay identical.
	for profile in ["play-user","parcours-test-user"]:
		var source = "res://tools/%s/Godot/app_userdata/Les Cendres du Prunier/sequence_visuelle_v2.json" % profile
		if not FileAccess.file_exists(source): continue
		var raw = FileAccess.get_file_as_string(source)
		var saved = game.Progress.read_progress(source)
		assert(not saved.is_empty())
		var copy_path = path+"."+profile
		file = FileAccess.open(copy_path,FileAccess.WRITE)
		file.store_string(raw)
		file.close()
		game.save_path = copy_path
		assert(game.load_progress())
		var preserved = game.calendar.snapshot()
		assert(game.save_progress())
		assert(game.load_progress() and game.calendar.snapshot() == preserved)
		assert(game.completed_duels == saved.completed_duels)
		assert(FileAccess.get_file_as_string(source) == raw)
	print("DAY4 MERCHANT: PASS — v2 migration/archive, period/cost, free browse, duplicate guard, acquisition, equipment swap/removal, reload, cap, no-funds visit")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.3).timeout
	quit()
