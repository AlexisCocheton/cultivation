extends Control
const CampaignSession = preload("res://game/campaign/session.gd")

var game

func setup(controller) -> void:
	game = controller
	$Date.text = "Jour %d · %s" % [game.calendar.day(),["Matin","Après-midi","Soir"][game.calendar.period()]]
	$Talk.pressed.connect(func(): game.talk(1))
	$Person.pressed.connect(func(): game.talk(1))
	$Gate.pressed.connect(game.hub)
	$Back.pressed.connect(game.hub)
	$Deck.pressed.connect(game.deck_ui)
	var reason = game.calendar.reason("L")
	if game.stage == CampaignSession.Stage.INTRODUCTION: reason = "Parle d'abord à Lian pour apprendre ta première technique."
	if game.calendar.slot >= game.Progress.END_SLOT: reason = "Cette séquence est terminée à la fin du jour 7."
	$Activity.disabled = reason != ""
	$Activity.tooltip_text = reason if reason != "" else "Partager le thé et progresser dans le lien · une période"
	$Activity.pressed.connect(func(): game.resident_activity("L"))
	$Effects.text = "Effets : " + ("doux" if game.reduced_motion else "oui")
	$Effects.pressed.connect(func():
		game.reduced_motion = not game.reduced_motion
		game.save_progress()
		$Effects.text = "Effets : " + ("doux" if game.reduced_motion else "oui"))

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		game.hub()
