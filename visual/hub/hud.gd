extends Control
const CampaignSession = preload("res://game/campaign/session.gd")

var game
var nearest = -1
var elapsed = 0.0

func setup(controller) -> void:
	game = controller
	$Hint.text = "Clic · marcher    %s · parler" % InputBindings.label_for("interact")
	$Calendar/Date.text = "Jour %d · %s" % [game.calendar.day(),["Matin","Après-midi","Soir"][game.calendar.period()]]
	$Calendar/Supplies.text = "Réserves %d" % game.calendar.supplies
	$Objective/Text.text = ["Rejoindre Lian au jardin", "Équiper Pétales tranchants dans Techniques", "Rejoindre Jun aux mannequins", "Préparer la secte pour le défi du jour 7"][game.stage]
	if game.calendar.slot == 18: $Objective/Text.text = "L’école rivale attend. Ouvre le carnet pour relever le défi."
	elif game.calendar.seen.has("M03"): $Objective/Text.text = "Le territoire est sauvé. Retrouve les disciples."
	$Merchant.visible = game.calendar.day() == 4 and game.calendar.slot < game.Progress.END_SLOT and game.stage > CampaignSession.Stage.INTRODUCTION
	$Merchant.pressed.connect(game.merchant_ui)
	$Visitor.visible = game.stage >= CampaignSession.Stage.TRAINING_COMPLETE
	$Visitor.text = "La voyageuse" if game.calendar.seen.has("visitor_won") else "Une visiteuse à la porte"
	$Visitor.pressed.connect(game.visitor_ui)
	if $Merchant.visible: $Objective/Text.text = "Le marchand est dans la cour aujourd’hui."
	$Techniques.pressed.connect(game.deck_ui)
	$Activities.disabled = game.stage < CampaignSession.Stage.TECHNIQUE_LEARNED
	$Activities.tooltip_text = "Rejoins d'abord Lian." if game.stage < CampaignSession.Stage.TECHNIQUE_LEARNED else "Choisir une activité · une période"
	$Activities.pressed.connect(game.activities_ui)
	$Menu.pressed.connect(game.menu_ui)
	$Garden.pressed.connect(game.garden_ui)
	$Pavilion.pressed.connect(game.pavilion_ui)
	$PavilionEntry.pressed.connect(game.pavilion_ui)
	$Talk.pressed.connect(func():
		if nearest > 0: game.talk(nearest))
	$Notice.visible = game.notice != ""
	$Notice/Text.text = game.notice

func _process(delta: float) -> void:
	if not is_instance_valid(game): return
	elapsed += delta
	if elapsed > 6.0: $Notice.visible = false
	nearest = game.nearest_resident()
	$Talk.visible = nearest > 0
	if nearest > 0:
		$Talk.text = InputBindings.label_for("interact") + " · Parler à " + ["","Lian","Jun","Shen"][nearest]
		$Talk.position = (game.actors[nearest].position + Vector2(65,-65)).clamp(Vector2(20,120),Vector2(1000,680))
