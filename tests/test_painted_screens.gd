extends SceneTree
var game
var shots: Array = []

func _initialize() -> void: call_deferred("run")

func screen(path: String):
	game.clear_ui()
	var view = load("res://visual/"+path+".tscn").instantiate()
	game.ui.add_child(view)
	return view

func capture(name: String) -> void:
	await process_frame
	await process_frame
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://docs/painted-ui/"+name+".png")
	shots.append(name)
	print("PAINTED SCREEN: ",name)

func run() -> void:
	DirAccess.make_dir_recursive_absolute("res://docs/painted-ui")
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	assert(not game.persistence)
	game.stage = 3
	game.calendar.slot = 10
	game.calendar.seen = ["M01","M02"]
	game.calendar.ranks = {"L":2,"J":2,"H":2}
	game.hub()
	await capture("01-cour")
	game.menu_ui()
	await capture("02-menu")
	screen("settings/controls")
	await capture("03-commandes")
	game.garden_ui()
	await capture("04-jardin")
	game.pavilion_ui()
	await capture("05-pavillon")
	game.hub()
	game.dialogue(2,false,"La garde ne sert pas seulement à encaisser. Observe ton adversaire, puis choisis ton ouverture.","Continuer",game.hub)
	await capture("06-dialogue")
	game.deck_ui()
	await capture("07-deck")
	var detail = screen("deck/detail")
	detail.get_node("Name").text = "Fil de soie"
	detail.get_node("Effects").text = game.Cards.description("L02")
	detail.get_node("Art").texture = load("res://visual/deck/tile.gd").illustration("L02")
	detail.get_node("Cost").text = "1"
	detail.show()
	await capture("08-carte")
	game.activities_ui(false,true)
	await capture("09-activites")
	game.calendar = game.Calendar.new()
	game.calendar.slot = 3
	game.calendar.seen = ["M01"]
	game.calendar.act("L")
	game.calendar.act("work")
	game.calendar.act("rest")
	game.activities_ui(true)
	await capture("10-bilan")
	game.activities_ui(false,true)
	await capture("11-serment")
	game.calendar.slot = 9
	game.merchant_ui()
	await capture("12-marchand")
	game.hub()
	game.companions_ui("J")
	await capture("13-compagnons")
	game.calendar.slot = 18
	game.territory_ui()
	await capture("14-equipe")
	game.calendar.slot = 10
	game.start_combat()
	await capture("15-duel")
	game.hub()
	var team = screen("team/lab")
	await capture("16-combat-equipe")
	team.get_node("HelpPaper").show()
	await capture("29-regles")
	game.hub()
	screen("combat/reward").setup(game)
	await capture("17-technique")
	game.battle.outcome = "victory"
	screen("combat/result").setup(game,"Jun rengaine sa lame.\n\nTu remportes le duel d’entraînement.")
	await capture("18-resultat")
	for id in ["H","J"]:
		game.calendar.ranks[id] = 2
		var overlay = screen("study/overlay")
		overlay.setup(game,[id+"01"],id)
		overlay.finish()
		await capture("19-etude" if id == "H" else "20-entrainement")
	game.calendar.ranks.L = 4
	game.calendar.slot = 11
	screen("study/tea").setup(game,["L02"])
	await capture("21-the")
	screen("visitor/encounter").setup(game)
	await capture("22-visiteuse")
	screen("spy/arrival").setup(game)
	await capture("23-espionne")
	game.calendar.slot = 13
	for pair in [["invite","24-invitations"],["prepare","25-antidote"],["recruit:J","26-recrutement"],["return","27-retour"],["candidates","28-aspirants"]]:
		if pair[0] == "return": game.calendar.story.battle_report = {"members":[{"name":"Jun","hp":12,"guard_received":8},{"name":"Lian","hp":0,"guard_received":2}]}
		game.story_ui(pair[0])
		await capture(pair[1])
	var before = game.calendar.snapshot()
	game.confirm_restart()
	await capture("30-confirmation")
	assert(game.ui.get_child(0).get_node("Cancel").has_focus())
	game.ui.get_child(0).get_node("Cancel").pressed.emit()
	assert(game.calendar.snapshot() == before)
	assert(shots.size() == 30)
	var file = FileAccess.open("res://docs/painted-ui/screens.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(shots))
	file.close()
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.3).timeout
	print("PAINTED UI: PASS — 30 runtime screens, cancel without mutation, isolated profile")
	quit()
