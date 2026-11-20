extends SceneTree
var contacts = 0
var failures = 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)
func hit(actor) -> void:
	contacts += 1
	check(actor.action_frame == 3,"Jun contact at fourth pose")
func capture(name: String) -> void:
	if DisplayServer.get_name() == "headless": return
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/"+name+".png")
func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var screen = load("res://visual/team/lab.tscn").instantiate()
	root.add_child(screen)
	await process_frame
	var jun = screen.get_node("Units/Jun/Actor")
	check(jun.uses_jun_attack(),"Jun selects new animation")
	check(jun.JUN_ATTACK.get_frame_count("attack") == 6,"Six poses")
	for name in ["Lian","Captain","Attacker","Protector"]:
		check(not screen.get_node("Units/"+name+"/Actor").uses_jun_attack(),"Other team characters retain timing")
	var texture = jun.JUN_ATTACK.get_frame_texture("attack",0).atlas.get_image()
	for cell in range(6):
		for corner in [Vector2i(5,5),Vector2i(500,500),Vector2i(10,250)]:
			check(texture.get_pixelv(Vector2i(cell%3,cell/3)*512+corner).a < 0.01,"Empty backdrop is transparent")
	jun.perform_action("attack",func(): hit(jun))
	var seen: Array = []
	while jun.action != "":
		if not seen.has(jun.action_frame): seen.append(jun.action_frame)
		if jun.action_frame == 3 and DisplayServer.get_name() != "headless": await capture("jun-attack-clean")
		await process_frame
	check(seen == [0,1,2,3,4,5],"Every pose played")
	check(contacts == 1,"Exactly one hit")
	check(not jun.corrected_attack.visible and jun.sprite.visible,"Return to idle")
	# Standard avatar, used in the courtyard duel, facing the player to the left.
	var solo = load("res://scripts/avatar.gd").new()
	solo.character_row = 2
	solo.facing = -1.0
	root.add_child(solo)
	await solo.perform_action("attack",func(): hit(solo),true)
	check(contacts == 2 and solo.corrected_attack.flip_h,"Solo duel mirrors and calls once")
	solo.queue_free()
	screen.queue_free()
	await process_frame
	print("Jun attack: ","PASS" if failures == 0 else "FAIL")
	quit(0 if failures == 0 else 1)
