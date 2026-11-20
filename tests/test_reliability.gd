extends SceneTree

const Progress = preload("res://game/campaign/progress.gd")
const Calendar = preload("res://game/calendar.gd")
const Battle = preload("res://game/battle.gd")
const Cards = preload("res://game/cards.gd")
var failures = 0
var checks = 0

func _initialize() -> void: call_deferred("run")

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(message)

func write_text(path: String, content: String) -> void:
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string(content)
	file.close()

func run() -> void:
	var c = Calendar.new()
	c.slot = 6
	var path = "user://reliability_%d.json" % Time.get_ticks_usec()
	check(Progress.save_progress(c,2,true,true,path,2),"Initial save")
	c.slot = 7
	check(Progress.save_progress(c,2,true,true,path,2),"Backup rotation")
	var backup = FileAccess.get_file_as_string(path+".bak")
	# Both syntactically corrupt and valid JSON with invalid state must preserve the backup.
	for corrupt in ["{broken",'{"version":3,"state":{},"stage":2}']:
		write_text(path,corrupt)
		check(Progress.read_progress(path).get("state",{}).get("slot") == 6,"Recover last valid state")
		check(Progress.save_progress(c,2,true,true,path,2),"Save after recovery")
		check(FileAccess.get_file_as_string(path+".bak") == backup,"Do not rotate corrupt primary")
		write_text(path,"broken again")
		check(not Progress.read_progress(path).is_empty(),"Recovery survives a second corruption")
	check(DirAccess.remove_absolute(ProjectSettings.globalize_path(path)) == OK,"Remove test primary")
	check(Progress.save_progress(c,2,true,true,path,2),"Save with primary missing")
	check(FileAccess.get_file_as_string(path+".bak") == backup,"Keep backup when primary missing")
	var primary = FileAccess.get_file_as_string(path)
	c.slot = 99
	check(not Progress.save_progress(c,2,true,true,path,2),"Reject invalid new payload")
	check(FileAccess.get_file_as_string(path) == primary,"Rejected write preserves primary")
	check(FileAccess.get_file_as_string(path+".bak") == backup,"Rejected write preserves backup")
	# Load real saves read-only and round-trip copies in the isolated test user directory.
	for profile in ["play-user","parcours-test-user"]:
		var source = "res://tools/%s/Godot/app_userdata/Les Cendres du Prunier/sequence_visuelle_v2.json" % profile
		if not FileAccess.file_exists(source): continue
		var saved = Progress.read_progress(source)
		check(not saved.is_empty(),"Existing profile validates: "+profile)
		if saved.is_empty(): continue
		var copy = Calendar.new()
		copy.restore(saved.state)
		var copy_path = path+"."+profile
		check(Progress.save_progress(copy,int(saved.stage),saved.muted,saved.reduced,copy_path,int(saved.completed_duels)),"Profile round trip")
		var reread = Progress.read_progress(copy_path)
		check(Calendar.new().normalize(reread.get("state")) == copy.snapshot() and reread.get("completed_duels") == saved.completed_duels,"Preserve progression, deck and duels")
	var battle = Battle.new()
	check(battle.start(Cards.PRESETS["Jun · offensif"],"partenaire",42) == "","Start duel")
	battle.hand = ["J02","B01"]
	check(battle.play(0),"Play J02")
	check(battle.exposed and battle.damage_for("B01") == 9,"Enemy receives +50 percent")
	check(Cards.description("J02").contains("Ennemi Exposé"),"Description identifies target")
	var game = load(ProjectSettings.get_setting("application/run/main_scene")).instantiate()
	check(game.get_script().resource_path == "res://visual/preview.gd","Default launch uses current game")
	root.add_child(game)
	await process_frame
	game.battle = battle
	game.combat_ui()
	var hud = game.ui.get_child(0)
	check(hud.get_node("Enemy").tooltip_text.contains("Exposé"),"Status on enemy")
	check(not hud.get_node("Recruit").tooltip_text.contains("Exposé"),"No status on recruit")
	var before = battle.hp
	battle.end_turn()
	check(before-battle.hp == 6 and not battle.exposed,"Incoming unchanged; exposure expires")
	game.combat_ui()
	check(not game.ui.get_child(0).get_node("Enemy").tooltip_text.contains("Exposé"),"Expired status disappears")
	game.queue_free()
	await process_frame
	print("RELIABILITY: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
