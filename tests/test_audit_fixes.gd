extends SceneTree
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
	game.persistence = true
	game.save_path = "user://missing-audit-transaction/save.json"
	var before = game.calendar.snapshot()
	game.learn()
	assert(game.calendar.snapshot() == before and game.stage == 0)
	game.save_path = "user://audit_transaction_test.json"
	game.learn()
	assert(game.stage == 1 and game.ui.get_child(0).has_node("Card"))
	await capture("audit-reward")
	game.save_path = "user://missing-audit-transaction/save.json"
	game.stage = 3
	game.start_combat()
	assert(game.mode != "combat")
	game.save_path = "user://audit_transaction_test.json"
	game.start_combat()
	assert(game.mode == "combat")
	game.battle.hand = ["J02"]
	game.combat_ui()
	assert(game.ui.get_child(0).target_rect(0).has_point(Vector2(965,350)))
	game.battle.outcome = "victory"
	before = game.calendar.snapshot()
	var count = game.completed_duels
	game.save_path = "user://missing-audit-transaction/save.json"
	game.finish_combat()
	assert(game.calendar.snapshot() == before and game.completed_duels == count and game.mode == "combat")
	assert(game.ui.get_child(0).get_node("SaveError").visible)
	await capture("audit-save-retry")
	game.save_path = "user://audit_transaction_test.json"
	game.finish_combat()
	assert(game.completed_duels == count+1 and game.mode == "dialogue")
	game.finish_combat()
	assert(game.completed_duels == count+1)
	var c = game.Calendar.new()
	c.slot = 19
	c.story.battle_report = {"members":[{"bad":"shape"}]}
	assert(not game.Progress.save_progress(c,3,false,false,"user://audit_bad_report.json"))
	var team = load("res://game/team_battle.gd").new()
	team.start()
	assert(team.allies.members.size() == 3 and team.enemies.members.size() == 3)
	team.units[1].hp = 12
	assert(team.cores[1].hp == 12 and team.allies.members[1].state.hp == 12)
	team.cores[1].block = 8
	assert(team.units[1].guard == 8)
	team.cores[1].hand = ["J01"]
	assert(team.allies.members[1].deck.hand == ["J01"])
	assert(team.allies.members[0].deck != team.allies.members[1].deck)
	team.select_actor(1)
	team.core.hand = ["O01"]
	team.core.energy = 3
	assert(team.play(0,1) and team.units[1].hp == 18)
	game.queue_free()
	await create_timer(0.5).timeout
	print("AUDIT FIXES: PASS — transactional save/retry, targets, validation, shared character/deck, healing")
	quit()
