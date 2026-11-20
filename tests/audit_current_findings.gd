extends SceneTree

func _initialize() -> void: call_deferred("run")

func run() -> void:
	var Calendar = load("res://game/calendar.gd")
	var Progress = load("res://game/campaign/progress.gd")
	var Battle = load("res://game/battle.gd")
	var Cards = load("res://game/cards.gd")
	var c = Calendar.new()
	c.slot = 9
	var path = "user://audit_recovery_%d.json" % Time.get_ticks_usec()
	assert(Progress.save_progress(c,3,false,false,path,2))
	assert(Progress.save_progress(c,3,false,false,path,2))
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string("{broken")
	file.close()
	var recovered = Progress.read_progress(path)
	assert(not recovered.is_empty())
	assert(Progress.save_progress(c,3,false,false,path,2))
	var backup_after_recovery = Progress.read_progress(path+".bak")
	var backup_overwritten = backup_after_recovery.is_empty()
	var b = Battle.new()
	assert(b.start(Cards.PRESETS["Jun · offensif"],"partenaire",42) == "")
	b.hand = ["J02","B01"]
	assert(b.play(0))
	var outgoing = b.damage_for("B01")
	var hp_before = b.hp
	b.end_turn()
	var incoming = hp_before-b.hp
	var report = {
		"backup_recovery_then_save_overwrites_valid_backup_with_corrupt_primary":backup_overwritten,
		"J02_description":Cards.description("J02"),
		"J02_B01_outgoing_damage":outgoing,
		"J02_enemy_attack_6_actual_incoming":incoming,
		"main_scene":ProjectSettings.get_setting("application/run/main_scene"),
		"user_saves_touched":false
	}
	# Record observed defects; this is an audit, not a passing regression assertion.
	file = FileAccess.open("res://tests/current_audit_findings.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	file.close()
	print(JSON.stringify(report))
	quit()
