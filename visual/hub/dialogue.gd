extends Control
const CampaignSession = preload("res://game/campaign/session.gd")

func setup(game, index: int, happy: bool, words: String, choice: String, action: Callable) -> void:
	var texture = AtlasTexture.new()
	texture.atlas = preload("res://assets/hub/portraits.png")
	var cell = texture.atlas.get_size() / Vector2(3,2)
	texture.region = Rect2(Vector2(index-1,int(happy))*cell,cell)
	$Portrait.texture = texture
	if index == 2:
		var portrait_path = "res://assets/ui/companions/jun-happy.png" if happy else "res://assets/ui/companions/jun.png"
		if ResourceLoader.exists(portrait_path): $Portrait.texture = load(portrait_path)
	$Portrait.visible = not ((index == 1 and game.location == "garden") or (index == 3 and game.location == "pavilion"))
	$Paper/Name.text = ["","Lian","Jun","Maître Shen"][index]
	$Paper/TextScroll/Words.text = words
	$Choice.text = choice
	$Choice.pressed.connect(action)
	$Back.pressed.connect(game.return_to_location)
	$Hide.pressed.connect(func():
		var show_text = not $Paper.visible
		$Paper.visible = show_text
		$Choice.visible = show_text
		$Activity.visible = show_text and index == 2
		$Hide.text = "Masquer le texte" if show_text else "Afficher le texte")
	if index == 2:
		$Activity.visible = true
		var reason = game.calendar.reason("J")
		if game.stage < CampaignSession.Stage.TECHNIQUE_LEARNED: reason = "Apprends d'abord une technique auprès de Lian."
		if game.calendar.slot >= game.Progress.END_SLOT: reason = "Cette séquence est terminée à la fin du jour 7."
		$Activity.disabled = reason != ""
		$Activity.tooltip_text = reason if reason != "" else "Entraînement avec Jun · progression du lien"
		$Activity.pressed.connect(func(): game.resident_activity("J"))

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		$Back.pressed.emit()
