extends SceneTree
var failures = 0
var contacts = 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	if not ok: failures += 1; push_error(message)
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
	var actor = screen.get_node("Units/Lian/Actor")
	var frames = actor.lian_attack.get_node("Body").sprite_frames
	var hilts = load("res://visual/team/lian_attack_source.gd").HILTS
	var angles = load("res://visual/team/lian_attack_source.gd").ANGLES
	for frame in range(6):
		actor.action = "attack"
		actor.action_frame = frame
		actor._process(0)
		check(actor.lian_attack.visible and not actor.sprite.visible,"Body replaced during attack")
		var image = frames.get_frame_texture("attack",frame).get_image()
		check(image.get_size() == Vector2i(544,512),"Complete frame canvas")
		for distance in [15,45,80,115,130]:
			var point = hilts[frame]+Vector2(distance,0).rotated(deg_to_rad(angles[frame]))
			var pixel = image.get_pixelv(Vector2i(point.round()))
			check(pixel.a > 0.8 and pixel.r > 0.4,"Visible blade baked into pose %d at %d" % [frame,distance])
		if frame in [0,3]: await capture("lian-attack-%d" % frame)
	actor.action = ""
	actor.perform_action("attack",func():
		contacts += 1
		check(actor.action_frame == 3,"Impact on fourth pose")
	)
	var seen: Array = []
	while actor.action != "":
		if not seen.has(actor.action_frame): seen.append(actor.action_frame)
		await process_frame
	check(seen == [0,1,2,3,4,5] and contacts == 1,"Six poses, one impact")
	check(not actor.lian_attack.visible and actor.sprite.visible,"Return to idle")
	await actor.perform_action("guard",Callable(),true)
	check(not actor.lian_attack.visible,"Guard keeps previous art")
	await screen.end_turn() # Lian protects in the opening round.
	screen.end_turn()
	var captured_attack = false
	while screen.busy:
		if actor.action == "attack" and actor.action_frame == 3 and not captured_attack:
			check(actor.lian_attack.visible,"Complete sprite visible in actual combat")
			await capture("lian-live-attack")
			captured_attack = true
		await process_frame
	check(captured_attack,"Actual second-round attack observed")
	print("Lian attack: ","PASS" if failures == 0 else "FAIL")
	screen.queue_free()
	await process_frame
	quit(0 if failures == 0 else 1)
