extends SceneTree
const Battle = preload("res://game/team_battle.gd")
var checks = 0
var failures = 0

func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run")

func strike(b, guard: int) -> void:
	b.units[0].guard = guard
	b.resolving = true
	b.queue = [{"source":4,"target":0,"kind":"poison","value":9,"poison":9}]
	b.resolve_next()

func run() -> void:
	var b = Battle.new()
	b.start()
	check(b.units[3].intent.value == 12 and b.units[4].intent.value == 9,"Higher opening damage announced")
	check(b.units[4].intent.kind == "attack" and b.units[4].intent.poison == 0,"First round: normal daggers")
	b.finished = [0,1,2]
	b.begin_resolution()
	while not b.queue.is_empty(): b.resolve_next()
	check(not b.coated and b.events.is_empty(),"No poison event during first round")
	b.finish_round()
	check(b.core.turn == 1 and b.units[4].intent.kind == "coat","Coating announced for second round")
	check(b.units[5].intent.value == 8,"Spear attack increased")
	b.finished = [0,1,2]
	b.begin_resolution()
	while not b.queue.is_empty(): b.resolve_next()
	check(b.coated,"Dagues enduites après l'action")
	check(b.units[0].poison == 0 and b.units[1].poison == 0,"Pas d'empoisonnement immédiat")
	b.finish_round()
	check(b.units[4].intent.poison == 9,"Poison annoncé au tour suivant")
	b.start()
	strike(b,0)
	check(b.units[0].hp == 36 and b.units[0].poison == 9,"Unblocked daggers deal nine direct plus nine poison")
	b.finish_round()
	check(b.units[0].hp == 27 and b.units[0].poison == 8,"Poison tick adds nine damage after the direct hit")
	b.start()
	strike(b,100)
	check(b.units[0].poison == 9 and b.units[0].hp == 45 and b.units[0].guard == 91,"Guard absorbs direct damage but cannot block poison")
	b.finish_round()
	check(b.units[0].hp == 36 and b.units[0].poison == 8,"First tick deals nine then decrements")
	strike(b,100)
	check(b.units[0].poison == 17 and b.units[0].hp == 36,"Next hit stacks nine on remaining eight")
	b.finish_round()
	check(b.units[0].hp == 19 and b.units[0].poison == 16,"Stacked poison ticks at seventeen")
	strike(b,0)
	strike(b,0)
	check(b.units[0].poison == 34,"No old six-stack cap")
	b.units[0].hp = 1
	b.queue.clear()
	b.finish_round()
	check(b.outcome == "defeat","Poison peut vaincre la recrue")
	for survivor in [3,4,5]:
		b.start()
		b.coated = true
		b.announce()
		for i in [3,4,5]:
			if i != survivor: b.units[i].hp = 0
		b.units[survivor].hp = 3
		b.units[survivor].poison = 5
		b.finished = [0,1,2]
		b.begin_resolution()
		b.check_outcome()
		check(b.pill_used and b.pill_target == survivor,"Pilule pour chaque survivant")
		check(b.units[survivor].hp == b.units[survivor].max_hp,"Tous les PV restaurés")
		check(b.units[survivor].poison == 0,"Malus poison purgé")
		check(b.units[survivor].intent.kind == "recover","Récupération annoncée")
		check(b.queue.all(func(a): return a.source != survivor),"Action du survivant retirée de la file")
		var count = b.events.size()
		b.units[survivor].hp = 2
		b.check_outcome()
		check(b.units[survivor].hp == 2 and b.events.size() == count,"Pilule ne se répète pas")
		b.core.turn = 1
		b.announce()
		var boosted: int = b.units[survivor].intent.value
		b.units[survivor].enraged = false
		b.announce()
		check(boosted == int(ceil(b.units[survivor].intent.value*1.5)),"Dégâts renforcés déjà inclus dans intention")
	b.start()
	for i in [3,4,5]: b.units[i].hp = 0
	b.check_outcome()
	check(b.outcome == "victory" and not b.pill_used,"Aucune résurrection si trois KO")
	b.start()
	b.units[3].hp = 0
	b.units[4].hp = 0
	b.units[0].hp = 0
	b.check_outcome()
	check(b.outcome == "defeat" and not b.pill_used,"Pas d'intervention après défaite")
	b.start()
	check(not b.coated and not b.pill_used and b.events.is_empty(),"Retenter réinitialise les tricheries")
	# During player input, recovery does not discard cards or steal remaining energy.
	b.units[3].hp = 0
	b.units[4].hp = 1
	b.units[5].hp = 3
	b.core.hand = ["B01","B02"]
	b.play(0,4)
	check(b.core.energy == 1 and b.core.hand == ["B02"],"Pilule ne vole pas le tour du joueur")
	check(b.units[5].intent.kind == "recover","Récupération avant la fin du tour")
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var screen = load("res://visual/team/lab.tscn").instantiate()
	root.add_child(screen)
	await process_frame
	screen.battle.units[0].guard = 11
	screen.refresh()
	var recruit = screen.get_node("Units/Recruit")
	check(recruit.get_node("GuardBadge").visible and recruit.get_node("GuardBadge/Value").text == "11","Guard badge shows actual protection")
	screen.battle.units[0].guard = 0
	screen.refresh()
	check(not recruit.get_node("GuardBadge").visible and recruit.get_node("Actor").guard_break > 0,"Guard break removes badge and triggers feedback")
	screen.battle.coated = true
	screen.battle.units[1].poison = 3
	screen.battle.announce()
	screen.refresh()
	check(screen.get_node("Units/Attacker/Intent/Icon").texture == screen.get_node("Units/Attacker").SWORD and screen.get_node("Units/Attacker/Intent/Value").text == "9" and screen.get_node("Units/Attacker/Intent/PoisonValue").text == "9" and screen.get_node("Units/Attacker/Intent/Poison").visible,"Intention shows nine direct and nine poison separately")
	check(screen.get_node("Units/Jun/Status").text == "Poison 3","Statut sur la cible")
	if DisplayServer.get_name() != "headless":
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/team-poison.png")
	screen.battle.units[3].hp = 0
	screen.battle.units[4].hp = 1
	screen.battle.units[5].hp = 3
	screen.battle.core.hand = ["B01"]
	screen.refresh()
	screen.select_card(0)
	screen.choose_target(4)
	var elapsed = 0.0
	while not screen.get_node("EventPanel").visible and elapsed < 5.0:
		await create_timer(0.05).timeout
		elapsed += 0.05
	check(screen.get_node("EventPanel").visible,"Annonce de pilule visible")
	check(screen.busy,"Entrées verrouillées pendant le lancer")
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/team-pill.png")
	while screen.busy: await process_frame
	check(screen.battle.pill_used and screen.get_node("Units/Protector/Actor").enraged,"Aura de furie active")
	check(screen.battle.events.is_empty(),"Événement consommé une fois")
	screen.restart()
	check(not screen.battle.pill_used and not screen.get_node("Units/Protector/Actor").enraged,"Relance nettoie la furie")
	screen.queue_free()
	await process_frame
	print("Team tricks: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
