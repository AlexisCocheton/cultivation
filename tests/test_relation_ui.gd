extends SceneTree
var failures = 0
var checks = 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok: failures += 1; push_error(message)
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
	game.persistence = false
	game.stage = 3
	game.calendar.slot = 7
	game.calendar.ranks = {"L":2,"J":2,"H":2}
	game.activities_ui()
	var menu = game.ui.get_child(0)
	check(not menu.get_node("Choices").get_child(0).get_node("Action").disabled,"Lian is available in afternoon")
	check(menu.get_node("Choices").get_child(2).get_node("Action").disabled,"Jun unavailable in afternoon")
	check(menu.get_node("Choices").get_child(4).get_node("Action").disabled,"Shen unavailable in afternoon")
	check(menu.get_node("Choices").get_child(0).get_node("Detail").text.contains("Recrutement"),"Next milestone clearly shown")
	await capture("relation-activities")
	game.calendar.ranks.H = 3
	game.calendar.slot = 18
	game.activities_ui()
	menu = game.ui.get_child(0)
	check(not menu.get_node("Party/Shen").disabled,"Recruited Shen selectable")
	menu.toggle("J")
	check(menu.get_node("Start").disabled,"Cannot enter territorial battle with missing member")
	menu.toggle("H")
	check(not menu.get_node("Start").disabled and game.calendar.party == ["J","L"],"Roster remains draft until confirmation")
	await capture("recruited-party-selection")
	menu.get_node("Start").pressed.emit()
	check(game.mode == "team_combat" and game.calendar.party == ["L","H"],"Roster confirmation enters combat")
	check(game.ui.get_child(0).battle.units[2].name == "Shen","Selected companion in campaign combat")
	game.hub()
	game.calendar.ranks = {"L":5,"J":5,"H":5}
	game.calendar.collection.append_array(["L01","L02","J01","J02","H01","H02"])
	game.deck_ui()
	menu = game.ui.get_child(0)
	menu.inspect("H01")
	check(menu.get_node("Detail/Name").text.ends_with(" +") and menu.get_node("Detail/Effects").text.contains("11 garde"),"Upgraded collection detail agrees with combat")
	await capture("relation-upgraded-card")
	game.queue_free()
	await process_frame
	print("Relation UI: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
