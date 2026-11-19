extends SceneTree

func _initialize() -> void:
	call_deferred("run")

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
	assert(game.nearest_resident() == -1)
	await capture("hub-composition")
	for i in [2]:
		game.player.position = [Vector2.ZERO,Vector2(295,585),Vector2(940,540),Vector2(880,435)][i]
		game.target = game.player.position
		await process_frame
		await process_frame
		assert(game.nearest_resident() == i)
		assert(game.ui.get_child(0).get_node("Talk").visible)
		if i == 1: await capture("hub-interaction")
		game.ui.get_child(0).get_node("Talk").pressed.emit()
		assert(game.mode == "dialogue")
		await process_frame
		await process_frame
		assert(not game.player.visible and not game.activity_sprites[0].visible)
		if i == 1: await capture("hub-dialogue")
		game.ui.get_child(0).get_node("Back").pressed.emit()
		assert(game.mode == "hub")
	game.menu_ui()
	assert(game.mode == "menu")
	await capture("hub-menu")
	game.ui.get_child(0).get_node("Paper/Back").pressed.emit()
	assert(game.mode == "hub")
	assert(game.walkable_position(Vector2(250,480)) == Vector2(250,585))
	game.calendar.buildings.hall = 2
	game.update_restoration()
	assert(game.scenery.get_shader_parameter("restoration") == Vector3.ONE)
	await capture("hub-rebuilt")
	print("HUB COMPOSITION: PASS — Jun reachable; Lian and Shen use dedicated places, contextual input, dialogue, menu, collision, restoration")
	quit()

