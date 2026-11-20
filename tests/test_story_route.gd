extends SceneTree
var checks = 0
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: push_error(label); quit(1); assert(ok,label)
func _initialize() -> void: call_deferred("run")
func capture(name: String) -> void:
	if DisplayServer.get_name() == "headless": return
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/"+name+".png")
func run() -> void:
	root.size = Vector2i(1280,832)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.stage = 3
	game.calendar.slot = 13
	game.calendar.ranks = {"J":2,"L":2,"H":2}
	game.calendar.collection.append_array(["J01","L01","H01"])
	game.activities_ui()
	check(game.ui.get_child(0).kind == "invite","Concurrent invitations")
	await capture("story-invitations")
	game.resident_activity("J")
	check(game.calendar.slot == 13 and game.calendar.ranks.J == 2,"Recruitment scene costs nothing before choice")
	check(game.ui.get_child(0).kind == "recruit:J","Recruitment narrative")
	await capture("story-recruitment")
	game.activities_ui(false,true)
	check(game.calendar.slot == 13,"Cancel costs nothing")
	game.resident_activity("J","B")
	check(game.calendar.slot == 14 and game.calendar.recruited("J"),"Exactly one period and recruitment")
	check(game.calendar.story.recruit_choices.J == "B","Choice remembered")
	game.busy = false
	game.hub()
	check(game.calendar.reason("L") != "","Cannot do both invitations in same period")
	game.do_activity("rest")
	game.activities_ui()
	check(game.ui.get_child(0).kind == "prepare","Warning on day 6")
	await capture("story-antidote")
	game.do_activity("antidote")
	check(game.calendar.slot == 16 and game.calendar.story.antidote == 1,"Antidote consumes one period")
	check(game.calendar.reason("antidote") != "","No duplicate dose")
	check(game.calendar.invitation_available("L") and not game.calendar.invitation_available("J"),"Missed invitation returns")
	game.activities_ui()
	game.resident_activity("L","A")
	check(game.calendar.recruited("L") and game.calendar.slot == 17,"Second recruitment")
	game.busy = false
	game.hub()
	game.do_activity("rest")
	game.activities_ui()
	var original = game.calendar.snapshot()
	game.companions_ui("L")
	var browser = game.ui.get_child(game.ui.get_child_count()-1)
	var expected_deck = preload("res://game/team_battle.gd").COMPANION_DECKS["L"]
	var shown_ids = []
	var shown_total = 0
	var catalog = game.Cards.catalog(game.calendar.ranks)
	for tile in browser.get_node("Scroll/Grid").get_children():
		check(not shown_ids.has(tile.card_id),"Companion card grouped once")
		shown_ids.append(tile.card_id)
		var count = int(tile.get_node("Count").text.trim_prefix("×"))
		check(count == expected_deck.count(tile.card_id),"Companion copies match real deck")
		shown_total += count
		check(tile.get_node("Effects").text == game.Cards.Effects.compact_description(catalog[tile.card_id]),"Companion effects match ranked catalogue")
		check(tile.get_node("Name").text == catalog[tile.card_id].name,"Companion card identity")
	check(shown_total == 12 and shown_total == expected_deck.size(),"Full companion deck represented by copy counts")
	for id in expected_deck: check(shown_ids.has(id),"Every companion card visible")
	await capture("story-companions")
	browser.inspect("L01")
	check(browser.get_node("Detail").visible,"Card detail")
	browser.free()
	check(game.calendar.snapshot() == original,"Browsing changes nothing")
	check(game.start_territory(),"Start tournament")
	var screen = game.ui.get_child(0)
	var b = screen.battle
	check(b.antidotes == 1,"Inventory transferred")
	check(not b.use_antidote(1) and b.antidotes == 1,"No wasted dose on healthy ally")
	b.units[1].poison = 18
	var energy = b.core.energy
	check(b.use_antidote(1) and b.units[1].poison == 0 and b.antidotes == 0 and b.core.energy == energy,"Cure all poison without qi")
	check(not b.use_antidote(1),"One use")
	b.units[1].hp = 0
	b.guard_received[2] = 8
	for i in [3,4,5]: b.units[i].hp = 0
	b.check_outcome()
	check(game.finish_territory(),"Victory")
	check(game.ui.get_child(0).kind == "return","Reactive return")
	check(game.ui.get_child(0).get_node("Words").text.contains("soutenu") and game.ui.get_child(0).get_node("Words").text.contains("protection"),"KO and protection branches")
	await capture("story-return")
	game.story_ack("return_seen",true)
	check(game.ui.get_child(0).kind == "candidates","Victory attracts aspirants")
	await capture("story-candidates")
	game.story_ack("candidates","essai")
	game.persistence = true
	game.save_path = "user://story_route_test.json"
	check(game.save_progress() and game.load_progress(),"Save reload new story state")
	check(game.calendar.story.candidates == "essai" and game.calendar.story.antidote == 0,"Persisted outcome")
	print("Story route: %d checks passed" % checks)
	game.queue_free()
	await process_frame
	quit()
