extends SceneTree
var failures = 0
var checks = 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok: failures += 1; push_error(message)
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
	screen.switch_actor(1)
	screen.battle.core.hand = ["J01","J02","J03","B02"]
	screen.battle.units[0].hp = 39
	screen.battle.units[0].guard = 8
	screen.battle.units[3].hp = 26
	screen.battle.units[3].enraged = true
	screen.battle.units[5].guard = 6
	screen.battle.announce()
	screen.refresh()
	var hero = screen.get_node("Units/Recruit")
	var captain = screen.get_node("Units/Captain")
	var protector = screen.get_node("Units/Protector")
	check(hero.get_node("Health").text == "39/45","HP text contains only current and maximum")
	check(hero.get_node("HP").get_rect().encloses(hero.get_node("Health").get_rect()),"Numbers live inside health bar")
	check(hero.get_node("HP").tint_progress == protector.get_node("HP").tint_progress,"Allied and enemy guard use same jade colour")
	check(hero.get_node("HP").tint_progress != captain.get_node("HP").tint_progress,"Unshielded HP stays red")
	check(hero.get_node("GuardBadge/Value").text == "8" and not captain.get_node("GuardBadge").visible,"No zero guard badge")
	check(captain.get_node("Fury").visible and not captain.get_node("Status").text.contains("Furie"),"Fury uses compact seal instead of sentence")
	check(screen.get_node("Units/Jun/Select").visible,"Active fighter has ground strokes")
	screen.preview_intent(3)
	check(not screen.get_node("TargetLink").visible,"Intent hover draws no line")
	screen.select_card(2)
	screen.get_node("Hand").hovered = 2
	await create_timer(0.3).timeout
	screen.show_link(1,3)
	check(screen.get_node("TargetLink").visible and screen.get_node("TargetLink").points.size() == 41,"Card target uses sampled smooth curve")
	check(captain.get_node("Select").modulate.r > captain.get_node("Select").modulate.g,"Enemy target marked vermilion")
	await capture("ink-jade-combat")
	screen.clear_link()
	check(not screen.get_node("TargetLink").visible,"Target link clears")
	screen.cancel_selection()
	screen.battle.units[5].guard = 0
	screen.battle.units[3].hp = 0
	screen.refresh()
	check(not captain.get_node("Fury").visible and captain.get_node("Health").text == "Hors combat","Defeated fighter loses fury and shows clear state")
	check(not protector.get_node("GuardBadge").visible and protector.get_node("HP").tint_progress == captain.get_node("HP").tint_progress,"Depleted guard restores red HP")
	var tip = hero._make_custom_tooltip("Recrue · 39/45 PV\nGarde : absorbe les dégâts avant les PV. Le poison l’ignore.")
	root.add_child(tip)
	tip.position = Vector2(870,80)
	await process_frame
	check(tip.size.x <= 310 and tip.get_node("Text").autowrap_mode != 0,"Tooltip wraps into compact panel")
	await capture("ink-jade-states")
	tip.queue_free()
	screen.queue_free()
	await process_frame
	print("Ink combat UI: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
