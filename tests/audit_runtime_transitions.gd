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
	for width in [1280,960]:
		root.size = Vector2i(width,832 if width == 1280 else 624)
		await process_frame
		await process_frame
		await RenderingServer.frame_post_draw
		var destination = "res://docs/ui-audit-runtime-2026-11-21/"+name+("" if width == 1280 else "-960")+".png"
		assert(root.get_texture().get_image().save_png(destination) == OK)
	shots.append(name)
	print("AUDIT STATE: ",name)

func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	assert(not game.persistence)
	game.stage = 3
	game.calendar.slot = 10
	for outcome in ["victory","defeat"]:
		game.hub()
		game.start_combat()
		game.battle.outcome = outcome
		game.finish_combat()
		await capture("47-jun-resultat-reel-"+outcome)
	game.calendar.slot = 18
	game.territory_ui()
	assert(game.start_territory())
	var team = game.ui.get_child(0)
	await capture("48-j7-combat-campagne")
	for outcome in ["victory","defeat"]:
		for i in [3,4,5]: team.battle.units[i].hp = 0 if outcome == "victory" else team.battle.units[i].max_hp
		team.battle.units[0].hp = team.battle.units[0].max_hp if outcome == "victory" else 0
		team.battle.outcome = outcome
		team.refresh()
		await capture("49-j7-resultat-"+outcome)
	game.calendar.slot = 13
	game.calendar.ranks = {"J":3,"L":3,"H":3}
	game.hub()
	game.companions_ui("J")
	var sheet = game.ui.get_child(game.ui.get_child_count()-1)
	sheet.inspect("J01")
	var modal = sheet.get_node("Detail")
	print("DETAIL FOCUS: ",str(root.gui_get_focus_owner()))
	print("DETAIL BLOCKS BACKGROUND: ",modal.mouse_filter, " dim=",modal.get_node("Dim").mouse_filter)
	await capture("50-compagnon-detail-focus")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await create_timer(0.3).timeout
	print("AUDIT TRANSITIONS: PASS; no persistence")
	quit()
