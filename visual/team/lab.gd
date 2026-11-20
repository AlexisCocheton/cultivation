extends Control

const TeamBattle = preload("res://game/team_battle.gd")
var battle = TeamBattle.new()
var selecting_antidote = false
var selected = -1
var busy = false
var last_seed = 7
var host = null
var party_draft: Array = []

func _ready() -> void:
	get_window().title = "Les Cendres du Prunier — Laboratoire 3 contre 3 (sans sauvegarde)"
	$Hand.setup(self)
	$TeamSetup.visible = host == null
	$TeamSetup.pressed.connect(open_team_setup)
	$LabParty/Close.pressed.connect(func(): $LabParty.hide(); refresh())
	$LabParty/Apply.pressed.connect(apply_team_setup)
	for i in range(3):
		var id: String = ["J","L","H"][i]
		$LabParty/Choices.get_child(i).pressed.connect(func():
			if party_draft.has(id): party_draft.erase(id)
			elif party_draft.size() < 2: party_draft.append(id)
			refresh_team_setup())
	$Antidote.pressed.connect(func(): selected = -1; selecting_antidote = not selecting_antidote; refresh())
	$EndTurn.pressed.connect(end_turn)
	$Restart.pressed.connect(restart)
	$Cancel.pressed.connect(cancel_selection)
	$Help.pressed.connect(func(): $HelpPaper.show())
	$HelpPaper/Close.pressed.connect(func(): $HelpPaper.hide(); $Help.grab_focus())
	$Quit.pressed.connect(leave)
	$Continue.pressed.connect(finish_campaign)
	for i in range(6):
		var index = i
		var view = $Units.get_child(i)
		view.pressed.connect(func():
			if selecting_antidote:
				if battle.use_antidote(index): selecting_antidote = false; refresh()
			elif selected < 0 and index < 3: switch_actor(index)
			else: choose_target(index))
		view.mouse_entered.connect(func(): preview_intent(index))
		view.focus_entered.connect(func(): preview_intent(index))
		view.mouse_exited.connect(func():
			if not $Hand.dragging: clear_link())
		view.focus_exited.connect(clear_link)
	for i in range(3):
		var index = i
		$Party.get_child(i).icon = preload("res://visual/team/unit.gd").head(i)
		$Party.get_child(i).pressed.connect(func(): switch_actor(index))
	if host == null:
		battle.start(last_seed)
	else:
		battle.antidotes_initial = host.calendar.story.antidote
		battle.relation_ranks = host.calendar.ranks.duplicate()
		battle.party = host.calendar.party.duplicate()
		last_seed = 7007
		battle.start(last_seed,host.calendar.deck,false)
		$Quit.text = "Retour"
		$Quit.tooltip_text = "Revenir à la préparation du jour 7"
		$HelpPaper/Words.text = $HelpPaper/Words.text.replace("Ce laboratoire ne touche pas à ta sauvegarde.","La préparation est sauvegardée avant le combat. Une défaite permet de réessayer.")
		get_window().title = "Les Cendres du Prunier — Jour 7"
	refresh()

func restart() -> void:
	if busy: return
	if host != null and battle.outcome != "defeat": return
	if host == null: last_seed += 1
	selected = -1
	battle.start(last_seed,TeamBattle.DECK if host == null else host.calendar.deck,host == null)
	refresh()

func cancel_selection() -> void:
	if busy: return
	selected = -1
	selecting_antidote = false
	refresh()

func refresh() -> void:
	$Antidote.visible = battle.antidotes > 0 and battle.outcome == ""
	$Antidote.text = "Choisir un allié empoisonné" if selecting_antidote else "Antidote · %d" % battle.antidotes
	$Antidote.disabled = busy or battle.finished.has(battle.actor)
	clear_link()
	for i in range(6):
		$Units.get_child(i).present(battle,i,(selected >= 0 and selection_valid(i)) or (selecting_antidote and i < 3 and battle.units[i].hp > 0 and battle.units[i].poison > 0))
	for i in range(3):
		var tab = $Party.get_child(i)
		tab.icon = preload("res://visual/team/unit.gd").head(battle.units[i].appearance)
		tab.disabled = busy or not battle.can_select_actor(i)
		tab.button_pressed = battle.actor == i
		tab.text = battle.units[i].name + (" ✓" if battle.finished.has(i) else "")
		tab.tooltip_text = "Tour terminé" if battle.finished.has(i) else ("Termine le tour en cours avant de changer" if not battle.can_select_actor(i) else "Jouer les cartes de " + battle.units[i].name)
	$EndTurn.text = "Terminer · " + battle.units[battle.actor].name
	$Qi.tooltip_text = "Qi de " + battle.units[battle.actor].name
	$Qi.set_energy(battle.core.energy)
	$Qi.tooltip_text = "Qi de %s : %d · Recharge à 2 par manche." % [battle.units[battle.actor].name,battle.core.energy]
	$Counts.text = "Pioche %d · Défausse %d\nPersistantes %d · Main max. %d" % [battle.core.pile.size(),battle.core.discard.size(),battle.core.active.size(),battle.core.hand_limit]
	$EndTurn.disabled = busy or $LabParty.visible or battle.outcome != ""
	$Restart.disabled = busy
	$Restart.visible = host == null or battle.outcome == "defeat"
	$Continue.visible = host != null and battle.outcome == "victory"
	$Continue.disabled = busy
	$Quit.disabled = busy
	$EndTurn.visible = not $Continue.visible
	$PillReserve.modulate.a = 0.25 if battle.pill_used else 1.0
	$PillReserve.tooltip_text = "Pilule déjà utilisée." if battle.pill_used else "Le chef rival garde une pilule : son dernier disciple retrouvera tous ses PV et gagnera +50 % d'attaque. Une seule fois."
	$Cancel.visible = (selected >= 0 or selecting_antidote) and not busy
	$Result.visible = battle.outcome != ""
	$Result/Words.text = "Victoire" if battle.outcome == "victory" else "Défaite"
	$Hand.rebuild()

func select_card(index: int) -> void:
	if hand_blocked() or not battle.can_play(index): return
	selecting_antidote = false
	selected = index
	if battle.target_kind(index) == "self": choose_target(battle.actor)
	else: refresh()

func choose_target(index: int) -> void:
	if busy or $LabParty.visible or selected < 0 or not selection_valid(index): return
	var card_index = selected
	var kind = "attack" if battle.core.cards[battle.core.hand[selected]].damage > 0 else "guard"
	selected = -1
	busy = true
	refresh()
	await animate_action(battle.actor,index,kind,func(): battle.play(card_index,index))
	await play_events()
	busy = false
	refresh()

func end_turn() -> void:
	if busy or $LabParty.visible or battle.outcome != "": return
	selected = -1
	selecting_antidote = false
	if not battle.end_actor_turn():
		refresh()
		return
	busy = true
	refresh()
	while not battle.queue.is_empty() and battle.outcome == "":
		var action: Dictionary = battle.queue[0]
		if battle.units[action.source].hp <= 0 or battle.units[action.target].hp <= 0:
			battle.resolve_next()
			refresh()
		else:
			await animate_action(action.source,action.target,"attack" if action.kind == "poison" else action.kind,func(): battle.resolve_next())
		await play_events()
	battle.finish_round()
	await play_events()
	busy = false
	refresh()

func animate_action(source: int, target: int, kind: String, contact: Callable) -> void:
	var actor = $Units.get_child(source).get_node("Actor")
	var victim = $Units.get_child(target).get_node("Actor")
	var origin: Vector2 = actor.position
	$Units.get_child(target).set_marker(false,true,target >= 3)
	if kind == "attack":
		var approach = create_tween()
		approach.tween_property(actor,"position:x",origin.x+actor.facing*34.0,0.13)
		await approach.finished
	await actor.perform_action(kind,func():
		var before_hp: int = battle.units[target].hp
		var before_guard: int = battle.units[target].guard
		var before_poison: int = battle.units[target].poison
		contact.call()
		refresh()
		var loss: int = before_hp-battle.units[target].hp
		var absorbed: int = maxi(0,before_guard-battle.units[target].guard)
		$Impact.position = $Units.get_child(target).position+Vector2(65,120)
		$Impact.text = "−%d" % loss if loss > 0 else ("+%d garde" % maxi(0,battle.units[target].guard-before_guard) if kind == "guard" else "Bloqué")
		if kind == "attack" and absorbed > 0:
			$Impact.text = "−%d garde" % absorbed if loss == 0 else "−%d PV · −%d garde" % [loss,absorbed]
		if kind == "coat": $Impact.text = "Dagues enduites"
		if battle.units[target].poison > before_poison: $Impact.text += " · +%d poison" % (battle.units[target].poison-before_poison)
		$Impact.visible = loss > 0 or battle.units[target].guard > before_guard or kind in ["attack","coat"]
		if kind == "attack":
			var recoil = create_tween()
			recoil.tween_property(victim,"position:x",94.0+actor.facing*9.0,0.06)
			recoil.tween_property(victim,"position:x",94.0,0.12)
	)
	if kind == "attack":
		var retreat = create_tween()
		retreat.tween_property(actor,"position",origin,0.16)
		await retreat.finished
	$Impact.hide()
	refresh()

func play_events() -> void:
	while not battle.events.is_empty():
		var event: Dictionary = battle.events.pop_front()
		var destination: Vector2 = $Units.get_child(event.target).position+Vector2(75,130)
		if event.kind == "pill":
			$EventPanel/Words.text = "Pilule interdite\n%s : PV restaurés · Attaque +50 %%" % battle.units[event.target].name
			$EventPanel.show()
			$FlyingPill.position = $PillReserve.position
			$FlyingPill.show()
			var flight = create_tween()
			flight.tween_property($FlyingPill,"position",destination+Vector2(0,-65),0.3)
			flight.tween_property($FlyingPill,"position",destination,0.22)
			await flight.finished
			$FlyingPill.hide()
			await get_tree().create_timer(1.8).timeout
			$EventPanel.hide()
		elif event.kind == "coat":
			$EventPanel/Words.text = "Dagues empoisonnées"
			$EventPanel.show()
			await get_tree().create_timer(1.2).timeout
			$EventPanel.hide()
		elif event.kind == "poison":
			$Impact.position = destination
			$Impact.text = "Poison −%d" % event.value
			$Impact.show()
			await get_tree().create_timer(0.45).timeout
			$Impact.hide()
	refresh()

func preview_intent(index: int) -> void:
	if busy or $Hand.dragging or selected < 0: return
	if selection_valid(index): show_link(battle.actor,index)

func show_link(source: int, target: int) -> void:
	if selected < 0 or busy: return
	var a: Vector2 = $Units.get_child(source).position+Vector2(94,160)
	if selected < $Hand.cards.size():
		var card = $Hand.cards[selected]
		a = card.get_global_transform_with_canvas()*Vector2(97,8)
	var b: Vector2 = $Units.get_child(target).position+Vector2(94,145)
	var bend = Vector2(a.x+(b.x-a.x)*0.18,minf(a.y,b.y)-75)
	var points = PackedVector2Array()
	for i in range(41):
		var t = float(i)/40
		points.append((1-t)*(1-t)*a+2*(1-t)*t*bend+t*t*b)
	$TargetLink.points = points
	$TargetLink.visible = true
	$Units.get_child(target).set_marker(false,true,target >= 3)
	$Units.get_child(target).get_node("Select").modulate.a = 1.0

func clear_link() -> void:
	$TargetLink.hide()
	for i in range(6):
		var alive: bool = battle.units[i].hp > 0
		$Units.get_child(i).set_marker(alive and i == battle.actor and not battle.resolving,alive and (selected >= 0 and selection_valid(i)) or (selecting_antidote and i < 3 and battle.units[i].hp > 0 and battle.units[i].poison > 0),i >= 3)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		$HelpPaper.hide()
		$LabParty.hide()
		cancel_selection()

func leave() -> void:
	if busy: return
	if host == null: get_tree().quit()
	elif battle.outcome == "victory": finish_campaign()
	else: host.hub()

func finish_campaign() -> void:
	if host == null or busy or battle.outcome != "victory": return
	if not host.finish_territory(): $Result/Words.text = "Échec de sauvegarde"

func begin_card_drag(index: int) -> void:
	if busy or not $Hand.can_play(index): return
	selecting_antidote = false
	selected = index
	for i in range(6): $Units.get_child(i).get_node("Select").visible = selection_valid(i)

func drop_target(index: int, point: Vector2) -> int:
	for i in range(6):
		if $Units.get_child(i).get_global_rect().has_point(point) and battle.valid_target(index,i): return i
	return -1

func preview_card_drop(index: int, point: Vector2) -> void:
	clear_link()
	var target = drop_target(index,point)
	if target >= 0: show_link(battle.actor,target)

func drop_card(index: int, point: Vector2) -> void:
	if busy or not $Hand.can_play(index):
		cancel_selection()
		return
	var target = drop_target(index,point)
	if target < 0:
		cancel_selection()
		return
	selecting_antidote = false
	selected = index
	choose_target(target)

func selection_valid(target: int) -> bool:
	return selected >= 0 and battle.valid_target(selected,target)

func switch_actor(index: int) -> void:
	if busy or $LabParty.visible or $Hand.dragging: return
	if battle.select_actor(index):
		selected = -1
		refresh()

func open_team_setup() -> void:
	if host != null or busy: return
	party_draft = battle.party.duplicate()
	$LabParty/Mastery.button_pressed = int(battle.relation_ranks.get("J",0)) >= 5
	refresh_team_setup()
	$LabParty.show()
	refresh()

func refresh_team_setup() -> void:
	for i in range(3):
		var chosen = party_draft.has(["J","L","H"][i])
		var button = $LabParty/Choices.get_child(i)
		button.button_pressed = chosen
		button.text = ("✓ " if chosen else "") + ["Jun","Lian","Shen"][i]
	$LabParty/Apply.disabled = party_draft.size() != 2

func apply_team_setup() -> void:
	if host != null or busy or party_draft.size() != 2: return
	battle.party = party_draft.duplicate()
	var rank = 5 if $LabParty/Mastery.button_pressed else 3
	battle.relation_ranks = {"J":rank,"L":rank,"H":rank}
	$LabParty.hide()
	restart()

func hand_model():
	return battle.core
func can_play_card(index: int) -> bool:
	return battle.can_play(index)
func hand_blocked() -> bool:
	return busy or $HelpPaper.visible or $LabParty.visible or battle.outcome != ""
