extends Control
var game
const PORTRAITS = {"J":preload("res://assets/ui/companions/jun.png"),"L":preload("res://assets/ui/activities/strict/lian.png"),"H":preload("res://assets/ui/companions/shen.png")}
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
	$Character.texture = PORTRAITS[id]
	for i in range(3):
		var tab = $Tabs.get_child(i)
		var tab_id: String = ["J","L","H"][i]
		tab.toggle_mode = true
		tab.button_pressed = tab_id == id
		tab.icon = PORTRAITS[tab_id]
		tab.expand_icon = true
	var c = game.calendar
	var person_name: String = {"J":"Jun","L":"Lian","H":"Shen"}[id]
	$Title.text = person_name
	$Info.text = "Lien %d / 5 · %s\n\n%s" % [c.ranks[id],"Recruté" if c.recruited(id) else "Non recruté",{"J":"Attaque et garde · Un rival qui couvre tes ouvertures.","L":"Enchaînements et protection · Préserve le groupe.","H":"Garde et croissance · Prépare les tours suivants."}[id]]
	var milestones = ["Rencontre","Technique unique","Recrutement","Seconde technique","Techniques améliorées"]
	for i in range(5):
		var reached: bool = c.ranks[id] >= i+1
		var label = $Progress.get_child(i)
		label.text = "  %s  %d · %s" % ["✓" if reached else "○",i+1,milestones[i]]
		label.modulate = Color(0.35,0.55,0.38,1) if reached else Color(1,1,1,0.65)
	for child in $Scroll/Grid.get_children(): child.free()
	var deck: Array = preload("res://game/team_battle.gd").COMPANION_DECKS[id]
	$DeckTitle.text = "Deck de %s · %d cartes" % [person_name,deck.size()]
	var seen: Array = []
	for card in deck:
		if card in seen: continue
		seen.append(card)
		var tile = preload("res://visual/team/deck_tile.tscn").instantiate()
		tile.card_id = card
		tile.relation_ranks = c.ranks
		$Scroll/Grid.add_child(tile)
		tile.get_node("Count").text = "×%d" % deck.count(card)
		tile.pressed.connect(func(): inspect(card))

func inspect(id: String) -> void:
	var cards = game.Cards.catalog(game.calendar.ranks)
	$Detail/Name.text = cards[id].name
	$Detail/Effects.text = game.Cards.Effects.describe(cards[id])
	$Detail/Art.texture = preload("res://visual/deck/tile.gd").illustration(id)
	$Detail/Cost.text = str(cards[id].cost)
	$Detail/Way.text = game.Cards.way_name(id)
	$Detail.show()
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if $Detail.visible: $Detail.hide()
		else: queue_free()
