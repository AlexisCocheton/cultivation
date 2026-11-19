extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func capture(path: String) -> void:
	if DisplayServer.get_name() == "headless": return
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)

func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.stage = 2
	game.start_combat()
	game.battle.hand = ["B01","B02","L01","B05","B08"]
	game.combat_ui()
	await process_frame
	var hud = game.ui.get_child(0)
	assert(hud.get_node("Scroll/Hand").get_child(4).get_global_rect().end.x <= 1044)
	hud.preview_card("L01")
	assert(hud.get_node("Preview").text.contains("Maintenant : 7 dégâts"))
	await capture("res://tests/combat-manhua.png")
	assert(hud.get_node("Intent/Attack").visible and not hud.get_node("Intent/Guard").visible)
	assert(hud.get_node("Intent/Attack/Value").text == str(game.battle.intent().damage))
	game.battle.turn = 1
	game.combat_ui()
	hud = game.ui.get_child(0)
	assert(not hud.get_node("Intent/Attack").visible and hud.get_node("Intent/Guard").visible)
	await capture("res://tests/combat-intent-guard.png")
	game.battle.profile = "inspecteur"
	game.combat_ui()
	hud = game.ui.get_child(0)
	assert(hud.get_node("Intent/Attack").visible and hud.get_node("Intent/Guard").visible)
	assert(hud.get_node("Intent/Guard/Value").text == str(game.battle.intent().block))
	await process_frame
	game.actors[2].position.x -= 100
	hud.get_node("Intent")._process(0)
	assert(absf(hud.get_node("Intent").get_global_rect().get_center().x-game.actors[2].position.x) < 1)
	game.actors[2].position.x += 100
	await capture("res://tests/combat-intent-mixed.png")
	game.battle.profile = "partenaire"
	game.battle.turn = 0
	game.battle.played = 2
	game.battle.bonus = 2
	game.battle.enemy_block = 5
	hud.preview_card("L01")
	assert(hud.get_node("Preview").text.contains("14 dégâts (9 après garde)"))
	game.battle.energy = 0
	game.combat_ui()
	hud = game.ui.get_child(0)
	assert(hud.get_node("Scroll/Hand").get_child(0).disabled)
	assert(not hud.get_node("Scroll/Hand").get_child(4).disabled)
	game.battle.hand = ["B01","B02","L01","B05","B08","B06","B03","B04","B07","B01"]
	game.combat_ui()
	hud = game.ui.get_child(0)
	await process_frame
	assert(hud.get_node("Scroll/Hand").get_child_count() == 10)
	assert(hud.get_node("Scroll").get_h_scroll_bar().visible)
	game.busy = true
	game.combat_ui()
	hud = game.ui.get_child(0)
	assert(hud.get_node("EndTurn").disabled and hud.get_node("Leave").disabled)
	game.busy = false
	game.battle.hand.clear()
	game.combat_ui()
	assert(game.ui.get_child(0).get_node("Empty").visible)
	game.battle.outcome = "victory"
	game.finish_combat()
	assert(game.ui.get_child(0).get_node("Title").text == "Victoire")
	await capture("res://tests/combat-result-manhua.png")
	game.queue_free()
	await process_frame
	var board = load("res://visual/combat/font_proposals.tscn").instantiate()
	root.add_child(board)
	await capture("res://docs/ui-proposals/font-comparison.png")
	print("COMBAT UI: PASS — hand, preview, combo, Qi, 10 cards, busy, empty hand, result")
	quit()
