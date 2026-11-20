extends SceneTree
var game
func _initialize() -> void: call_deferred("run")
func capture(name: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/painted-ui/refine-"+name+".png")
func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	assert(not game.persistence)
	game.stage = 3
	game.calendar.slot = 9
	game.calendar.supplies = 8
	game.calendar.seen = ["M01","M02"]
	game.merchant_ui()
	await capture("merchant")
	root.size = Vector2i(960,624)
	await capture("merchant-960")
	root.size = Vector2i(1280,832)
	game.calendar.supplies = 0
	game.ui.get_child(0).select("Q02")
	assert(game.ui.get_child(0).get_node("Buy").disabled)
	await capture("merchant-poor")
	game.hub()
	for id in ["J","L","H"]:
		game.companions_ui(id)
		await capture("companion-"+id)
		var view = game.ui.get_child(game.ui.get_child_count()-1)
		var deck: Array = preload("res://game/team_battle.gd").COMPANION_DECKS[id]
		assert(view.get_node("Scroll/Grid").get_child_count() < deck.size())
		view.get_node("Close").pressed.emit()
	root.size = Vector2i(960,624)
	game.companions_ui("J")
	await capture("companion-960")
	game.ui.get_child(game.ui.get_child_count()-1).queue_free()
	await process_frame
	root.size = Vector2i(1280,832)
	game.calendar.slot = 18
	game.territory_ui()
	await capture("party")
	assert(game.ui.get_child(0).get_node("Party/Shen").disabled)
	root.size = Vector2i(960,624)
	await capture("party-960")
	print("UI REFINEMENT PASS: merchant two sizes, insufficient reserves; isolated")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.5).timeout
	quit()
