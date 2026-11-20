extends SceneTree
const Battle = preload("res://game/team_battle.gd")
var failures = 0
var checks = 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok: failures += 1; push_error(message)
func run() -> void:
	var b = Battle.new()
	b.start()
	b.resolving = true
	b.units[3].guard = 8
	b.units[0].guard = 5
	b.finish_round()
	check(b.units[3].guard == 8 and b.units[0].guard == 0,"Only enemy guard persists into next player phase")
	b.core.hand = ["B01","B01"]
	var hp = b.units[3].hp
	b.play(0,3)
	check(b.units[3].hp == hp and b.units[3].guard == 2,"Enemy guard blocks player damage")
	b.play(0,3)
	check(b.units[3].hp == hp-4 and b.units[3].guard == 0,"Guard depleted before HP")
	b.units[3].guard = 8
	b.finished = [0,1,2]
	b.begin_resolution()
	check(b.units[3].guard == 0,"Previous guard expires before new resolution, no indefinite stacking")
	for id in b.core.cards:
		if b.core.cards[id].block <= 0: continue
		b.start()
		b.core.hand = [id]
		b.units[0].guard = 4
		b.units[1].guard = 2
		var damage: int = b.core.cards[id].damage
		check(b.valid_target(0,1) == (damage == 0),"Only pure guard accepts Jun: "+id)
		var result = b.play(0,3) if damage > 0 else b.play(0,1)
		check(result,"Guard card plays: "+id)
		check(b.units[1].guard == 2+(b.core.cards[id].block if damage == 0 else 0) and b.units[0].guard == 4+(b.core.cards[id].block if damage > 0 else 0),"Guard applied to correct recipient: "+id)
		if b.core.cards[id].persistent: check(b.core.active.has(id),"Persistent power stays with recruit: "+id)
	b.start()
	b.core.hand = ["B02"]
	b.units[1].hp = 0
	check(not b.play(0,1) and b.core.energy == 2,"Cannot protect defeated ally")
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var screen = load("res://visual/team/lab.tscn").instantiate()
	root.add_child(screen)
	await process_frame
	screen.battle.units[3].guard = 8
	screen.refresh()
	var captain = screen.get_node("Units/Captain")
	var attacker = screen.get_node("Units/Attacker")
	check(captain.get_node("HP").tint_progress == Color("518f91"),"Shielded enemy HP turns blue")
	check(attacker.get_node("HP").tint_progress != captain.get_node("HP").tint_progress,"HP styles are not shared")
	if DisplayServer.get_name() != "headless":
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/enemy-guard-blue.png")
	screen.battle.units[3].guard = 0
	screen.refresh()
	check(captain.get_node("HP").tint_progress == attacker.get_node("HP").tint_progress,"HP returns red at zero guard")
	screen.battle.core.hand = ["J01"]
	screen.battle.core.energy = 3
	screen.refresh()
	var hp_before = screen.battle.units[3].hp
	screen.select_card(0)
	await screen.choose_target(1)
	check(screen.battle.core.energy == 3,"Mixed card rejects ally without cost")
	await screen.choose_target(3)
	check(screen.battle.units[3].hp == hp_before-6 and screen.battle.units[0].guard == 3 and screen.battle.units[1].guard == 0,"Mixed card attacks enemy and protects recruit")
	check(screen.battle.core.energy == 2,"Mixed card paid once")
	screen.queue_free()
	await process_frame
	print("Team guard rules: ",checks," checks, ",failures," failures")
	quit(0 if failures == 0 else 1)
