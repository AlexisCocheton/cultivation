extends Control
var game
func setup(controller, id: String) -> void:
	game = controller
	$Close.pressed.connect(queue_free)
	$Detail/Close.pressed.connect(func(): $Detail.hide())
	for i in range(3):
		var resident: String = ["J","L","H"][i]
		$Tabs.get_child(i).pressed.connect(func(): present(resident))
	present(id)
func present(id: String) -> void:
	$Portrait.present(id)
	var c = game.calendar
	$Title.text = {"J":"Jun","L":"Lian","H":"Shen"}[id] + " · Techniques"
	$Info.text = "Lien %d / 5 · %s\n%s\nRang 2 : technique unique · Rang 3 : recrutement\nRang 4 : seconde technique · Rang 5 : les deux techniques améliorées pour vous deux" % [c.ranks[id],"Recruté" if c.recruited(id) else "Pas encore recruté",{"J":"Attaque et garde · Un rival qui couvre tes ouvertures.","L":"Enchaînements et protection · Préserve le groupe.","H":"Garde et croissance · Prépare les tours suivants."}[id]]
	for child in $Scroll/Grid.get_children(): child.free()
	for card in preload("res://game/team_battle.gd").COMPANION_DECKS[id]:
		var tile = preload("res://visual/deck/tile.tscn").instantiate()
		tile.card_id = card
		tile.relation_ranks = c.ranks
		$Scroll/Grid.add_child(tile)
		tile.pressed.connect(func(): inspect(card))
func inspect(id: String) -> void:
	var cards = game.Cards.catalog(game.calendar.ranks)
	$Detail/Name.text = cards[id].name
	$Detail/Effects.text = game.Cards.description(id,game.calendar.ranks)
	$Detail/Art.texture = preload("res://visual/deck/tile.gd").illustration(id)
	$Detail/Cost.text = str(cards[id].cost)
	$Detail/Way.text = game.Cards.way_name(id)
	$Detail.show()
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if $Detail.visible: $Detail.hide()
		else: queue_free()
