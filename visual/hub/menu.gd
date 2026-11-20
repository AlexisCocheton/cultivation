extends Control

func setup(game) -> void:
	$Paper/Date.text = "Jour %d · %s" % [game.calendar.day(),["Matin","Après-midi","Soir"][game.calendar.period()]]
	$Close.pressed.connect(game.hub)
	$Paper/Back.grab_focus()
	$ControlsButton.pressed.connect(func():
		if not has_node("Controls"): add_child(preload("res://visual/settings/controls.tscn").instantiate()))
	$Candidates.visible = not game.calendar.story.battle_report.is_empty()
	$Candidates.pressed.connect(func(): game.story_ui("candidates"))
	$Paper/Companions.pressed.connect(game.companions_ui)
	$Paper/Back.pressed.connect(game.hub)
	$Paper/Deck.pressed.connect(game.deck_ui)
	$Paper/Restart.pressed.connect(game.confirm_restart)
	$Paper/Sound.text = "Son : " + ("non" if game.muted else "oui")
	$Paper/Motion.text = "Effets : " + ("doux" if game.reduced_motion else "oui")
	$Paper/Sound.pressed.connect(func():
		game.muted = not game.muted
		game.save_progress()
		$Paper/Sound.text = "Son : " + ("non" if game.muted else "oui"))
	$Paper/Motion.pressed.connect(func():
		game.reduced_motion = not game.reduced_motion
		game.save_progress()
		$Paper/Motion.text = "Effets : " + ("doux" if game.reduced_motion else "oui"))

func _unhandled_key_input(event: InputEvent) -> void:
	if has_node("Controls"): return
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		$Paper/Back.pressed.emit()
