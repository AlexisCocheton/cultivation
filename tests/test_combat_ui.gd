extends SceneTree
func _initialize() -> void: call_deferred("run")
func capture(path: String) -> void:
	if DisplayServer.get_name() == "headless": return
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)
func run() -> void:
	root.size = Vector2i(1280,832)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.stage = 3
	game.start_combat()
	game.battle.hand = ["B01","B02","L01","B05","B08","B06","B03","B04","B07","B01","B02","B05"]
	game.battle.block = 8
	game.battle.enemy_block = 5
	game.combat_ui()
	var hud = game.ui.get_child(0)
	assert(hud.get_node("Hand").cards.size() == 12)
	assert(hud.get_node("Recruit/HP").tint_progress == Color("518f91"))
	assert(hud.get_node("Enemy/HP").tint_progress == Color("518f91"))
	assert(hud.get_node("Qi/Value").text == str(game.battle.energy))
	assert(not hud.has_node("Turn") and not hud.has_node("Preview"))
	assert(hud.target_rect(0).has_point(Vector2(965,350)))
	assert(hud.target_rect(1).has_point(Vector2(310,350)))
	hud.select_card(0)
	var before = game.battle.hand.duplicate()
	hud.drop_card(0,Vector2(310,350))
	assert(game.battle.hand == before and hud.selected == -1)
	await capture("res://tests/combat-unified.png")
	game.battle.energy = 0
	game.combat_ui()
	hud = game.ui.get_child(0)
	assert(not hud.get_node("Hand").can_play(0))
	game.busy = true
	game.combat_ui()
	hud = game.ui.get_child(0)
	assert(hud.get_node("EndTurn").disabled and hud.get_node("Hand").blocked())
	game.busy = false
	game.battle.energy = 3
	game.battle.hand = ["B02"]
	game.combat_ui()
	hud = game.ui.get_child(0)
	hud.drop_card(0,Vector2(310,350))
	await create_timer(2).timeout
	assert(game.battle.hand.is_empty() and game.battle.block >= 13)
	game.leave_combat()
	var visitor = load("res://visual/visitor/encounter.tscn").instantiate()
	game.ui.add_child(visitor)
	visitor.setup(game)
	visitor.start_duel()
	assert(visitor.phase == "combat")
	assert(visitor.get_node("HUD").get_child(0).get_node("Hand").cards.size() == visitor.battle.hand.size())
	await capture("res://tests/visitor-unified.png")
	game.queue_free()
	await create_timer(0.5).timeout
	print("COMBAT UI: PASS — shared hand, 12 cards, guard, Qi, valid targets, invalid drop, affordability, busy, visitor")
	quit()
