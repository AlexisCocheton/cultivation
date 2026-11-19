extends Control

const Calendar = preload("res://prototypes/calendar.gd")
const Battle = preload("res://prototypes/battle.gd")
const Cards = preload("res://prototypes/cards.gd")
var calendar = Calendar.new()
var battle = null
var pending = ""
var selected_deck = "Départ"
var selected_foe = "inspecteur"
var seed_value = 42
var pressure = 0
var editing = false
var draft: Array = []
var draft_loadout: Dictionary = {}
var active_deck_label = ""
var root_box: VBoxContainer
var message = "Laboratoire séparé : votre sauvegarde du hub n'est pas utilisée."
var capture_clock = 0.0

func _ready() -> void:
	var bg = ColorRect.new()
	bg.color = Color("14232c")
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var scroll = ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.offset_left = 32
	scroll.offset_top = 24
	scroll.offset_right = -32
	scroll.offset_bottom = -24
	add_child(scroll)
	root_box = VBoxContainer.new()
	root_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_box.add_theme_constant_override("separation",12)
	scroll.add_child(root_box)
	var theme = Theme.new()
	theme.default_font_size = 18
	root_box.theme = theme
	refresh()
	if "--lab-combat" in OS.get_cmdline_user_args(): begin_battle("","inspecteur")
	if "--lab-deck" in OS.get_cmdline_user_args(): open_editor()

func _process(delta: float) -> void:
	if "--lab-smoke" in OS.get_cmdline_user_args():
		capture_clock += delta
		if capture_clock > 1:
			var path = "res://prototypes/lab-preview.png"
			if "--lab-combat" in OS.get_cmdline_user_args(): path = "res://prototypes/lab-combat-preview.png"
			if "--lab-deck" in OS.get_cmdline_user_args(): path = "res://prototypes/deck-preview.png"
			get_viewport().get_texture().get_image().save_png(path)
			get_tree().quit()

func text(parent: Node, value: String, size_value: int = 18) -> void:
	var label = Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size",size_value)
	parent.add_child(label)

func button(parent: Node, value: String, callback: Callable, reason: String = "") -> void:
	var b = Button.new()
	b.text = value
	b.custom_minimum_size.y = 42
	b.tooltip_text = reason
	b.disabled = reason != ""
	b.pressed.connect(callback)
	parent.add_child(b)

func refresh() -> void:
	for child in root_box.get_children():
		root_box.remove_child(child)
		child.queue_free()
	text(root_box,"LABORATOIRE · ÉTAPE 4",30)
	text(root_box,message)
	if battle != null:
		show_battle()
		return
	if editing:
		show_editor()
		return
	text(root_box,"Calendrier et relations · J%d / %s · Réserves %d" % [mini(14,calendar.day()),["Matin","Après-midi","Soir"][calendar.period()],calendar.supplies],24)
	text(root_box,"Lian %d/4 · Jun %d/4 · Shen %d/4    |    Pavillon %d/2 · Atelier %d/2 · Cuisine %d/2\nCollection : %d cartes · Événements : %d/24 · Périodes résolues : %d/42" % [calendar.ranks.L,calendar.ranks.J,calendar.ranks.H,calendar.buildings.hall,calendar.buildings.workshop,calendar.buildings.kitchen,calendar.collection.size(),calendar.event_count(),calendar.slot])
	button(root_box,"Composer mon deck · %d/20 cartes · uniquement ma collection" % calendar.deck.size(),open_editor,"Campagne terminée." if calendar.complete else "")
	text(root_box,"Aide : +%d réserves · Chantier : 3 puis 4 · Équipement : %d · Victoires libres rémunérées : %d/3" % [3 if calendar.buildings.kitchen >= 1 else 2,calendar.equipment_cost(),mini(3,calendar.optional_wins)],16)
	var choices = HFlowContainer.new()
	root_box.add_child(choices)
	for action in calendar.actions():
		var unavailable = calendar.reason(action)
		var title = {"work":"Aider la secte","rest":"Repos","L":"Lien Lian","J":"Lien Jun","H":"Lien Shen","hall":"Restaurer pavillon","kitchen":"Restaurer cuisine","workshop":"Restaurer atelier","fight":"Duel libre","trail":"Sortie sentier"}.get(action,action)
		button(choices,title,perform.bind(action),unavailable)
	text(root_box,"M01 arrivée · M02 serment · M03 incident · M04 défi · M05 préparation · M06 final\nS01 marchand · S02 objet ancien · S03 intendance · S04 chantier collectif · S05 sentier · S06 entraînement",15)
	var row = HFlowContainer.new()
	root_box.add_child(row)
	button(row,"Intérêt amoureux : " + ("oui" if calendar.interest else "non"),func(): calendar.interest = not calendar.interest; refresh())
	button(row,"Sauver le laboratoire",func(): message = "Laboratoire sauvegardé." if calendar.save_lab() else "Échec d'écriture."; refresh())
	button(row,"Charger",load_lab)
	button(row,"Reprendre avant final",func(): calendar.restore(calendar.before_final); refresh(),"Pas de point final." if calendar.before_final.is_empty() else "")
	button(row,"Reprendre J13",func(): calendar.restore(calendar.before_preparation); calendar.before_final = {}; refresh(),"Pas de point J13." if calendar.before_preparation.is_empty() else "")
	button(row,"Nouvelle simulation",func(): calendar = Calendar.new(); message = "Simulation réinitialisée."; refresh())
	text(root_box,"Comparaison hors campagne · decks de référence",24)
	text(root_box,"Les activités du calendrier utilisent votre deck et vos acquisitions. Seul le duel hors calendrier ci-dessous utilise des decks de référence débloqués.",16)
	var settings = HBoxContainer.new()
	root_box.add_child(settings)
	var deck_choice = OptionButton.new()
	for name in Cards.PRESETS: deck_choice.add_item(name)
	deck_choice.selected = Cards.PRESETS.keys().find(selected_deck)
	deck_choice.item_selected.connect(func(i): selected_deck = Cards.PRESETS.keys()[i])
	settings.add_child(deck_choice)
	var foe_choice = OptionButton.new()
	var foes = ["partenaire","offensif","defensif","inspecteur"]
	for foe in foes: foe_choice.add_item(foe)
	foe_choice.selected = foes.find(selected_foe)
	foe_choice.item_selected.connect(func(i): selected_foe = foes[i])
	settings.add_child(foe_choice)
	var seed_input = SpinBox.new()
	seed_input.max_value = 99999
	seed_input.value = seed_value
	seed_input.value_changed.connect(func(value): seed_value = int(value))
	settings.add_child(seed_input)
	var difficulty = OptionButton.new()
	for title in ["Équilibrage v0.2","Test supplémentaire +2","Test supplémentaire +4"]: difficulty.add_item(title)
	difficulty.selected = int(pressure/2)
	difficulty.item_selected.connect(func(i): pressure = i*2)
	settings.add_child(difficulty)
	button(settings,"Duel hors calendrier",func(): begin_battle("",selected_foe))
	text(root_box,"Même graine = même mélange initial. Les bonus de bâtiments du calendrier s'appliquent à l'inspecteur.",15)
	if not calendar.history.is_empty():
		text(root_box,"Dernière activité : " + str(calendar.history.back()),15)

func perform(action: String) -> void:
	var unavailable = calendar.reason(action)
	if unavailable != "":
		message = unavailable
		refresh()
		return
	if action == "M02":
		message = "Choisissez votre serment."
		refresh()
		button(root_box,"Serment offensif E01",func(): resolve(action,true,"E01"))
		button(root_box,"Serment protecteur E02",func(): resolve(action,true,"E02"))
		return
	if action in ["M01","M03","M04","M06","S02","S05","fight","trail"]:
		var foe = "partenaire"
		if action in ["M03","S05","trail"]: foe = "offensif"
		if action == "S02": foe = "defensif"
		if action == "M06":
			foe = "inspecteur"
			if calendar.before_final.is_empty(): calendar.before_final = calendar.snapshot()
		begin_battle(action,foe)
	else:
		resolve(action)

func resolve(action: String, won: bool = true, choice: String = "E01") -> void:
	var error = calendar.act(action,won,choice)
	message = error if error != "" else "Activité résolue : %s · %s" % [action,"victoire / réussite" if won else "défaite sans récompense"]
	calendar.save_lab()
	refresh()

func begin_battle(action: String, foe: String) -> void:
	var chosen: Array = Cards.PRESETS[selected_deck] if action == "" else calendar.deck
	if action != "":
		var unavailable = calendar.reason(action)
		if unavailable != "":
			message = unavailable
			refresh()
			return
	pending = action
	battle = Battle.new()
	var error = battle.start(chosen,foe,seed_value,calendar.repairs(),calendar.buildings.kitchen == 2)
	if error != "":
		battle = null
		message = error
		refresh()
		return
	active_deck_label = selected_deck if action == "" else "Mon deck acquis"
	battle.boss_pressure = pressure if action == "" else 0
	if action == "M01":
		battle.enemy_hp = 18
		battle.enemy_max = 18
	if action == "M04":
		battle.enemy_hp = 40
		battle.enemy_max = 40
	refresh()

func show_battle() -> void:
	text(root_box,"%s · %s · Tour %d · Équilibrage v0.2" % [active_deck_label,battle.profile,battle.turn+1],24)
	text(root_box,"Vous : %d/%d PV · %d garde · %d qi\nAdversaire : %d/%d PV · %d garde · Intention : %d dégâts, %d garde\nPhase %d · Exposé : %s · Bonus attaque : %d" % [battle.hp,battle.max_hp,battle.block,battle.energy,battle.enemy_hp,battle.enemy_max,battle.enemy_block,battle.intent().damage,battle.intent().block,battle.phase,str(battle.exposed),battle.bonus])
	var grid = HFlowContainer.new()
	if battle.profile == "inspecteur": text(root_box,"Pression du boss : +2 dégâts initiaux, puis +2 tous les 3 tours. L'intention affichée inclut ces bonus.",16)
	root_box.add_child(grid)
	for i in range(battle.hand.size()):
		var id = battle.hand[i]
		var c = battle.cards[id]
		button(grid,"%s · %s · %d qi\nDégâts %d · garde %d · pioche %d%s" % [id,c.name,c.cost,battle.damage_for(id),c.block,c.draw," · Retirée" if c.exhaust else ""],play.bind(i),"Qi insuffisant" if c.cost > battle.energy else "")
	text(root_box,"B08 : prochaine attaque · H02 : Force +1/tour · B07 : pioche +1/tour, main +2 · J02 : Exposé · L01/L03 : combo après 2 cartes\nQ04 : +1 qi · O01 : soin 6 · J03 : perd 2 PV · E06 : pioche si Exposé\nPioche %d · Défausse %d · Retirées %d" % [battle.pile.size(),battle.discard.size(),battle.removed.size()],16)
	button(root_box,"Fin du tour",func(): battle.end_turn(); check_end())
	button(root_box,"Laisser jouer une carte à l'agent de test",func(): var i = battle.bot_index(); battle.play(i) if i >= 0 else battle.end_turn(); check_end())
	button(root_box,"Abandonner",func(): battle.outcome = "defeat"; check_end())

func play(index: int) -> void:
	battle.play(index)
	check_end()

func check_end() -> void:
	if battle.outcome != "":
		var won = battle.outcome == "victory"
		battle = null
		if pending != "":
			resolve(pending,won)
		else:
			message = "Duel de test : " + ("victoire" if won else "défaite")
			refresh()
		pending = ""
	else: refresh()

func load_lab() -> void:
	var path = "user://laboratoire_etape4_v2.json"
	if not FileAccess.file_exists(path):
		message = "Aucune sauvegarde de laboratoire."
	else:
		var data = JSON.parse_string(FileAccess.get_file_as_string(path))
		if data is Dictionary and data.has("state"):
			calendar = Calendar.new()
			calendar.restore(data.state)
			calendar.before_final = data.get("final",{})
			calendar.before_preparation = data.get("preparation",{})
			message = "Laboratoire chargé."
		else: message = "Fichier invalide."
	refresh()

func open_editor() -> void:
	if battle != null or calendar.complete: return
	draft = calendar.deck.duplicate()
	draft_loadout = calendar.loadout.duplicate()
	editing = true
	message = "Les changements sont gratuits. Validez de 12 à 20 cartes ou annulez pour garder votre deck précédent."
	refresh()

func show_editor() -> void:
	text(root_box,"Mon deck · %d / 20 cartes" % draft.size(),26)
	var error = calendar.validate_deck(draft,draft_loadout)
	text(root_box,"Deck prêt." if error == "" else error)
	var commands = HFlowContainer.new()
	root_box.add_child(commands)
	button(commands,"Enregistrer ce deck",commit_editor,error)
	button(commands,"Annuler",func(): editing = false; message = "Deck précédent conservé."; refresh())
	button(commands,"Compléter les places libres",func(): draft = calendar.suggested_deck(draft,draft_loadout); refresh())
	for name in Cards.PRESETS:
		button(commands,"Suggérer " + name,suggest.bind(name))
	text(root_box,"Les suggestions n'utilisent que vos cartes acquises. Une arme, un talisman et un objet au maximum ; leurs cartes comptent dans le deck.",16)
	var slots = HBoxContainer.new()
	root_box.add_child(slots)
	var groups = {"weapon":["Q01","Q02"],"talisman":["Q03","Q04"],"item":["O01","O02"]}
	for slot_name in groups:
		var box = VBoxContainer.new()
		slots.add_child(box)
		text(box,{"weapon":"Arme","talisman":"Talisman","item":"Sacoche"}[slot_name])
		var select = OptionButton.new()
		var options: Array = [""]
		select.add_item("Aucun")
		for id in groups[slot_name]:
			if calendar.collection.has(id):
				options.append(id)
				select.add_item(Cards.catalog()[id].name)
		select.selected = maxi(0,options.find(draft_loadout.get(slot_name,"")))
		select.item_selected.connect(change_slot.bind(slot_name,options))
		box.add_child(select)
	text(root_box,"Cartes sélectionnées · cliquez pour retirer une technique",21)
	var selected = HFlowContainer.new()
	root_box.add_child(selected)
	for i in range(draft.size()):
		var id = draft[i]
		var is_equipped = id.begins_with("Q") or id.begins_with("O")
		button(selected,"%s · %s" % [id,Cards.catalog()[id].name],remove_draft.bind(i),"Changez l'emplacement ci-dessus pour retirer cet équipement." if is_equipped else "")
	text(root_box,"Collection acquise · cliquez pour ajouter",21)
	var collection_grid = VBoxContainer.new()
	root_box.add_child(collection_grid)
	for id in calendar.collection:
		if id.begins_with("Q") or id.begins_with("O"): continue
		var limit = 2 if id.begins_with("B") else 1
		var reason = ""
		if draft.size() >= Cards.MAX_DECK: reason = "Retirez une carte avant d'en ajouter."
		if draft.count(id) >= limit: reason = "Limite d'exemplaires atteinte."
		button(collection_grid,"[%d/%d] %s · %s" % [draft.count(id),limit,id,Cards.description(id)],add_draft.bind(id),reason)

func add_draft(id: String) -> void:
	if not editing or not calendar.collection.has(id) or draft.size() >= Cards.MAX_DECK: return
	if id.begins_with("Q") or id.begins_with("O"): return
	if draft.count(id) >= (2 if id.begins_with("B") else 1): return
	draft.append(id)
	refresh()

func remove_draft(index: int) -> void:
	if not editing or index < 0 or index >= draft.size(): return
	if draft[index].begins_with("Q") or draft[index].begins_with("O"): return
	draft.remove_at(index)
	refresh()

func change_slot(index: int, slot_name: String, options: Array) -> void:
	var previous = draft_loadout.get(slot_name,"")
	if previous != "": draft.erase(previous)
	draft_loadout[slot_name] = options[index]
	if options[index] != "": draft.append(options[index])
	message = "La carte équipée est incluse ; retirez une technique si vous dépassez 20 cartes."
	refresh()

func suggest(name: String) -> void:
	draft_loadout = calendar.suggested_loadout(Cards.PRESETS[name])
	draft = calendar.suggested_deck(Cards.PRESETS[name],draft_loadout)
	refresh()

func commit_editor() -> void:
	var error = calendar.configure(draft,draft_loadout)
	if error == "":
		editing = false
		calendar.save_lab()
		message = "Deck enregistré : 12 à 20 cartes acquises. Aucun temps consommé."
	else: message = error
	refresh()
