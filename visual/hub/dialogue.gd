extends Control

func setup(game, index: int, happy: bool, words: String, choice: String, action: Callable) -> void:
	var texture = AtlasTexture.new()
	texture.atlas = preload("res://assets/hub/portraits.png")
	var cell = texture.atlas.get_size() / Vector2(3,2)
	texture.region = Rect2(Vector2(index-1,int(happy))*cell,cell)
	$Portrait.texture = texture
	$Portrait.visible = not ((index == 1 and game.location == "garden") or (index == 3 and game.location == "pavilion"))
	$Paper/Name.text = ["","Lian","Jun","Maître Shen"][index]
	$Paper/Words.text = words
	$Choice.text = choice
	$Choice.pressed.connect(action)
	$Back.pressed.connect(game.return_to_location)
	if index == 2:
		$Activity.visible = true
		var reason = game.calendar.reason("J")
		if game.stage < 1: reason = "Apprends d'abord une technique auprès de Lian."
		if game.calendar.slot >= game.Progress.END_SLOT: reason = "Cette séquence est terminée à la fin du jour 4."
		$Activity.disabled = reason != ""
		$Activity.tooltip_text = reason if reason != "" else "Entraînement avec Jun · progression du lien"
		$Activity.pressed.connect(func(): game.resident_activity("J"))

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		$Back.pressed.emit()
