extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var frames = load("res://tests/spriteforge/export/godot/recruit_attack.tres")
	assert(frames is SpriteFrames)
	assert(frames.get_frame_count("attack") == 4)
	assert(not frames.get_animation_loop("attack"))
	var sum = 0.0
	for i in range(4):
		if i == 2: assert(absf(sum-0.25)<0.00001)
		sum += frames.get_frame_duration("attack",i)/frames.get_animation_speed("attack")
	assert(absf(sum-0.56)<0.00001)
	var metadata = JSON.parse_string(FileAccess.get_file_as_string("res://tests/spriteforge/ownership/animation.json"))
	assert(metadata.frames[2].pixels_from_outside_cell == 91)
	var exported_scene = load("res://tests/spriteforge/export/godot/recruit_attack.tscn").instantiate()
	root.add_child(exported_scene)
	assert(exported_scene.sprite_frames.get_frame_count("attack") == 4)
	exported_scene.queue_free()
	var game = load("res://visual/spriteforge_compare.tscn").instantiate()
	root.add_child(game)
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	await process_frame
	game.paused = true
	game.zoomed = true
	game.update_zoom()
	game.phase = 2
	game.show_frame()
	if DisplayServer.get_name() != "headless":
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/spriteforge/comparison.png")
	print("SPRITE FORGE EXPORT TESTS: PASS — 4 poses, 560 ms, hit 250 ms, 91 recovered pixels")
	quit()
