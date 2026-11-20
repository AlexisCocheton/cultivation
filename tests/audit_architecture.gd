extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.stage = 3
	game.start_combat()
	game.battle.hand = ["J02"]
	game.combat_ui()
	var hud = game.ui.get_child(0)
	var team = load("res://game/team_battle.gd").new()
	team.start()
	team.core.hand = ["J02"]
	var solo_target_self = hud.target_rect(0).has_point(Vector2(310,350))
	var team_target_enemy = team.target_kind(0) == "enemy"
	var c = game.Calendar.new()
	c.slot = 19
	c.story.battle_report = {"members":[{"bad":"shape"}]}
	var malformed_report_accepted = game.Progress.save_progress(c,3,false,false,"user://audit_malformed_report.json",1)
	game.leave_combat()
	game.persistence = true
	game.save_path = "user://absent-audit-directory/save.json"
	game.start_combat()
	var start_without_save = game.mode == "combat"
	game.battle.outcome = "victory"
	var old_duels = game.completed_duels
	game.finish_combat()
	var result_without_save = game.completed_duels == old_duels+1 and game.mode == "dialogue"
	var report = {"J02_solo_targets_self":solo_target_self,"J02_team_targets_enemy":team_target_enemy,"malformed_nested_story_saved":malformed_report_accepted,"duel_starts_after_save_failure":start_without_save,"duel_reward_commits_in_memory_after_save_failure":result_without_save,"personal_saves_touched":false}
	var file = FileAccess.open("res://tests/audit_architecture_results.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"  "))
	file.close()
	print(JSON.stringify(report))
	game.queue_free()
	await create_timer(0.5).timeout
	quit()
