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

func resolve(battle) -> void:
	battle.finished = [0,1,2]
	battle.begin_resolution()
	while not battle.queue.is_empty() and battle.outcome == "": battle.resolve_next()
	battle.finish_round()

func run() -> void:
	var b = Battle.new()
	b.start()
	check(b.units.size() == 6,"Six combattants")
	check(b.core.hand.has("E05"),"Protection disponible pour le test")
	check(b.core.hand.size()+b.core.pile.size() == 12,"Pas de carte ajoutée")
	var support = b.core.hand.find("E05")
	var energy = b.core.energy
	check(not b.play(support,4),"Impossible de protéger un adversaire")
	check(b.core.energy == energy,"Cible invalide sans coût")
	check(b.play(support,1),"Protection de Jun")
	check(b.units[1].guard == 6 and b.units[0].guard == 0,"Garde individuelle")
	check(b.core.hand.size() == 4,"Pioche du soutien conservée")
	b.finished = [0,1,2]
	b.begin_resolution()
	check(b.queue[0].kind == "guard","Protection avant attaque")
	check(not b.play(0,3),"Cartes bloquées pendant résolution")
	var announced = b.units[4].intent.duplicate()
	b.units[announced.target].hp = 0
	while not b.queue.is_empty() and b.outcome == "":
		var action = b.resolve_next()
		if action.source == 4:
			check(action.cancelled,"Action annulée sur cible KO")
			check(action.target == announced.target,"Pas de redirection")
	b.start()
	b.units[1].hp = 0
	b.finished = [0,1,2]
	b.begin_resolution()
	while not b.queue.is_empty() and b.outcome == "":
		var action = b.resolve_next()
		if action.source == 1: check(action.cancelled,"Allié KO ne joue pas")
	b.finish_round()
	check(b.units[0].guard == 0,"Garde expire")
	check(b.core.turn == 1 and b.core.energy == 2,"Manche suivante")
	b.start()
	b.core.hand = ["B01","B01","B01"]
	b.pill_used = true # Generic victory test; pill has its own transition tests.
	b.core.energy = 3
	b.units[3].hp = 1
	check(b.play(0,3),"Ciblage capitaine")
	check(b.outcome == "" and b.units[4].hp > 0,"Un ennemi KO ne conclut pas")
	b.units[4].hp = 1
	b.units[5].hp = 1
	b.play(0,4)
	b.play(0,5)
	check(b.outcome == "victory","Victoire trois adversaires KO")
	check(not b.begin_resolution(),"Pas de manche après victoire")
	b.start()
	b.units[0].hp = 0
	b.check_outcome()
	check(b.outcome == "defeat","Défaite recrue KO")
	b.start()
	b.core.hand = ["B07"]
	check(b.play(0,0),"Posture persistante")
	check(b.core.active.has("B07") and b.core.hand_limit == 12,"Persistance et taille main")
	resolve(b)
	check(b.core.hand.size() == 5,"Pioche persistante au prochain tour")
	b.start()
	check(b.core.active.is_empty(),"Relance réinitialise les pouvoirs")
	var wins = 0
	var turns = 0
	for seed_value in range(100):
		b.start(seed_value)
		for round_index in range(30):
			if b.outcome != "": break
			for member in b.living(0):
				if b.outcome != "": break
				b.select_actor(member)
				for play_index in range(30):
					if b.outcome != "": break
					var chosen = -1
					var target = b.actor
					var best = -1.0
					for i in range(b.core.hand.size()):
						var c: Dictionary = b.core.cards[b.core.hand[i]]
						if c.cost > b.core.energy: continue
						var next_target = b.actor
						if b.target_kind(i) == "enemy":
							next_target = b.living(1)[0]
							for foe in b.living(1):
								if b.units[foe].hp < b.units[next_target].hp: next_target = foe
						var score: float = (c.damage+c.draw*3+c.block*0.6)/maxf(1,c.cost)
						if score > best: best = score; chosen = i; target = next_target
					if chosen < 0: break
					check(b.play(chosen,target),"Action automatique légale")
				b.finished.append(member)
			if b.outcome == "": resolve(b)
		check(b.outcome != "","Combat terminé avant 30 manches")
		wins += int(b.outcome == "victory")
		turns += b.core.turn+1
	print("Team bot (100 seeds): %d wins, %.2f mean rounds" % [wins,turns/100.0])
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var screen = load("res://visual/team/lab.tscn").instantiate()
	root.add_child(screen)
	await process_frame
	check(screen.get_node("Units").get_child_count() == 6,"Six vues dans le moteur")
	var support_index = screen.battle.core.hand.find("E05")
	screen.select_card(support_index)
	check(screen.get_node("Units/Jun/Select").visible,"Cible alliée surlignée")
	check(not screen.get_node("Units/Captain/Select").visible,"Ennemi non sélectionnable pour soutien")
	if DisplayServer.get_name() != "headless":
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/team-battle.png")
	await screen.choose_target(1)
	check(screen.battle.units[1].guard == 6,"Clic protège Jun")
	await screen.end_turn()
	check(screen.battle.core.turn == 0 and screen.battle.actor == 1 and not screen.busy,"Fin du tour passe au compagnon")
	await screen.end_turn()
	await screen.end_turn()
	check(screen.battle.core.turn == 1,"Fin de manche après les trois personnages")
	screen.restart()
	check(screen.battle.core.turn == 0 and screen.battle.outcome == "","Relancer via UI")
	for i in range(6):
		var actor = screen.get_node("Units").get_child(i).get_node("Actor")
		check(actor.sprite != null,"Personnage en pied présent")
		check(actor.facing == (1.0 if i < 3 else -1.0),"Équipes face à face")
		if i >= 2:
			var idle_scale: Vector2 = actor.sprite.scale
			for pose in range(4):
				actor.action = "attack" if pose < 3 else "guard"
				actor.action_frame = pose if pose < 3 else 2
				actor._process(0)
				if i == 2 and pose < 3:
					check(actor.lian_attack.visible and not actor.sprite.visible,"Lian utilise les six poses")
					check(is_equal_approx(actor.lian_attack.scale.x,actor.lian_attack.BODY_SCALE),"Échelle de Lian constante")
					check(actor.lian_attack.get_node("Body").frame == pose,"Pose de Lian correcte")
				else:
					check(actor.sprite.hframes == 2 and actor.sprite.vframes == 2,"Planche individuelle 2 × 2")
					check(actor.sprite.scale == idle_scale,"Échelle constante entre les poses")
					check(actor.sprite.frame == pose,"Pose de l'arme correcte")
			actor.action = ""
			actor._process(0)
	screen.battle.core.hand = ["B01"]
	screen.battle.core.energy = 3
	screen.refresh()
	screen.select_card(0)
	var before_hp: int = screen.battle.units[3].hp
	screen.choose_target(3)
	await create_timer(0.1).timeout
	check(screen.busy and screen.battle.units[3].hp == before_hp,"Dégâts différés jusqu'au contact")
	screen.end_turn()
	check(screen.battle.core.turn == 0,"Entrées verrouillées pendant attaque")
	while screen.busy: await process_frame
	check(screen.battle.units[3].hp == before_hp-6,"Contact applique un seul coup")
	check(screen.get_node("Units/Recruit/Actor").position == Vector2(94,222),"Retour exact au point de départ")
	check(screen.get_node("Units/Recruit/Actor").action_history.has("attack"),"Animation dessinée de la recrue")
	await screen.end_turn()
	screen.battle.core.hand = ["J01"]
	screen.refresh()
	screen.select_card(0)
	await screen.choose_target(3)
	await screen.end_turn()
	screen.battle.core.hand = ["L02"]
	screen.refresh()
	screen.select_card(0)
	await screen.choose_target(0)
	await screen.end_turn()
	check(screen.get_node("Units/Jun/Actor").action_history.has("attack"),"Jun attaque")
	check(screen.get_node("Units/Lian/Actor").action_history.has("guard"),"Lian protège")
	check(screen.get_node("Units/Captain/Actor").action_history.has("attack"),"Adversaire attaque")
	screen.queue_free()
	await process_frame
	print("Team battle: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
