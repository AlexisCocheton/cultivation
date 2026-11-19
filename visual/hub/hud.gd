extends Control

var game
var nearest = -1
var elapsed = 0.0

func setup(controller) -> void:
	game = controller
	$Calendar/Date.text = "Jour %d · %s" % [game.calendar.day(),["Matin","Après-midi","Soir"][game.calendar.period()]]
	$Calendar/Supplies.text = "Réserves %d" % game.calendar.supplies
	$Objective/Text.text = ["Rejoindre Lian au jardin", "Équiper Pétales tranchants dans Techniques", "Rejoindre Jun aux mannequins", "Choisir tes activités jusqu'à la fin du jour 4"][game.stage]
	$Merchant.visible = game.calendar.day() == 4 and game.calendar.slot < game.Progress.END_SLOT and game.stage > 0
	$Merchant.pressed.connect(game.merchant_ui)
	if $Merchant.visible: $Objective/Text.text = "Le marchand est dans la cour aujourd’hui."
	$Techniques.pressed.connect(game.deck_ui)
	$Activities.disabled = game.stage < 1
	$Activities.tooltip_text = "Rejoins d'abord Lian." if game.stage < 1 else "Choisir une activité · une période"
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
		$Talk.text = "E · Parler à " + ["","Lian","Jun","Shen"][nearest]
		$Talk.position = (game.actors[nearest].position + Vector2(65,-65)).clamp(Vector2(20,120),Vector2(1000,680))
