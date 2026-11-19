extends SceneTree

var failures = 0
var game

func _initialize() -> void:
	call_deferred("run")

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func capture(filename: String) -> void:
	if DisplayServer.get_name() == "headless": return
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/"+filename+".png")

func run() -> void:
	root.content_scale_size = Vector2i(1280,832)
	root.size = Vector2i(1280,832)
	game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	check(game.stage == 0 and game.calendar.slot == 3,"Sequence starts J2 morning")
	await capture("sequence-hub")
	game.talk(1)
	await capture("sequence-dialogue")
	game.learn()
	check(game.stage == 1 and game.calendar.slot == 4,"Learning consumes one period")
	check(game.calendar.collection.has("L01") and not game.calendar.deck.has("L01"),"Learned card owned but not auto equipped")
	game.learn()
	check(game.calendar.ranks.L == 1 and game.calendar.slot == 4,"Double learning cannot grant rewards")
	await capture("sequence-reward")
	game.selected = 0
	game.replace_card("J03")
	check(not game.calendar.deck.has("J03"),"Unowned card rejected by editor")
	game.selected = 0
	game.replace_card("L01")
	check(game.stage == 2 and game.calendar.deck.has("L01"),"Acquired card can replace equipped card")
	check(game.calendar.deck.size() == 12,"Deck stays at 12")
	await capture("sequence-deck")
	game.start_combat()
	check(game.battle.hand.size() == 5,"Combat draws five cards")
	check(game.battle.hand.has("L01") or game.battle.pile.has("L01"),"Combat uses configured deck")
	await capture("sequence-combat")
	var limit = 0
	while game.mode == "combat" and limit < 100:
		var index = game.battle.bot_index()
		if index >= 0: await game.play_card(index)
		else: await game.end_turn()
		limit += 1
	check(game.stage == 3 and game.calendar.slot == 5,"Completed duel advances to evening")
	check(not game.busy,"Combat releases animation lock")
	await capture("sequence-result")
	var supplies = game.calendar.supplies
	game.start_combat()
	game.battle.enemy_hp = 0
	game.battle.outcome = "victory"
	game.finish_combat()
	check(game.calendar.slot == 5 and game.calendar.supplies == supplies,"Replay does not farm time or resources")
	game.restart()
	check(game.stage == 0 and not game.calendar.collection.has("L01"),"Restart resets isolated sequence")
	print("SEQUENCE TESTS: ", "PASS" if failures == 0 else "FAIL")
	quit(0 if failures == 0 else 1)
