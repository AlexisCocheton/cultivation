extends Control
var game
var selected = -1
var busy = false
func setup(controller) -> void:
	game = controller
	busy = game.busy
	var b = game.battle
	$Title.text = "Jun · Tutoriel" if b.training_level == 0 else "Jun · Entraînement %d / 4" % b.training_level
	if b.profile == "visiteuse": $Title.text = "Le défi de la voyageuse"
	for side in ["Recruit","Enemy"]:
		var own = side == "Recruit"
		var panel = get_node(side)
		var hp: int = b.hp if own else b.enemy_hp
		var maximum: int = b.max_hp if own else b.enemy_max
		var guard: int = b.block if own else b.enemy_block
		panel.get_node("Name").text = "Recrue" if own else ("Voyageuse" if b.profile == "visiteuse" else "Jun")
		panel.get_node("HP").max_value = maximum
		panel.get_node("HP").value = hp
		panel.get_node("HP").tint_progress = Color("518f91") if guard > 0 else Color("c22e31")
		panel.get_node("Health").text = "%d / %d" % [hp,maximum]
		panel.get_node("GuardBadge").visible = guard > 0
		panel.get_node("GuardBadge/Value").text = str(guard)
		panel.tooltip_text = "%d garde" % guard
		if not own and b.exposed: panel.tooltip_text += " · Exposé +50 %"
	$Intent.setup(game.actors[2],b.intent())
	$Qi.set_energy(b.energy,3)
	$Qi.tooltip_text = "Qi disponible : %d · Recharge à 3 par tour." % b.energy
	$Counts.text = "Pioche %d · Défausse %d\nRetirées %d · Persistantes %d" % [b.pile.size(),b.discard.size(),b.removed.size(),b.active.size()]
	$Counts.tooltip_text = "Force +%d · Main %d/%d · Pioche/tour %d" % [b.strength,b.hand.size(),b.hand_limit,5+b.active.count("B07")]
	$Sound.text = "Son : " + ("non" if game.muted else "oui")
	$Motion.text = "Effets : " + ("doux" if game.reduced_motion else "oui")
	$Sound.pressed.connect(func(): game.muted = not game.muted; game.save_progress(); $Sound.text = "Son : " + ("non" if game.muted else "oui"))
	$Motion.pressed.connect(func(): game.reduced_motion = not game.reduced_motion; game.save_progress(); $Motion.text = "Effets : " + ("doux" if game.reduced_motion else "oui"))
	$EndTurn.disabled = busy
	$Leave.disabled = busy
	if b.outcome != "" and game.has_method("finish_combat"):
		$EndTurn.text = "Enregistrer"
		$EndTurn.pressed.connect(game.finish_combat)
		$SaveError.text = game.notice
		$SaveError.show()
	else: $EndTurn.pressed.connect(game.end_turn)
	$Leave.pressed.connect(game.leave_combat)
	$Hand.setup(self)
	$Hand.rebuild()
func target_rect(index: int) -> Rect2:
	var kind: String = game.battle.target_kind(index)
	if kind == "invalid": return Rect2()
	var own: bool = kind != "enemy"
	return Rect2(190,220,240,320) if own else Rect2(845,220,240,320)
func select_card(index: int) -> void:
	if not $Hand.can_play(index): return
	selected = index
	$Hand.rebuild()
func begin_card_drag(index: int) -> void:
	selected = index
func preview_card_drop(index: int, point: Vector2) -> void:
	$TargetMarker.visible = target_rect(index).has_point(point)
	$TargetMarker.position = Vector2(target_rect(index).get_center().x-70,470)
func drop_card(index: int, point: Vector2) -> void:
	if $Hand.can_play(index) and target_rect(index).has_point(point):
		game.play_card(index)
	else: cancel_selection()
func cancel_selection() -> void:
	selected = -1
	$TargetMarker.hide()
	$Hand.rebuild()
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		cancel_selection()
		get_viewport().set_input_as_handled()
	elif selected >= 0 and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		drop_card(selected,event.position)

# Hand widgets know this presentation contract, not encounter-specific internals.
func hand_model():
	return game.battle
func can_play_card(index: int) -> bool:
	return game.battle.can_play(index)
func hand_blocked() -> bool:
	return game == null or busy or game.battle.outcome != ""
