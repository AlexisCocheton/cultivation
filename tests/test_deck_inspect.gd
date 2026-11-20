extends SceneTree
func _initialize() -> void: call_deferred("run")
func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.calendar.grant("L01")
	game.deck_ui()
	var menu = game.ui.get_child(0)
	var before = game.calendar.snapshot()
	var draft = menu.draft.duplicate()
	menu.get_node("Scroll/Grid").get_child(0).get_node("Card").pressed.emit()
	assert(menu.get_node("Detail").visible)
	assert(menu.get_node("Detail/Art").texture != null)
	assert(menu.get_node("Detail/Close").size.y < 70)
	assert(not menu.get_node("Detail/Close").get_global_rect().intersects(menu.get_node("Detail/Effects").get_global_rect()))
	menu.get_node("Detail/Close").pressed.emit()
	assert(not menu.get_node("Detail").visible)
	menu.get_node("DeckScroll/Rows").get_child(0).get_node("Name").pressed.emit()
	assert(menu.get_node("Detail").visible)
	menu.inspect("L01")
	await process_frame
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/deck-card-detail.png")
	for id in game.Cards.catalog():
		menu.inspect(id)
		await process_frame
		assert(menu.get_node("Detail/Effects").get_minimum_size().y <= 254)
	assert(menu.draft == draft and game.calendar.snapshot() == before)
	menu.close_detail()
	print("Deck inspect: PASS — grid and deck clicks, visible art, separate close, all descriptions fit, no draft mutation")
	game.queue_free()
	await process_frame
	quit()
