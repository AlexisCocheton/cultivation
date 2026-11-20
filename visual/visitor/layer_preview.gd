extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	assert(not game.persistence)
	game.stage = 3
	game.clear_ui()
	var view = load("res://visual/visitor/encounter.tscn").instantiate()
	game.ui.add_child(view)
	view.setup(game)
	await create_timer(0.3).timeout
	DisplayServer.window_set_title("La visiteuse — scène en calques (sans sauvegarde)")
	if OS.get_cmdline_user_args().has("--capture"):
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://docs/painted-ui/22-visiteuse.png")
		view.get_node("Conversation/SceneLayers").set_reduced_motion(true)
		assert(not view.get_node("Conversation/SceneLayers/Petals").is_processing())
		assert(not view.get_node("Conversation/SceneLayers").is_processing())
		view.primary()
		assert(view.phase == "combat")
		assert(not view.get_node("Conversation").visible)
		print("VISITOR LAYERS: PASS — render, reduced motion, duel transition, no persistence")
		quit()
