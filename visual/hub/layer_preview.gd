extends SceneTree
var game
var run_checks = false
var failures: Array[String] = []
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	if not ok:
		failures.append(message)
		push_error(message)
func capture(name: String) -> void:
	await process_frame
	await process_frame
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://docs/painted-ui/hub-"+name+".png")
func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	check(not game.persistence,"Preview must never save")
	game.stage = 3
	game.calendar.slot = 9
	game.calendar.seen = ["M01","M02"]
	game.calendar.ranks = {"L":2,"J":2,"H":2}
	game.hub()
	DisplayServer.window_set_title("Les Cendres du Prunier — Cour en calques (test sans sauvegarde)")
	if not run_checks and not OS.get_cmdline_user_args().has("--capture"): return
	await create_timer(0.8).timeout
	await capture("jour4")
	game.calendar.slot = 10
	game.hub()
	await capture("apres-midi")
	root.size = Vector2i(960,624)
	await capture("apres-midi-960")
	root.size = Vector2i(1280,832)
	check(game.ui.get_child(0).get_node("Calendar/Active").position.x == 199,"Afternoon selected")
	game.calendar.slot = 18
	game.hub()
	await capture("echeance")
	root.size = Vector2i(960,624)
	await capture("echeance-960")
	root.size = Vector2i(1280,832)
	game.calendar.slot = 9
	game.hub()
	game.clock_time = 0.36
	await capture("attaque")
	check(not game.player.visible,"No walking recruit in hub")
	check(game.actors[2].visible,"Jun visible")
	var position_before = game.player.position
	Input.action_press("move_right")
	await create_timer(0.15).timeout
	Input.action_release("move_right")
	check(game.player.position == position_before,"Movement disabled")
	var hud = game.ui.get_child(0)
	hud.get_node("Gate").pressed.emit()
	check(hud.get_node("GateMenu/Merchant").is_visible_in_tree(),"Merchant accessible day4")
	check(hud.get_node("GateMenu/Visitor").is_visible_in_tree(),"Visitor accessible")
	await capture("portail")
	var key = InputEventAction.new()
	key.action = "interact"
	key.pressed = true
	Input.parse_input_event(key)
	await process_frame
	await process_frame
	check(game.mode == "hub" and hud.get_node("GateMenu").visible,"Portal owns interact shortcut")
	hud.get_node("GateMenu/Merchant").pressed.emit()
	check(game.mode == "merchant","Merchant route")
	game.hub()
	game.ui.get_child(0).get_node("Garden").pressed.emit()
	check(game.location == "garden","Garden route")
	game.hub()
	game.ui.get_child(0).get_node("Pavilion").pressed.emit()
	check(game.location == "pavilion","Pavilion route")
	game.hub()
	game.ui.get_child(0).get_node("Talk").pressed.emit()
	check(game.mode == "dialogue","Jun dialogue route")
	game.start_combat()
	await process_frame
	await process_frame
	check(game.mode == "combat" and game.player.visible and not game.hub_scene.visible,"Legacy duel remains visible")
	game.restore_actors()
	game.hub()
	game.calendar.buildings.hall = 2
	game.update_restoration()
	await capture("restaure")
	game.calendar.buildings.hall = 0
	game.calendar.slot = 0
	game.stage = 0
	game.hub()
	check(not game.ui.get_child(0).get_node("Gate").visible,"No premature visitor at J1")
	check(game.ui.get_child(0).get_node("Activities").disabled,"Tutorial eligibility preserved")
	game.reduced_motion = true
	await process_frame
	await process_frame
	check(game.actors[2].action == "" and not game.petals.visible,"Reduced motion respected")
	await capture("jour1")
	root.size = Vector2i(960,624)
	await capture("960")
	print("HUB TEST: ","PASS" if failures.is_empty() else failures)
	quit(0 if failures.is_empty() else 1)
