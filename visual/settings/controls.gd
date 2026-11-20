extends Control
var pending = ""
func _ready() -> void:
	for action in InputBindings.ACTIONS:
		get_node("Paper/"+action).pressed.connect(func(): pending = action; $Paper/Notice.text = "Appuie sur une touche. Échap : annuler.")
	$Paper/Back.pressed.connect(queue_free)
	$Paper/Reset.pressed.connect(func(): $Paper/Notice.text = InputBindings.reset_bindings(); refresh())
	refresh()
func refresh() -> void:
	for action in InputBindings.ACTIONS:
		get_node("Paper/"+action).text = InputBindings.label_for(action)
func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo: return
	if pending != "":
		get_viewport().set_input_as_handled()
		if event.keycode == KEY_ESCAPE: pending = ""; $Paper/Notice.text = ""; return
		var error = InputBindings.rebind(pending,event.physical_keycode)
		$Paper/Notice.text = error
		if error == "": pending = ""
		refresh()
	elif event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()
