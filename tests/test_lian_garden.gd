extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func snapshot(path: String) -> Image:
	await process_frame
	await RenderingServer.frame_post_draw
	var image = root.get_texture().get_image()
	image.save_png(path)
	return image

func difference(a: Image, b: Image, region: Rect2i) -> float:
	var change = 0.0
	for y in range(region.position.y,region.end.y,3):
		for x in range(region.position.x,region.end.x,3):
			var c = a.get_pixel(x,y)
			var d = b.get_pixel(x,y)
			change += absf(c.r-d.r)+absf(c.g-d.g)+absf(c.b-d.b)
	return change

func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	var period = game.calendar.slot
	game.ui.get_child(0).get_node("Garden").pressed.emit()
	await process_frame
	await process_frame
	assert(game.location == "garden" and game.mode == "garden")
	assert(not game.player.visible and not game.actors[2].visible)
	var garden = game.garden_scene
	var first = await snapshot("res://tests/lian-garden.png")
	await create_timer(1.25).timeout
	var second = await snapshot("res://tests/lian-garden-motion.png")
	assert(difference(first,second,Rect2i(1030,80,220,140)) > 0.5)
	assert(difference(first,second,Rect2i(165,450,50,100)) > 0.05)
	game.ui.get_child(0).get_node("Effects").pressed.emit()
	await process_frame
	await process_frame
	assert(game.reduced_motion and not garden.get_node("Steam").visible and not garden.get_node("Petals").visible)
	var time = garden.elapsed
	await create_timer(0.2).timeout
	assert(garden.elapsed == time)
	game.ui.get_child(0).get_node("Effects").pressed.emit()
	game.ui.get_child(0).get_node("Person").pressed.emit()
	assert(game.mode == "dialogue")
	assert(not game.ui.get_child(0).get_node("Portrait").visible)
	await snapshot("res://tests/lian-garden-dialogue.png")
	game.ui.get_child(0).get_node("Back").pressed.emit()
	assert(game.mode == "garden")
	game.ui.get_child(0).get_node("Deck").pressed.emit()
	game.ui.get_child(0).get_node("Back").pressed.emit()
	assert(game.mode == "garden")
	game.ui.get_child(0).get_node("Gate").pressed.emit()
	assert(game.mode == "hub" and not garden.visible)
	assert(game.calendar.slot == period)
	# Exercise future presentation states without pretending new artwork exists.
	garden.present("unavailable","missing")
	assert(garden.requested_expression == "missing")
	assert(garden.displayed_key == "sword_care/smile")
	garden.appearances = garden.appearances.duplicate(true)
	garden.appearances.frames["listening/neutral"] = garden.get_node("Painting").texture.duplicate()
	garden.appearances.frames["explaining/smile"] = garden.get_node("Painting").texture.duplicate()
	garden.present("listening","neutral")
	assert(garden.get_node("Previous").visible)
	garden.present("explaining","smile")
	await create_timer(0.3).timeout
	assert(garden.displayed_key == "explaining/smile" and not garden.get_node("Previous").visible)
	game.reduced_motion = true
	garden.present("sword_care","smile")
	assert(not garden.get_node("Previous").visible)
	print("LIAN GARDEN: PASS — entry, rendered foliage/steam motion, reduced effects, dialogue, deck return, gate, free navigation")
	quit()
