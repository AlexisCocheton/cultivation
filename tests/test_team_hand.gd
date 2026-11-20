extends SceneTree
var failures = 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, words: String) -> void:
	if not ok: failures += 1; push_error(words)
func mouse(point: Vector2, button: int = 0, down: bool = false) -> void:
	var event
	if button == 0:
		event = InputEventMouseMotion.new()
		event.position = point
	else:
		event = InputEventMouseButton.new()
		event.position = point
		event.button_index = button
		event.pressed = down
	Input.parse_input_event(event)
	await process_frame
func capture(name: String) -> void:
	if DisplayServer.get_name() == "headless": return
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/"+name+".png")
func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var screen = load("res://visual/team/lab.tscn").instantiate()
	root.add_child(screen)
	await process_frame
	var hand = screen.get_node("Hand")
	screen.battle.core.hand = ["B01","E05","B02","B03","B06"]
	screen.refresh()
	await process_frame
	var source = hand.global_position+hand.cards[0].home+Vector2(45,100)
	var target = screen.get_node("Units/Captain").position+Vector2(94,150)
	var hp = screen.battle.units[3].hp
	await mouse(source)
	await mouse(source,MOUSE_BUTTON_LEFT,true)
	await mouse(target)
	check(hand.dragging and screen.battle.core.energy == 2,"Dragging previews without spending")
	await create_timer(0.12).timeout
	await capture("hand-drag-target")
	await mouse(target,MOUSE_BUTTON_LEFT,false)
	while screen.busy: await process_frame
	check(screen.battle.units[3].hp == hp-6 and screen.battle.core.energy == 1,"Attack drop hits selected enemy once")
	var before = screen.battle.core.hand.duplicate()
	source = hand.global_position+hand.cards[0].home+Vector2(45,100)
	await mouse(source,MOUSE_BUTTON_LEFT,true)
	await mouse(Vector2(600,60))
	await mouse(Vector2(600,60),MOUSE_BUTTON_LEFT,false)
	check(screen.battle.core.hand == before and screen.battle.core.energy == 1,"Invalid drop is free")
	source = hand.global_position+hand.cards[0].home+Vector2(45,100)
	target = screen.get_node("Units/Jun").position+Vector2(94,150)
	await mouse(source,MOUSE_BUTTON_LEFT,true)
	await mouse(target)
	await mouse(target,MOUSE_BUTTON_LEFT,false)
	while screen.busy: await process_frame
	check(screen.battle.units[1].guard == 6,"Support drop protects chosen ally")
	screen.battle.core.energy = 1
	screen.refresh()
	source = hand.global_position+hand.cards[0].home+Vector2(45,100)
	before = screen.battle.core.hand.duplicate()
	var energy = screen.battle.core.energy
	await mouse(source,MOUSE_BUTTON_LEFT,true)
	await mouse(Vector2(600,200))
	await mouse(Vector2(600,200),MOUSE_BUTTON_RIGHT,true)
	check(not hand.dragging and screen.battle.core.hand == before and screen.battle.core.energy == energy,"Right click cancels drag without spending")
	await mouse(Vector2(600,200),MOUSE_BUTTON_LEFT,false)
	screen.battle.core.hand = ["B01","B03"]
	screen.battle.core.energy = 0
	screen.refresh()
	source = hand.global_position+hand.cards[0].home+Vector2(45,100)
	await mouse(source,MOUSE_BUTTON_LEFT,true)
	await mouse(Vector2(700,350))
	check(not hand.dragging and screen.battle.core.energy == 0,"Cannot drag unaffordable card")
	await mouse(Vector2(700,350),MOUSE_BUTTON_LEFT,false)
	source = hand.global_position+hand.cards[1].home+Vector2(45,100)
	target = screen.get_node("Units/Recruit").position+Vector2(94,150)
	await mouse(source,MOUSE_BUTTON_LEFT,true)
	await mouse(target)
	await mouse(target,MOUSE_BUTTON_LEFT,false)
	while screen.busy: await process_frame
	check(screen.battle.units[0].guard == 3,"Zero-cost self card can be dragged at zero qi")
	screen.battle.core.hand = ["B01","B02","B03","B04","B05","B06","B07","B08","L01","E05","H02","J01"]
	screen.battle.core.energy = 3
	screen.refresh()
	check(hand.cards.size() == 12,"Entire large hand rendered")
	for i in range(12):
		var point = hand.global_position+hand.cards[i].home+Vector2(15,130)
		check(hand.hit(point) == i,"Every card has a reachable strip")
	await mouse(Vector2(1100,500))
	await capture("hand-twelve-cards")
	source = hand.global_position+hand.cards[6].home+Vector2(15,130)
	await mouse(source)
	await create_timer(0.3).timeout
	await capture("hand-card-hover")
	screen.queue_free()
	await process_frame
	print("Team hand: ","PASS" if failures == 0 else "FAIL", " (",failures,")")
	quit(0 if failures == 0 else 1)
