extends SceneTree
var game
func _initialize(): call_deferred("run")
func capture(name: String):
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/ui-audit-runtime-2026-11-21/"+name+".png")
func run():
	root.size = Vector2i(1280,832)
	root.content_scale_size = root.size
	game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	assert(not game.persistence)
	game.stage = 3
	game.calendar.slot = 10
	game.visitor_ui()
	var visitor = game.ui.get_child(0)
	visitor.start_duel()
	assert(visitor.phase == "combat")
	assert(visitor.get_node("Arena/Background").is_visible_in_tree())
	for reduced in [false,true]:
		visitor.reduced_motion = reduced
		visitor.battle.hand = ["B01"]
		visitor.battle.energy = 3
		visitor.battle.enemy_block = 0
		visitor.battle.enemy_hp = 40
		var damage = visitor.battle.damage_for("B01")
		await visitor.play_card(0)
		assert(visitor.battle.enemy_hp == 40-damage)
		assert(visitor.player.action_history.has("attack"))
		assert(visitor.player.position == Vector2(310,482))
		visitor.battle.hand = ["B02"]
		visitor.battle.energy = 3
		await visitor.play_card(0)
		assert(visitor.player.guarding and visitor.player.action_history.has("guard"))
		await visitor.end_turn()
		assert(visitor.actors[2].action_history.has("attack"))
		assert(not visitor.busy and visitor.actors[2].position == Vector2(965,482))
	visitor.actors[2].action = "attack"
	visitor.actors[2].action_frame = 2
	await capture("51-visiteuse-pose-attaque")
	visitor.actors[2].action = "guard"
	visitor.actors[2].action_frame = 2
	await capture("52-visiteuse-pose-garde")
	game.hub()
	game.companions_ui("J")
	var sheet = game.ui.get_child(game.ui.get_child_count()-1)
	var tile = sheet.get_node("Scroll/Grid").get_child(0)
	tile.grab_focus()
	sheet.inspect("J01")
	assert(sheet.get_node("Detail/Close").has_focus())
	for action in ["ui_focus_next","ui_focus_prev","ui_left","ui_right"]:
		var event = InputEventAction.new()
		event.action = action
		event.pressed = true
		Input.parse_input_event(event)
		await process_frame
		assert(sheet.get_node("Detail/Close").has_focus())
	sheet.get_node("Detail/Close").pressed.emit()
	assert(tile.has_focus())
	game.deck_ui()
	var deck = game.ui.get_child(0)
	deck.get_node("Search").text = "xxxxxxxxx"
	deck.refresh()
	assert(deck.get_node("Empty").text == "Aucune correspondance pour cette recherche.")
	assert(deck.get_node("Empty").visible)
	deck.get_node("Search").text = ""
	deck.refresh()
	assert(not deck.get_node("Empty").visible)
	game.sound.stop()
	game.queue_free()
	await create_timer(0.3).timeout
	print("RUNTIME UI FIXES: PASS — animated visitor, single card resolution, reduced motion, modal focus, search; no persistence")
	quit()
