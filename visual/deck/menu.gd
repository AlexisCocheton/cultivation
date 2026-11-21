extends Control
const CampaignSession = preload("res://game/campaign/session.gd")
const Cards = preload("res://game/cards.gd")
const TileScript = preload("res://visual/deck/tile.gd")
const Item = preload("res://visual/deck/collection_item.tscn")
const Row = preload("res://visual/deck/deck_row.tscn")
var game
var draft: Array = []
var filter_way = ""
var committing = false
var inspection_focus: Control

func setup(controller) -> void:
	game = controller
	draft = game.calendar.deck.duplicate()
	$Cancel.pressed.connect(cancel)
	$Save.pressed.connect(commit)
	$Detail/Close.pressed.connect(close_detail)
	$Detail/Dim.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT: close_detail())
	var ways = ["","base","orthodox","unorthodox","demonic"]
	for i in range(ways.size()):
		var way: String = ways[i]
		$Filters.get_child(i).pressed.connect(func(): filter_way = way; refresh())
	$Search.text_changed.connect(func(_text): refresh())
	$Sort.item_selected.connect(func(_index): refresh())
	refresh()

func equipment() -> Dictionary:
	var result = {"weapon":"","talisman":"","item":""}
	for id in draft:
		var slot_name = game.calendar.equipment_slot(id)
		if slot_name != "": result[slot_name] = id
	return result

func add_reason(id: String) -> String:
	if game.calendar.complete: return "Campagne terminée."
	if not game.calendar.collection.has(id): return "Carte non acquise."
	if draft.size() >= Cards.MAX_DECK: return "Maximum de 20 cartes atteint."
	if draft.count(id) >= Cards.copy_limit(id): return "Maximum d’exemplaires atteint."
	var slot_name = game.calendar.equipment_slot(id)
	if slot_name != "" and equipment()[slot_name] != "": return "Retire d’abord l’équipement de cet emplacement."
	if Cards.exclusive_conflict(draft,id) != "": return "Cartes exclusives incompatibles."
	return ""

func add_card(id: String) -> void:
	if committing: return
	var error = add_reason(id)
	if error != "": $Error.text = error; return
	draft.append(id)
	refresh()

func remove_card(id: String) -> void:
	if committing or game.calendar.complete or not draft.has(id): return
	draft.erase(id)
	refresh()

func clear_children(parent: Node) -> void:
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()

func refresh() -> void:
	var scroll_position = $Scroll.scroll_vertical
	var deck_scroll = $DeckScroll.scroll_vertical
	clear_children($Scroll/Grid)
	clear_children($DeckScroll/Rows)
	var catalog = Cards.catalog(game.calendar.ranks)
	var visible_cards: Array = game.calendar.collection.duplicate()
	if $Sort.selected == 1: visible_cards.sort_custom(func(a,b): return String(catalog[a].name).naturalnocasecmp_to(catalog[b].name) < 0)
	if $Sort.selected == 2: visible_cards.sort_custom(func(a,b): return catalog[a].cost < catalog[b].cost if catalog[a].cost != catalog[b].cost else String(a) < String(b))
	for id in visible_cards:
		if filter_way == "base" and not id.begins_with("B"): continue
		if filter_way not in ["","base"] and catalog[id].way != filter_way: continue
		if not $Search.text.strip_edges().is_empty() and not String(catalog[id].name).to_lower().contains($Search.text.strip_edges().to_lower()): continue
		var card_id: String = id
		var item = Item.instantiate()
		item.get_node("Card").card_id = id
		item.get_node("Card").relation_ranks = game.calendar.ranks
		$Scroll/Grid.add_child(item)
		item.get_node("Copies").text = "%d/%d" % [draft.count(id),Cards.copy_limit(id)]
		item.get_node("Add").disabled = add_reason(id) != ""
		item.get_node("Add").tooltip_text = add_reason(id) if add_reason(id) != "" else "Ajouter « %s »" % catalog[id].name
		item.get_node("Add").pressed.connect(func(): add_card(card_id))
		item.get_node("Card").pressed.connect(func(): inspect(card_id))
	var seen: Array = []
	var total_cost = 0
	var attacks = 0
	var guards = 0
	var draws = 0
	for id in draft:
		total_cost += catalog[id].cost
		attacks += int(catalog[id].damage > 0)
		guards += int(catalog[id].block > 0)
		draws += int(catalog[id].draw > 0 or id == "B07")
		if seen.has(id): continue
		seen.append(id)
		var card_id: String = id
		var row = Row.instantiate()
		$DeckScroll/Rows.add_child(row)
		row.get_node("Art").texture = TileScript.illustration(id)
		row.get_node("Art").gui_input.connect(func(event):
			if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT: inspect(card_id))
		row.get_node("Name").text = catalog[id].name
		row.get_node("Name").tooltip_text = Cards.description(id,game.calendar.ranks)
		row.get_node("Name").pressed.connect(func(): inspect(card_id))
		row.get_node("Count").text = "×%d" % draft.count(id)
		row.get_node("Remove").tooltip_text = "Retirer un exemplaire de « %s »" % catalog[id].name
		row.get_node("Remove").disabled = game.calendar.complete
		row.get_node("Remove").pressed.connect(func(): remove_card(card_id))
	$Empty.visible = $Scroll/Grid.get_child_count() == 0
	$Empty.text = "Aucune correspondance pour cette recherche." if not $Search.text.strip_edges().is_empty() else ("Ta collection est vide." if game.calendar.collection.is_empty() else "Aucune carte acquise dans cette voie.")
	$Count.text = "%d/20" % draft.size()
	$Modified.visible = draft != game.calendar.deck
	$Capacity.value = draft.size()
	$Summary.text = "Coût moyen %.1f qi\nAttaque %d · Garde %d · Pioche %d" % [float(total_cost)/maxi(1,draft.size()),attacks,guards,draws]
	$Summary.tooltip_text = "Nombre de cartes par effet ; une carte peut compter dans plusieurs catégories."
	var error: String = game.calendar.validate_deck(draft,equipment())
	if game.calendar.complete: error = "Campagne terminée."
	$Save.disabled = error != "" or committing
	$Save.tooltip_text = error
	$Error.text = error
	var ways = ["","base","orthodox","unorthodox","demonic"]
	for i in range(ways.size()): $Filters.get_child(i).button_pressed = filter_way == ways[i]
	$Scroll.set_deferred("scroll_vertical",scroll_position)
	$DeckScroll.set_deferred("scroll_vertical",deck_scroll)

func inspect(id: String) -> void:
	inspection_focus = get_viewport().gui_get_focus_owner()
	game.inspected_card = id
	$Detail/Name.text = Cards.catalog(game.calendar.ranks)[id].name
	$Detail/Effects.text = Cards.Effects.describe(Cards.catalog(game.calendar.ranks)[id]).replace(" · ","\n")
	$Detail/Art.texture = TileScript.illustration(id)
	$Detail/Cost.text = str(Cards.catalog(game.calendar.ranks)[id].cost)
	$Detail/Way.text = Cards.way_name(id)
	var source = "Technique de base"
	if id.begins_with("L"): source = "Enseignement de Lian"
	elif id.begins_with("J"): source = "Enseignement de Jun"
	elif id.begins_with("H"): source = "Enseignement de Shen"
	elif id.begins_with("Q") or id.begins_with("O"): source = "Équipement"
	elif id.begins_with("E"): source = "Événement"
	$Detail/Context.text = "%s\n\nDans le deck : %d\nTaille du deck : %d" % [source,draft.count(id),draft.size()]
	var data: Dictionary = Cards.catalog(game.calendar.ranks)[id]
	var effective_cost: int = data.cost
	for effect in data.effects:
		if effect.kind == "cost_if_deck" and draft.size() >= int(effect.threshold): effective_cost = int(effect.amount)
	$Detail/ContextCost.text = "%d Qi" % effective_cost
	for node in ["ContextShade","ContextFrame","Context","ContextCost"]: $Detail.get_node(node).show()
	$Detail.show()
	$Detail/Close.grab_focus()

func close_detail() -> void:
	$Detail.hide()
	if is_instance_valid(inspection_focus): inspection_focus.grab_focus()

func cancel() -> void:
	if committing: return
	game.return_to_location()

func commit() -> void:
	if committing: return
	var old_deck = game.calendar.deck.duplicate()
	var old_equipment = game.calendar.loadout.duplicate()
	var old_stage = game.stage
	var error: String = game.calendar.configure(draft,equipment())
	if error != "": $Error.text = error; return
	committing = true
	if game.stage == CampaignSession.Stage.TECHNIQUE_LEARNED and draft.has("L01"): game.stage = CampaignSession.Stage.DECK_PREPARED
	if not game.save_progress():
		game.calendar.deck = old_deck
		game.calendar.loadout = old_equipment
		game.stage = old_stage
		committing = false
		$Error.text = "Échec de sauvegarde. Ton ancien deck est conservé ; réessaie."
		return
	game.selected = -1
	game.notice = "Deck enregistré : %d cartes." % draft.size()
	game.return_to_location()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if $Detail.visible: close_detail()
		else: cancel()
