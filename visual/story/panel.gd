extends Control
var game
var kind = ""
const NAMES = {"J":"Jun","L":"Lian","H":"Shen"}
const DialogueBook = preload("res://game/presentation/dialogue_book.gd")
func setup(controller, page: String) -> void:
	game = controller
	kind = page
	$Back.pressed.connect(func(): game.activities_ui(false,true))
	if page.begins_with("recruit:"):
		var id = page.get_slice(":",1)
		portrait(id)
		var data: Array = DialogueBook.recruitment(id)
		$Title.text = data[0]
		$Words.text = data[1]
		$Cost.text = "1 période · Lien 3 · " + NAMES[id] + " devient recrutable"
		$ChoiceA.text = data[2]
		$ChoiceB.text = data[3]
		$ChoiceA.pressed.connect(func(): game.resident_activity(id,"A"))
		$ChoiceB.pressed.connect(func(): game.resident_activity(id,"B"))
	elif page == "invite":
		portrait("L")
		$Title.text = "Deux invitations"
		$Words.text = tr("text.9d471e84d714")
		if game.calendar.slot == 16: $Words.text = tr("text.3d7ed9944161")
		$Cost.text = tr("text.cfddfeb61006")
		for id in ["J","L"]:
			var button = $ChoiceA if id == "J" else $ChoiceB
			button.text = "Rejoindre " + NAMES[id]
			button.disabled = not game.calendar.invitation_available(id) or game.calendar.reason(id) != ""
			button.tooltip_text = game.calendar.reason(id) if game.calendar.invitation_available(id) else tr("text.bdd99ae6a740")
			button.pressed.connect(func(): game.resident_activity(id))
	elif page == "prepare":
		portrait("H")
		$Title.text = "Une odeur sur l’acier"
		$Words.text = tr("text.8e048fc200c6")
		$Cost.text = tr("text.d71639b2b3d7")
		$ChoiceA.text = "Préparer l’antidote"
		$ChoiceA.pressed.connect(func(): game.do_activity("antidote"))
		$ChoiceB.text = tr("text.bd83361ac486")
		$ChoiceB.pressed.connect(func(): game.story_ack("warned",true))
		$Back.hide()
	elif page == "return":
		portrait("H")
		$Title.text = "Le retour au Prunier"
		var lines: Array[String] = []
		for member in game.calendar.story.battle_report.get("members",[]):
			if member.hp <= 0:
				lines.append(member.name + tr("text.a82f25103372"))
			elif member.guard_received > 0:
				lines.append(member.name + tr("text.f01f7fdc7d89"))
			else:
				lines.append(member.name + tr("text.bab79e4a34a9"))
		if game.calendar.story.battle_report.get("antidote_used",0) > 0: lines.append(tr("text.2ce0a0e19189"))
		$Words.text = "\n\n".join(lines)
		$Cost.text = tr("text.dad7d768f9ca")
		$ChoiceA.text = "Retrouver la cour"
		$ChoiceA.pressed.connect(func(): game.story_ack("return_seen",true))
		$ChoiceB.hide()
		$Back.hide()
	elif page == "candidates":
		portrait("H")
		$Title.text = "Deux visages à la porte"
		$Words.text = tr("text.5ed9c4283681")
		$Cost.text = tr("text.79639a9144b5")
		if game.calendar.story.candidates == "":
			$ChoiceA.text = tr("text.a6f76844a57d")
			$ChoiceB.text = tr("text.201d11298258")
			$ChoiceA.pressed.connect(func(): game.story_ack("candidates","essai"))
			$ChoiceB.pressed.connect(func(): game.story_ack("candidates","attente"))
			$Back.hide()
		else:
			$Words.text += "\n\n" + (tr("text.c4e3065495f2") if game.calendar.story.candidates == "essai" else tr("text.406ea7752563"))
			$ChoiceA.text = "Retour à la cour"
			$ChoiceA.pressed.connect(game.hub)
			$ChoiceB.hide()
			$Back.hide()
func portrait(id: String) -> void:
	var recipe = id
	if kind in ["prepare","return","candidates","invite"]: recipe = kind
	$Portrait.present(recipe)
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and $Back.visible:
		get_viewport().set_input_as_handled()
		$Back.pressed.emit()
