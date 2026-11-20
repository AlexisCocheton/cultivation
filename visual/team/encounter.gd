extends Control
var game
var draft: Array = []
func setup(controller) -> void:
	game = controller
	$SlotR/Portrait.texture = preload("res://assets/ui/companions/recruit.png")
	$SlotR/Name.text = "Recrue · Fixe"
	$SlotR/Role.text = "%d cartes\nTon deck équipé" % game.calendar.deck.size()
	$Antidote.text = "Antidote · %d dose" % game.calendar.story.antidote
	for id in ["J","L","H"]:
		get_node("Slot"+id+"/Portrait").texture = preload("res://visual/team/companions.gd").PORTRAITS[id]
		get_node("Slot"+id+"/Name").text = {"J":"Jun","L":"Lian","H":"Shen"}[id]
		get_node("Slot"+id+"/Role").text = "%s\n%d cartes" % [{"J":"Attaque et garde","L":"Protection et enchaînements","H":"Garde et croissance"}[id],preload("res://game/team_battle.gd").COMPANION_DECKS[id].size()]
	$Inspect.pressed.connect(game.companions_ui)
	draft = game.calendar.party.duplicate()
	$Words.text = "L’école rivale réclame les terres du Prunier. Choisis les deux disciples qui défendront le territoire avec toi.\nJun et Lian sont disponibles sur ordre de Shen, même avant le rang 3."
	$Back.pressed.connect(game.hub)
	$Deck.pressed.connect(game.deck_ui)
	for i in range(3):
		var id: String = ["J","L","H"][i]
		var button = $Party.get_child(i)
		button.pressed.connect(func(): toggle(id))
	refresh()
	$Start.pressed.connect(func():
		var old = game.calendar.party.duplicate()
		game.calendar.party = draft.duplicate()
		if not game.start_territory():
			game.calendar.party = old
			$Error.text = game.notice)
func toggle(id: String) -> void:
	if draft.has(id): draft.erase(id)
	elif draft.size() < 2: draft.append(id)
	else: $Error.text = "Retire un compagnon avant d’en choisir un autre."; return
	$Error.text = ""
	refresh()
func refresh() -> void:
	for i in range(3):
		var id: String = ["J","L","H"][i]
		var button = $Party.get_child(i)
		var recruited: bool = game.calendar.recruited(id)
		button.text = ("✓ " if draft.has(id) else "") + ["Jun","Lian","Shen"][i] + (" · Lien 3 requis" if id == "H" and not recruited else "")
		button.disabled = id == "H" and not recruited
		button.button_pressed = draft.has(id)
		get_node("Slot"+id).modulate = Color(1,1,1,0.58) if button.disabled else (Color(0.87,1,0.91,1) if draft.has(id) else Color.WHITE)
		var deck: Array = preload("res://game/team_battle.gd").COMPANION_DECKS[id]
		var names: Array[String] = []
		for card in deck: names.append(game.Cards.catalog(game.calendar.ranks)[card].name)
		button.tooltip_text = "Recruté · " if recruited else "Désigné pour ce défi · "
		button.tooltip_text += "\n".join(names)
	$Start.disabled = game.calendar.party_reason(draft,true) != ""
