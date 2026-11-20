extends Control
func setup(game) -> void:
	$Date.text = "Jour %d · %s" % [game.calendar.day(),["Matin","Après-midi","Soir"][game.calendar.period()]]
	$Cancel.pressed.connect(game.menu_ui)
	$Restart.pressed.connect(game.restart)
	$Cancel.grab_focus()
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		$Cancel.pressed.emit()
