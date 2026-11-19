extends SceneTree

const Cards = preload("res://prototypes/cards.gd")
var failures = 0
var checks = 0

func _initialize() -> void: call_deferred("run")

func check(value: bool, message: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error(message)

func capture(name: String) -> void:
	if DisplayServer.get_name() == "headless": return
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/"+name+".png")

func run() -> void:
	root.size = Vector2i(1280,832)
	var catalog = Cards.catalog()
	check(catalog.size() == 30,"No scope inflation")
	check(Cards.WAY_NAMES.has("demonic"),"Demonic path reserved")
	for id in catalog:
		check(Cards.WAY_NAMES.has(catalog[id].way),"Known path: "+id)
		check(Cards.description(id).contains("Voie : "+Cards.way_name(id)),"Path in full description")
		if id.left(1) in ["B","L","J","H"]: check(catalog[id].way == "orthodox","Sect teachings")
		if id.left(1) in ["Q","O"]: check(catalog[id].way == "unorthodox","Ordinary equipment and items")
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.stage = 3
	game.calendar.slot = 9
	game.calendar.supplies = 8
	check(game.calendar.act("S01",true,"Q01") == "","Merchant acquisition")
	for id in ["E03","Q01"]:
		check(game.calendar.collection.has(id) and catalog[id].way == "unorthodox","Merchant grants non-orthodox card")
	game.deck_tab = "collection"
	game.inspected_card = "Q01"
	game.deck_ui()
	var menu = game.ui.get_child(0)
	check(menu.get_node("Detail/Way").text == "Voie non orthodoxe","Detailed card path")
	for tile in menu.get_node("Scroll/Grid").get_children():
		check(tile.get_node("Way").text == Cards.way_name(tile.card_id),"Card badge")
	await capture("card-ways-deck")
	game.calendar.seen.erase("S01")
	game.merchant_ui()
	check(game.mode == "merchant", "Merchant screen opens")
	await capture("card-ways-merchant")
	game.start_combat()
	game.battle.hand = ["B01","Q01","E03"]
	game.combat_ui()
	check(game.ui.get_child(0).get_node("Scroll/Hand").get_child(1).get_node("Way").text == "Non orthodoxe","Combat badge")
	await capture("card-ways-combat")
	game.queue_free()
	await process_frame
	print("CARD WAYS: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
