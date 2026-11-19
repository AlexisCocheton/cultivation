extends SceneTree

var failures = 0
var game
var contacted = 0

func _initialize() -> void:
	call_deferred("run")

func check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error(message)

func capture(name: String) -> void:
	if DisplayServer.get_name() == "headless": return
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/"+name+".png")

func run() -> void:
	root.content_scale_size = Vector2i(1280,832)
	root.size = Vector2i(1280,832)
	game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	for texture in [game.Avatar.SHEET,game.Avatar.FRONT_SHEET,game.Avatar.BACK_SHEET,game.Avatar.COMBAT_SHEET]:
		check(texture.get_image().get_pixel(0,0).a < 0.01,"Sprite background actually transparent")
	game.stage = 2
	game.start_combat()
	game.battle.hand = ["B01","B02","B06"]
	game.battle.pile = ["B01","B02","B03"]
	game.battle.discard.clear()
	var old_hp = game.battle.enemy_hp
	game.play_card(0)
	await create_timer(0.10).timeout
	check(game.busy and game.battle.enemy_hp == old_hp,"Damage waits for contact")
	game.end_turn()
	check(game.battle.turn == 0,"Input locked during attack")
	while game.player.action != "attack": await process_frame
	check(game.player.sprite.texture == game.Avatar.COMBAT_SHEET,"Attack uses drawn combat atlas")
	while game.player.action_frame != 2: await process_frame
	check(game.battle.enemy_hp == old_hp-6,"Damage resolved on strike pose")
	await capture("manhua-attack")
	while game.busy: await process_frame
	check(game.player.position == Vector2(310,482),"Attacker returns to exact starting position")
	await game.play_card(0)
	check(game.player.guarding and game.battle.block == 5,"Guard pose persists with protection")
	await process_frame
	check(game.player.sprite.frame == 10,"Recruit holds bracing frame")
	await capture("manhua-guard")
	var before = game.battle.hp
	await game.end_turn()
	check(game.battle.hp == before-1,"Enemy attack uses actual protection")
	check(game.actors[2].action_history.has("attack"),"Enemy visibly attacks")
	check(not game.player.guarding,"Expired block releases guard stance")
	before = game.battle.hp
	await game.end_turn()
	check(game.battle.hp == before,"Enemy guard turn does not inflict a hit")
	check(game.actors[2].guarding and game.battle.enemy_block == 5,"Enemy holds guard pose")
	check(game.actors[2].action_history.has("guard"),"Enemy guard is animated")
	game.battle.hand = ["B01"]
	game.battle.energy = 3
	old_hp = game.battle.enemy_hp
	await game.play_card(0)
	check(game.battle.enemy_hp == old_hp-1,"Guard absorbs five of six damage")
	game.reduced_motion = true
	await game.end_turn()
	check(not game.busy and game.player.action == "" and game.actors[2].action == "","Reduced motion completes animation lifecycle")
	game.leave_combat()
	check(not game.player.guarding and not game.actors[2].guarding,"Returning to hub clears poses")
	game.sound.stop()
	game.sound.stream = null
	game.queue_free()
	await process_frame
	await create_timer(0.4).timeout
	print("COMBAT ANIMATION TESTS: ", "PASS" if failures == 0 else "FAIL")
	quit(0 if failures == 0 else 1)
