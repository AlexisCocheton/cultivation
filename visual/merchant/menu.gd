extends Control

var game
var selected = "Q01"
var committing = false

func setup(controller) -> void:
	game = controller
	$Date.text = "Jour 4 · %s · Réserves : %d" % [["Matin","Après-midi","Soir"][game.calendar.period()],game.calendar.supplies]
	$Back.pressed.connect(game.hub)
	$Deck.pressed.connect(game.deck_ui)
	$Buy.pressed.connect(func(): commit(selected))
	$Skip.pressed.connect(func(): commit(""))
	var first = not game.calendar.seen.has("S01")
	$Words.text = "« Votre prunier fleurit encore ! J’ai quelques nouvelles et de quoi préparer vos prochains duels. »" if first else "« Prends le temps de choisir. Une bonne lame ne remplace pas une bonne technique. »"
	$Gift.text = "Main du voyageur offerte.\n1 qi · 2 garde · Pioche 2.\nAchat inclus dans cette période." if first else "Première rencontre terminée.\nChaque nouvel achat coûte une période.\nConsulter et équiper reste gratuit."
	$Skip.visible = first
	$Receipt.text = game.notice
	for tile in $Cards.get_children():
		var id: String = tile.card_id
		tile.pressed.connect(func(): select(id))
		tile.focus_entered.connect(func(): select(id))
		if game.calendar.collection.has(id): tile.tooltip_text += "\nDéjà possédé"
	select(selected)

func select(id: String) -> void:
	selected = id
	for tile in $Cards.get_children(): tile.mark_selected(tile.card_id == id)
	var reason: String = game.calendar.merchant_reason(id)
	$Buy.disabled = reason != ""
	$Buy.tooltip_text = reason
	$Buy.text = "Acheter · %d réserves · 1 période" % game.calendar.equipment_cost()
	var slot_name = game.calendar.equipment_slot(id)
	$Selection.text = "%s · %s\n%s" % [game.Cards.catalog()[id].name,"Arme" if slot_name == "weapon" else "Talisman",reason if reason != "" else "Rejoint ta collection. À équiper ensuite en remplaçant une carte."]

func commit(id: String) -> void:
	if committing: return
	var reason: String = game.calendar.merchant_reason(id)
	if reason != "": $Receipt.text = reason; return
	committing = true
	var action = "S01" if not game.calendar.seen.has("S01") else "buy:"+id
	var error: String = game.do_activity(action,id)
	if error != "": committing = false; return
	if game.calendar.slot < game.Progress.END_SLOT: game.merchant_ui()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		game.hub()
