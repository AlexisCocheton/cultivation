extends Control
const CampaignSession = preload("res://game/campaign/session.gd")
var game
var elapsed = 0.0

func setup(controller) -> void:
	game = controller
	$Calendar/Date.text = "Jour %d" % game.calendar.day()
	$Calendar/Period.text = ["Matin", "Après-midi", "Soir"][game.calendar.period()]
	$Calendar/Supplies.text = str(game.calendar.supplies)
	$Calendar/Supplies.tooltip_text = "R\u00e9serves"
	$Calendar/Active.position.x = 146 + game.calendar.period() * 53
	for i in range(3):
		var icon = $Calendar.get_node(["morning","afternoon","evening"][i])
		icon.modulate = Color("a23226") if i == game.calendar.period() else Color("8a8072")
		icon.tooltip_text = ["Matin","Apr\u00e8s-midi","Soir"][i]
		icon.mouse_filter = Control.MOUSE_FILTER_PASS
	$Objective/Text.text = ["Retrouver Lian au jardin", "Équiper Pétales tranchants", "Retrouver Jun aux mannequins", "Défi territorial · J7"][game.stage]
	if game.calendar.slot == 18: $Objective/Text.text = "Défi territorial · aujourd’hui"
	elif game.calendar.seen.has("M03"): $Objective.visible = false
	$GateMenu/Merchant.visible = game.calendar.day() == 4 and game.calendar.slot < game.Progress.END_SLOT and game.stage > CampaignSession.Stage.INTRODUCTION
	$GateMenu/Visitor.visible = game.stage >= CampaignSession.Stage.TRAINING_COMPLETE
	$Gate.visible = $GateMenu/Merchant.visible or $GateMenu/Visitor.visible
	$Gate.tooltip_text = "Rencontres au portail"
	$Gate.pressed.connect(func():
		$GateMenu.visible = not $GateMenu.visible
		if $GateMenu.visible:
			if $GateMenu/Merchant.visible: $GateMenu/Merchant.grab_focus()
			else: $GateMenu/Visitor.grab_focus())
	$GateMenu/Close.pressed.connect(close_gate)
	$GateMenu/Merchant.pressed.connect(game.merchant_ui)
	$GateMenu/Visitor.pressed.connect(game.visitor_ui)
	$Techniques.pressed.connect(game.deck_ui)
	$Activities.disabled = game.stage < CampaignSession.Stage.TECHNIQUE_LEARNED
	$Activities.tooltip_text = "Rejoins d’abord Lian." if $Activities.disabled else "Choisir une activité · une période"
	$Activities.pressed.connect(game.activities_ui)
	$Menu.pressed.connect(game.menu_ui)
	$Garden.pressed.connect(game.garden_ui)
	$Pavilion.pressed.connect(game.pavilion_ui)
	$Talk.pressed.connect(func(): game.talk(2))
	$Notice.visible = game.notice != ""
	$Notice/Text.text = game.notice

func close_gate() -> void:
	$GateMenu.hide()
	$Gate.grab_focus()

func _input(event: InputEvent) -> void:
	if $GateMenu.visible and (event.is_action_pressed("interact") or event.is_action_pressed("open_deck")):
		get_viewport().set_input_as_handled()
		return
	if $GateMenu.visible and event.is_action_pressed("ui_cancel"):
		close_gate()
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	elapsed += delta
	if elapsed > 6.0: $Notice.visible = false
