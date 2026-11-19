extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.learn()
	game.selected = 0
	game.replace_card("L01")
	await process_frame
	var menu = game.ui.get_child(0)
	var grid = menu.get_node("Scroll/Grid")
	assert(grid.get_child_count() == 12)
	assert(grid.get_child(11).get_global_rect().end.y <= 754)
	grid.get_child(0).pressed.emit()
	assert(menu.get_node("Detail/Effects").text.contains("12 dégâts"))
	assert(menu.get_node("Detail/Action").text == "Remplacer")
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/deck-manhua.png")
	menu.get_node("Detail/Action").pressed.emit()
	menu = game.ui.get_child(0)
	assert(game.deck_tab == "collection")
	menu.inspect("B02")
	assert(menu.get_node("Detail/Action").disabled)
	menu.inspect("B01")
	assert(not menu.get_node("Detail/Action").disabled)
	menu.get_node("Detail/Action").pressed.emit()
	assert(game.calendar.deck[0] == "B01")
	assert(game.calendar.validate_deck(game.calendar.deck,game.calendar.loadout) == "")
	game.ui.get_child(0).get_node("Back").pressed.emit()
	assert(game.mode == "hub")
	print("MANHUA DECK: PASS — 12 visible cards, actual combo, replacement, duplicate limit, return")
	quit()
