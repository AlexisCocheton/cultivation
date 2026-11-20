extends Control

var game
var selected = "Q01"
var committing = false

func setup(controller) -> void:
	$Portrait.present("merchant")
	$Sidebar.tooltip_text = "Marchand de passage"
	game = controller
	$Date.text = "Jour 4 · %s · Réserves : %d" % [["Matin","Après-midi","Soir"][game.calendar.period()],game.calendar.supplies]
	$Back.pressed.connect(game.hub)
	$Deck.pressed.connect(game.deck_ui)
	$Buy.pressed.connect(func(): commit(selected))
	$Skip.pressed.connect(func(): commit(""))
	var first = not game.calendar.seen.has("S01")
	$Words.text = "« Mes techniques non orthodoxes viennent des routes. Elles complètent celles de votre secte. »" if first else "« Prends le temps de choisir. Une bonne lame ne remplace pas une bonne technique. »"
	$Gift.text = "Main du voyageur · Non orthodoxe.\n1 qi · 2 garde · Pioche 2.\nAchat inclus dans cette période." if first else "Première rencontre terminée.\nChaque nouvel achat coûte une période.\nConsulter et équiper reste gratuit."
	$Skip.visible = first
	$Receipt.text = game.notice
	for tile in $Cards.get_children():
		var id: String = tile.card_id
		tile.pressed.connect(func(): select(id))
		tile.focus_entered.connect(func(): select(id))
		tile.get_node("Price").text = "%d réserves" % game.calendar.equipment_cost()
		tile.get_node("Owned").visible = game.calendar.collection.has(id)
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
	var worn: String = game.calendar.loadout.get(slot_name,"")
	$Equipped.text = "Équipé · %s\n%s" % ["Arme" if slot_name == "weapon" else "Talisman","Aucun" if worn == "" else game.Cards.catalog()[worn].name+"\n"+game.Cards.Effects.compact_description(game.Cards.catalog()[worn])]
	$Selection.text = "%s · %s\n%s" % [game.Cards.catalog()[id].name,"Arme" if slot_name == "weapon" else "Talisman",reason if reason != "" else "Ajout à la collection ; équipement ensuite dans le deck."]

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
