extends Control

const Tile = preload("res://visual/deck/tile.tscn")
const TileScript = preload("res://visual/deck/tile.gd")
const Cards = preload("res://prototypes/cards.gd")
var game
var current_id = ""

func setup(controller) -> void:
	game = controller
	$Deck.button_pressed = game.deck_tab == "deck"
	$Collection.button_pressed = game.deck_tab == "collection"
	$Deck.pressed.connect(func(): game.deck_tab = "deck"; game.deck_ui())
	$Collection.pressed.connect(func(): game.deck_tab = "collection"; game.deck_ui())
	$Back.text = {"garden":"‹ Retour au jardin","pavilion":"‹ Retour au pavillon"}.get(game.location,"‹ Retour à la cour")
	$Back.pressed.connect(game.return_to_location)
	$Detail/Action.pressed.connect(commit)
	$Notice.text = game.notice
	for child in $Scroll/Grid.get_children():
		$Scroll/Grid.remove_child(child)
		child.queue_free()
	var ids: Array = game.calendar.deck if game.deck_tab == "deck" else game.calendar.collection
	for i in range(ids.size()):
		var id: String = ids[i]
		var index = i
		var card = Tile.instantiate()
		card.card_id = id
		$Scroll/Grid.add_child(card)
		card.mark_selected(game.deck_tab == "deck" and game.selected == i)
		card.pressed.connect(func(): select_card(index, id))
		card.focus_entered.connect(func(): select_card(index, id))
	if game.selected < 0 and game.deck_tab == "deck": game.selected = 0
	var initial = str(game.calendar.deck[game.selected]) if game.deck_tab == "deck" else game.inspected_card
	if not game.calendar.collection.has(initial): initial = str(ids[0])
	inspect(initial)
	if game.deck_tab == "deck": $Scroll/Grid.get_child(game.selected).mark_selected(true)

func select_card(index: int, id: String) -> void:
	if game.deck_tab == "deck": game.selected = index
	for i in range($Scroll/Grid.get_child_count()):
		$Scroll/Grid.get_child(i).mark_selected(i == index)
	inspect(id)

func inspect(id: String) -> void:
	current_id = id
	game.inspected_card = id
	var data = Cards.catalog()[id]
	$Detail/Art.texture = TileScript.illustration(id)
	$Detail/Name.text = data.name
	$Detail/Way.text = "Voie " + Cards.way_name(id).to_lower()
	$Detail/Cost.text = "%d Qi   ·   %d équipé(s)" % [data.cost, game.calendar.deck.count(id)]
	$Detail/Effects.text = Cards.description(id).split("\n")[1].replace(" · ", "\n").replace("retirée après usage jusqu'au prochain combat", "Épuisement")
	var origin = {"B":"Technique de base", "L":"Lian", "J":"Jun", "H":"Shen", "Q":"Équipement", "O":"Objet", "E":"Événement"}
	$Detail/Origin.text = origin.get(id.left(1), "Technique")
	if id.left(1) in ["L", "J", "H"]: $Detail/Origin.text += " · Rang %d" % int(id.right(2))
	var equipment_slot = game.calendar.equipment_slot(id)
	if equipment_slot != "":
		$Detail/Origin.text = {"weapon":"Arme","talisman":"Talisman","item":"Sacoche"}[equipment_slot] + " · 1 emplacement"
	$Detail/Help.text = "Garde : absorbe les dégâts du prochain tour adverse.\nCombo : joue 2 cartes avant cette technique.\nÉpuisement : retirée jusqu'au prochain duel."
	var error = ""
	if game.deck_tab == "collection":
		error = "Choisis d'abord une carte dans le deck."
		if game.selected >= 0:
			var plan = game.calendar.replacement_plan(game.selected,id)
			error = plan.error
			if error == "": $Notice.text = "Remplacer : " + Cards.catalog()[game.calendar.deck[plan.index]].name
		$Detail/Action.text = "Équiper cet objet" if equipment_slot != "" else "Équiper cette technique"
		if error != "": $Notice.text = error
	else:
		$Detail/Action.text = "Remplacer"
	$Detail/Action.disabled = error != ""
	$Detail/Action.tooltip_text = error

func commit() -> void:
	if game.deck_tab == "deck":
		game.deck_tab = "collection"
		game.deck_ui()
	else:
		game.replace_card(current_id)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		game.return_to_location()
