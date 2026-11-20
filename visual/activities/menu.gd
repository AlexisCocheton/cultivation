extends Control
const CampaignSession = preload("res://game/campaign/session.gd")

const PERIODS = ["Matin", "Après-midi", "Soir"]
const ACTION_NAMES = {"antidote":"Préparation de l’antidote","L":"Thé et conseils avec Lian", "J":"Entraînement avec Jun", "H":"Étude avec Shen", "work":"Travail dans la cour", "hall":"Restauration du pavillon", "rest":"Repos", "M02":"Le serment de l’aube", "fight":"Duel d’entraînement", "M03":"Défi territorial avec Jun et Lian"}
var game
var summary = false
var selected_action = ""
const CONFIRM_NAMES = {"L":"Partager le thé","J":"S’entraîner","H":"Étudier","work":"Travailler","hall":"Restaurer","rest":"Se reposer","antidote":"Préparer l’antidote"}

func setup(controller, show_summary: bool = false) -> void:
	$Event/Chibi.present("oath")
	game = controller
	summary = show_summary or game.calendar.slot >= game.Progress.END_SLOT
	$Back.pressed.connect(game.hub)
	$Journal.pressed.connect(func(): game.activities_ui(true))
	$Merchant.visible = not summary and game.calendar.day() == 4
	$Merchant.pressed.connect(game.merchant_ui)
	$Confirm.pressed.connect(func():
		if selected_action != "": commit(selected_action))
	$Deck.pressed.connect(game.deck_ui)
	$Deck.visible = summary
	$Continue.pressed.connect(func():
		if game.calendar.slot >= game.Progress.END_SLOT: game.deck_ui()
		else: game.activities_ui())
	$Date.text = "Jour %d · %s" % [game.calendar.day(), PERIODS[game.calendar.period()]]
	$Reserves.text = str(game.calendar.supplies)
	$Reserves.tooltip_text = "R\u00e9serves"
	$Journal.visible = not summary
	$Continue.visible = summary
	$Continue.text = "Composer mon deck" if game.calendar.slot >= game.Progress.END_SLOT else "Choisir la suite"
	if summary and game.calendar.slot < game.Progress.END_SLOT:
		$Continue.text = "Jour %d · %s" % [game.calendar.day(),PERIODS[game.calendar.period()]] if game.calendar.period() == 0 else "Continuer la journée"
	for i in range(3):
		var label = $PeriodStrip.get_child(i)
		label.text = PERIODS[i] + (" ✓" if i < game.calendar.period() else "")
		label.theme_type_variation = &"PeriodActive" if i == game.calendar.period() else &"PeriodQuiet"
	$PeriodStrip.visible = not summary
	$Scenery.visible = not summary
	$SummaryScenery.visible = summary
	$Confirm.visible = false
	$Choices.visible = false
	$Summary.visible = summary
	$Event.visible = false
	if summary:
		populate_summary()
	elif game.Calendar.MAIN.has(game.calendar.slot):
		populate_event()
	else:
		populate_choices()
	$TitleArt.visible = $Choices.visible
	$Title.visible = not $Choices.visible
	$Rule.visible = not $Choices.visible
	$ChoiceFooter.visible = $Choices.visible
	$SelectionTitle.visible = false
	$Notice.visible = not $Choices.visible and (not summary or game.calendar.slot >= game.Progress.END_SLOT)
	if summary:
		$Date.hide()
		$Rule.hide()
		$SummaryScenery.hide()
		$Continue.text = "Composer mon deck" if game.calendar.slot >= game.Progress.END_SLOT else "Continuer"
		$Reserves.text = "Réserves %d" % game.calendar.supplies
		$Detail/Close.pressed.connect(close_summary_detail)
		$Detail/Dim.gui_input.connect(func(event):
			if event is InputEventMouseButton and event.pressed: close_summary_detail())
	$Back.grab_focus()

func populate_choices() -> void:
	$Title.text = "Activités"
	$Choices.visible = true
	$Confirm.visible = true
	var c = game.calendar
	var rows = [
		["L","Thé avec Lian",0], ["work","Travail dans la cour",-1],
		["J","S’entraîner avec Jun",1], ["hall","Restaurer le pavillon",-1],
		["H","Étudier avec Shen",2], ["rest","Repos",-1]]
	if c.day() == 6 and not c.story.prepared: rows[3] = ["antidote","Préparer un antidote",2]
	for i in range(rows.size()):
		var row: Array = rows[i]
		var id: String = row[0]
		var detail: String
		if c.ranks.has(id):
			var rank: int = c.ranks[id]
			detail = "Lien %d / 5\n%s" % [rank,c.relation_reward(id).replace("Recrutement débloqué","Recrutement : rang 3")]

		elif id == "antidote": detail = "Dissipe le poison d’un allié en combat"
		elif id == "work": detail = "+%d réserves" % (c.Balance.WORK_KITCHEN if c.buildings.kitchen >= 1 else c.Balance.WORK_BASE)
		elif id == "hall": detail = "Niveau %d / 2\nCoût : %d réserves" % [c.buildings.hall,3 if c.buildings.hall == 0 else 4]
		else: detail = "Aucun coût en réserves"
		var reason: String = c.reason(id)
		if game.stage == CampaignSession.Stage.INTRODUCTION: reason = "Rejoins d’abord Lian au jardin."
		var entry = $Choices.get_child(i)
		entry.setup(id,row[1],detail,reason,row[2])
		entry.invitation(c.ranks.has(id) and c.invitation_available(id) and reason == "")
		entry.chosen.connect(select_action)
	$Notice.text = "1 p\u00e9riode par activit\u00e9"

func select_action(action: String) -> void:
	selected_action = action
	for entry in $Choices.get_children(): entry.select(entry.action == action)
	$Confirm.disabled = game.calendar.reason(action) != ""
	$Confirm.text = CONFIRM_NAMES.get(action,"Confirmer")

func commit(action: String) -> void:
	if game.busy: return
	if action in ["L","J","H"]: game.resident_activity(action)
	else: game.do_activity(action)

func populate_event() -> void:
	$Scenery.visible = false
	$Title.text = "Le serment de l’aube"
	$Event.visible = true
	$Event/Words.text = "Shen rassemble les disciples.\nQuel engagement guidera tes efforts ?"
	$Notice.text = "Rassemblement obligatoire · 1 période · +%d réserve" % game.calendar.Balance.EVENT_RESERVES
	for id in ["E01","E02"]:
		var button = $Event.get_node(id)
		var card = game.Cards.catalog()[id]
		button.text = card.name
		$Event.get_node(id+"Art").texture = preload("res://visual/deck/tile.gd").illustration(id)
		$Event.get_node(id+"Effect").text = "Coût en combat : %d qi\n" % card.cost + "\n".join(game.Cards.description(id).split("\n").slice(1))
		button.pressed.connect(func(): game.do_activity("M02",id))

func populate_summary() -> void:
	var c = game.calendar
	var day_index = int(maxi(0,c.slot-1)/3) if c.slot % 3 == 0 else int(c.slot/3)
	$Title.text = "Bilan du jour %d" % (day_index+1)
	$Date.text = "Fin de la séquence" if c.slot >= game.Progress.END_SLOT else ("Journée terminée" if c.slot % 3 == 0 else "Journée en cours")
	for period in range(3):
		var records: Array = []
		var activity = "À venir" if day_index*3+period >= c.slot else "Aucune activité enregistrée"
		for record in c.history:
			if int(record.slot) == day_index*3+period:
				records.append(record)
				activity = ACTION_NAMES.get(record.action,record.action)
				if record.action == "L" and int(record.slot) == 3: activity = "Première technique avec Lian"
				if record.action == "S01": activity = "Rencontre du marchand"
				if str(record.action).begins_with("buy:"): activity = "Achat : " + game.Cards.catalog()[str(record.action).substr(4)].name
		$Summary/Rows.get_child(period).setup(PERIODS[period],activity,records,game.Cards)
		$Summary/Rows.get_child(period).card_requested.connect(inspect_summary_card)
	$Notice.text = "Fin du jour 7 : suite en développement. Le deck et les duels libres restent accessibles." if c.slot >= game.Progress.END_SLOT else "Jour %d · %s" % [c.day(),PERIODS[c.period()]]

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if summary and $Detail.visible: close_summary_detail()
		else: game.hub()

var summary_focus: Control
func inspect_summary_card(id: String) -> void:
	summary_focus = get_viewport().gui_get_focus_owner()
	var data = game.Cards.catalog(game.calendar.ranks)[id]
	$Detail/Name.text = data.name
	$Detail/Effects.text = game.Cards.Effects.describe(data)
	$Detail/Art.texture = preload("res://visual/deck/tile.gd").illustration(id)
	$Detail/Cost.text = str(data.cost)
	$Detail/Way.text = game.Cards.way_name(id)
	$Detail.show()
	$Detail/Close.grab_focus()

func close_summary_detail() -> void:
	$Detail.hide()
	if is_instance_valid(summary_focus): summary_focus.grab_focus()
