extends SceneTree

var failures = 0

func check(ok: bool, message: String) -> void:
	if not ok:
		push_error(message)
		failures += 1

func _initialize() -> void:
	call_deferred("run")

func capture() -> Image:
	await process_frame
	await RenderingServer.frame_post_draw
	return root.get_texture().get_image()

func differences(a: Image, b: Image, area: Rect2i) -> int:
	var count = 0
	for y in range(area.position.y,area.end.y,3):
		for x in range(area.position.x,area.end.x,3):
			if a.get_pixel(x,y) != b.get_pixel(x,y):
				count += 1
	return count

func run() -> void:
	var game = load("res://legacy/prototype/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.close_modal()
	game.set_process(false)
	game.state.period = 0
	game.refresh()
	game.scenery.set_shader_parameter("wind_time",0.0)
	game.scenery.set_shader_parameter("restoration",Vector3.ZERO)
	for child in game.get_children():
		if child.get_script() == load("res://scripts/petals.gd"):
			child.set_process(false)
	for actor in game.actors.values() + [game.player]:
		actor.set_process(false)
	var original = await capture()
	original.save_png("res://tests/hub-before.png")
	for stage in range(1,4):
		game.scenery.set_shader_parameter("restoration",Vector3(1,float(stage>=2),float(stage>=3)))
		var restored = await capture()
		var region = [Rect2i(550,330,150,45),Rect2i(400,120,450,60),Rect2i(430,210,420,95)][stage-1]
		check(differences(original,restored,region)>30,"Repair stage %d changes correct building region" % stage)
		check(differences(original,restored,Rect2i(800,650,200,40))==0,"Restoration leaves courtyard intact")
		restored.save_png("res://tests/repair-stage-%d.png" % stage)
	game.scenery.set_shader_parameter("wind_time",1.3)
	var wind = await capture()
	game.scenery.set_shader_parameter("wind_time",0.0)
	var still = await capture()
	check(differences(wind,still,Rect2i(270,105,120,80))>5,"Wind changes plum canopy")
	check(differences(wind,still,Rect2i(600,230,150,60))==0,"Wind leaves architecture stationary")
	game.player.walking = true
	for frame in range(4):
		game.player.tick = (frame + 0.1) / 7.5
		game.player._process(0)
		check(game.player.sprite.frame == frame,"Walk frame %d" % frame)
	game.player.facing = -1
	game.player._process(0)
	check(game.player.sprite.flip_h,"Left-facing walk flips sprite")
	game.player.walking = false
	game.player._process(0)
	check(game.player.sprite.frame == 1,"Idle uses planted passing pose")
	var Avatar = load("res://scripts/avatar.gd")
	for motion in [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT,Vector2(-1,-1),Vector2(1,1)]:
		var expected_texture = Avatar.SHEET
		if absf(motion.y) >= absf(motion.x):
			expected_texture = Avatar.BACK_SHEET if motion.y < 0 else Avatar.FRONT_SHEET
		for actor in game.actors.values() + [game.player]:
			actor.autonomous = false
			actor.face_motion(motion)
			actor.walking = true
			for frame in range(4):
				actor.tick = (frame+0.1)/7.5
				actor._process(0)
				check(actor.sprite.texture == expected_texture,"Directional texture %s row %d" % [motion,actor.character_row])
				check(actor.sprite.frame == actor.character_row*4+frame,"Directional cycle frame")
			check(actor.sprite.flip_h == (motion == Vector2.LEFT),"Only left view is mirrored")
			actor.walking = false
			actor.face_motion(Vector2.ZERO)
			actor._process(0)
			check(actor.sprite.texture == expected_texture and actor.walk_frame == 1,"Idle retains direction")
		if motion == Vector2.UP or motion == Vector2.DOWN:
			var preview = await capture()
			preview.save_png("res://tests/walk-back-preview.png" if motion.y < 0 else "res://tests/walk-front-preview.png")
	# Verify the actual hub movement routes orientation through the same logic.
	game.target = game.player.position + Vector2(0,-30)
	game._process(0.1)
	game.player._process(0)
	check(game.player.sprite.texture == Avatar.BACK_SHEET,"Hub movement upward selects back sheet")
	game.target = game.player.position + Vector2(0,30)
	game._process(0.1)
	game.player._process(0)
	check(game.player.sprite.texture == Avatar.FRONT_SHEET,"Hub movement downward selects front sheet")
	game.actors.Jun.autonomous = true
	game.actors.Jun.destination = game.actors.Jun.position + Vector2(0,-50)
	game.actors.Jun._process(0.1)
	check(game.actors.Jun.sprite.texture == Avatar.BACK_SHEET,"NPC path selects back sheet")
	print("VISUAL TESTS: ","PASS" if failures==0 else "FAIL (%d)" % failures)
	quit(0 if failures==0 else 1)
