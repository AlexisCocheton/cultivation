extends SceneTree
const Calendar = preload("res://game/calendar.gd")
const Team = preload("res://game/team_battle.gd")
const Progress = preload("res://game/campaign/progress.gd")
var checks = 0
var failures = 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok: failures += 1; push_error(message)
func run() -> void:
	for resident in ["J","L","H"]:
		var c = Calendar.new()
		var periods: Array = {"J":[3,9,15,27],"L":[3,7,16,28],"H":[5,8,17,29]}[resident]
		check(c.ranks[resident] == 1 and not c.recruited(resident),"Encounter starts at rank one")
		for i in range(4):
			c.slot = periods[i]
			check(c.act(resident) == "","Relationship milestone available: " + resident)
			check(c.ranks[resident] == i+2,"Five distinct milestones")
			if i == 0: check(c.collection.has(resident+"01") and not c.recruited(resident),"Transmission before recruitment")
			if i == 1: check(c.recruited(resident) and not c.collection.has(resident+"02"),"Recruitment at rank three")
			if i == 2: check(c.collection.has(resident+"02"),"Second teaching at rank four")
		var base = c.Cards.catalog()
		var improved = c.Cards.catalog(c.ranks)
		for suffix in ["01","02"]:
			var id: String = resident+suffix
			check(improved[id].name.ends_with(" +"),"Upgraded title")
			check(improved[id].damage > base[id].damage or improved[id].block > base[id].block or improved[id].draw > base[id].draw,"Upgrade changes an actual effect")
		check(c.collection.size() == 10,"Upgrade reuses card IDs without extra copies")
		check(c.reason(resident) != "","Completed bond cannot be farmed")
	var c = Calendar.new()
	c.slot = 4
	var before = c.snapshot()
	check(c.act("J") != "" and c.snapshot() == before,"Unavailable activity consumes nothing")
	var legacy = c.snapshot()
	legacy.erase("relation_version")
	legacy.ranks = {"L":1,"J":2,"H":4}
	legacy.collection.append_array(["L01","J01","J02","H01","H02","H03"])
	c.restore(legacy)
	check(c.ranks == {"L":2,"J":4,"H":5},"Legacy milestones migrated without losing progress")
	check(c.collection == legacy.collection and c.deck == legacy.deck and c.slot == legacy.slot,"Existing collection, deck and calendar preserved")
	var migrated = c.snapshot()
	c.restore(migrated)
	check(c.snapshot() == migrated,"Migration is idempotent")
	var path = "user://recruitment_%d.json" % Time.get_ticks_usec()
	check(Progress.save_progress(c,3,false,false,path),"Migrated progress saves")
	var loaded = Progress.read_progress(path)
	check(not loaded.is_empty(),"New save reloads")
	c.restore(loaded.state)
	check(c.snapshot() == migrated,"New ranks survive roundtrip")
	var legacy_path = path + ".legacy"
	var old = legacy.duplicate(true)
	old.erase("party")
	var old_file = FileAccess.open(legacy_path,FileAccess.WRITE)
	var old_raw = JSON.stringify({"version":4,"state":old,"stage":3,"muted":false,"reduced":false})
	old_file.store_string(old_raw)
	old_file.close()
	check(not Progress.read_progress(legacy_path).is_empty(),"Actual version four payload loads")
	check(Progress.save_progress(c,3,false,false,legacy_path),"First migrated write succeeds")
	check(FileAccess.get_file_as_string(legacy_path+".before-relations") == old_raw,"Permanent pre-migration copy preserved")
	check(Progress.save_progress(c,3,false,false,legacy_path),"Second save succeeds")
	old_file = FileAccess.open(legacy_path,FileAccess.WRITE)
	old_file.store_string("broken")
	old_file.close()
	check(not Progress.read_progress(legacy_path).is_empty(),"Backup recovery works with new format")
	var b = Team.new()
	b.relation_ranks = {"J":5,"L":5,"H":5}
	check(b.start() == "","Team starts")
	for i in range(3):
		check(b.cores[i].hand.size() == 4 and b.cores[i].energy == 2,"Each actor starts with four cards and two qi")
		check(b.cores[i].cards.J01.damage == 9 and b.cores[i].cards.L02.block == 7 and b.cores[i].cards.H01.block == 11,"Upgrades apply to recruit and companions")
	check(b.units[1].intent.is_empty() and b.units[2].intent.is_empty(),"No autonomous allied intents")
	check(not b.begin_resolution(),"Enemies cannot skip allied turns")
	var recruit_hand = b.core.hand.duplicate()
	check(b.select_actor(1),"Jun may act first")
	b.core.hand = ["J01","J02"]
	check(b.play(0,3),"Jun plays his own attack")
	check(b.units[1].guard == 6 and b.units[0].guard == 0,"Mixed card protects its caster")
	check(b.cores[0].hand == recruit_hand and b.cores[0].energy == 2,"Jun cannot consume recruit hand or qi")
	check(not b.select_actor(2),"Cannot split a started turn")
	check(b.play(0,4) and b.units[4].exposed and not b.units[3].exposed,"Expose targets one enemy")
	check(not b.end_actor_turn() and b.actor == 0,"Ending Jun selects an unplayed actor")
	check(not b.select_actor(1),"Finished actor cannot act twice")
	check(b.select_actor(2),"Can choose order before playing")
	b.core.hand = ["L02","B07"]
	check(b.play(0,1) and b.units[1].guard == 13,"Lian protects Jun")
	b.core.energy = 2
	check(b.play(0,0) and b.core.active.has("B07") and b.cores[0].active.is_empty(),"Persistent power belongs to caster even when guarding another ally")
	check(not b.end_actor_turn(),"Recruit still has a turn")
	check(b.end_actor_turn() and b.resolving,"Enemy phase starts after all allies")
	check(b.queue.all(func(a): return a.source >= 3),"No hidden extra allied attacks")
	while not b.queue.is_empty() and b.outcome == "": b.resolve_next()
	b.finish_round()
	check(b.core.turn == 1 and b.actor == 0 and b.finished.is_empty(),"New round resets turns")
	check(b.cores[2].hand.size() == 5 and b.cores[0].hand.size() == 4,"Persistent draw is individual")
	check(b.units[3].guard == 8,"Enemy guard remains during all three player turns")
	b.units[1].hp = 0
	check(not b.select_actor(1),"Defeated companion cannot act")
	b.end_actor_turn()
	check(b.actor == 2,"Automatic advance skips defeated companion")
	b.end_actor_turn()
	check(b.resolving,"Defeated companion cannot block round completion")
	var team_calendar = Calendar.new()
	check(team_calendar.party_reason(["J","H"],true) != "","Shen cannot join before recruitment")
	team_calendar.ranks.H = 3
	check(team_calendar.party_reason(["J","H"],true) == "","Recruitment unlocks Shen for team selection")
	b.party = ["H","J"]
	check(b.start() == "" and b.units[1].name == "Shen" and b.units[1].max_hp == 34,"Selected roster determines actors and HP")
	check(b.cores[1].hand.has("H01") or b.cores[1].pile.has("H01"),"Shen has his own techniques")
	check(b.cores[2].hand.has("J01") or b.cores[2].pile.has("J01"),"Jun deck follows roster position")
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var screen = load("res://visual/team/lab.tscn").instantiate()
	root.add_child(screen)
	await process_frame
	screen.battle.relation_ranks = {"J":5,"L":5}
	screen.restart()
	screen.switch_actor(1)
	screen.battle.core.hand = ["J01","J02","J03","B02"]
	screen.refresh()
	check(screen.battle.actor == 1 and screen.get_node("EndTurn").text.contains("Jun"),"UI identifies active actor")
	check(screen.get_node("Hand").cards[0].get_node("Viewport/Card/Name").text.ends_with(" +"),"Upgraded card displayed in actual hand")
	if DisplayServer.get_name() != "headless":
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/recruitment-jun-hand.png")
	screen.select_card(0)
	await screen.choose_target(3)
	check(screen.get_node("Units/Jun/Actor").action_history.has("attack"),"Selected companion performs attack animation")
	await screen.end_turn()
	check(screen.battle.actor != 1 and screen.battle.finished.has(1),"UI ends one companion turn")
	screen.battle.party = ["H","L"]
	screen.restart()
	screen.switch_actor(1)
	screen.battle.core.hand = ["H01","H02","H03","B06"]
	screen.refresh()
	check(screen.get_node("Units/Jun/Name").text == "Shen" and screen.get_node("Units/Jun/Actor").character_row == 3,"Shen visual follows selected roster")
	screen.select_card(0)
	await screen.choose_target(0)
	check(screen.battle.units[0].guard == 8,"Shen can guard recruit with his own deck")
	if DisplayServer.get_name() != "headless":
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/recruitment-shen-hand.png")
	screen.open_team_setup()
	check(screen.get_node("LabParty").visible and screen.get_node("Hand").blocked(),"Team settings block hand input")
	if DisplayServer.get_name() != "headless":
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/recruitment-settings.png")
	screen.party_draft = ["H","J"]
	screen.get_node("LabParty/Mastery").button_pressed = true
	screen.apply_team_setup()
	check(screen.battle.party == ["H","J"] and screen.battle.cores[1].cards.H01.block == 11,"Lab settings restart with chosen team and mastery")
	check(not screen.get_node("LabParty").visible and screen.battle.core.turn == 0,"Setup closes into fresh test battle")
	screen.queue_free()
	await process_frame
	print("Recruitment: %d checks, %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
