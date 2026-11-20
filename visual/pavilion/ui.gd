extends Control
const CampaignSession = preload("res://game/campaign/session.gd")

var game

func setup(controller) -> void:
	game = controller
	$Date.text = "Jour %d · %s · Lien avec Shen %d" % [game.calendar.day(),["Matin","Après-midi","Soir"][game.calendar.period()],game.calendar.ranks.H]
	$Talk.pressed.connect(func(): game.talk(3))
	$Person.pressed.connect(func(): game.talk(3))
	$Gate.pressed.connect(game.hub)
	$Back.pressed.connect(game.hub)
	$Deck.pressed.connect(game.deck_ui)
	$Effects.text = "Effets : " + ("doux" if game.reduced_motion else "oui")
	$Effects.pressed.connect(func():
		game.reduced_motion = not game.reduced_motion
		game.save_progress()
		$Effects.text = "Effets : " + ("doux" if game.reduced_motion else "oui"))
	var reason = game.calendar.reason("H")
	if game.stage == CampaignSession.Stage.INTRODUCTION: reason = "Rejoins d'abord Lian au jardin."
	if game.calendar.slot >= game.Progress.END_SLOT: reason = "Cette séquence est terminée à la fin du jour 7."
	$Study.disabled = reason != ""
	$Study.tooltip_text = reason if reason != "" else "Développer le lien avec Shen · une période"
	$Study.pressed.connect(game.study_with_shen)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		game.hub()
