extends Control
const CampaignSession = preload("res://game/campaign/session.gd")

const PERIODS = ["Matin", "Après-midi", "Soir"]
const ACTION_NAMES = {"antidote":"Préparation de l’antidote","L":"Thé et conseils avec Lian", "J":"Entraînement avec Jun", "H":"Étude avec Shen", "work":"Travail dans la cour", "hall":"Restauration du pavillon", "rest":"Repos", "M02":"Le serment de l’aube", "fight":"Duel d’entraînement", "M03":"Défi territorial avec Jun et Lian"}
var game
var summary = false

func setup(controller, show_summary: bool = false) -> void:
	game = controller
	summary = show_summary or game.calendar.slot >= game.Progress.END_SLOT
	$Back.pressed.connect(game.hub)
	$Journal.pressed.connect(func(): game.activities_ui(true))
	$Merchant.visible = not summary and game.calendar.day() == 4
	$Merchant.pressed.connect(game.merchant_ui)
	$Continue.pressed.connect(func():
		if game.calendar.slot >= game.Progress.END_SLOT: game.deck_ui()
		else: game.activities_ui())
	$Date.text = "Jour %d · %s" % [game.calendar.day(), PERIODS[game.calendar.period()]]
	$Reserves.text = "Réserves : %d" % game.calendar.supplies
	$Journal.visible = not summary
	$Continue.visible = summary
	$Continue.text = "Composer mon deck" if game.calendar.slot >= game.Progress.END_SLOT else "Choisir la suite"
	$Choices.visible = false
	$Summary.visible = summary
	$Event.visible = false
	if summary:
		populate_summary()
	elif game.Calendar.MAIN.has(game.calendar.slot):
		populate_event()
	else:
		populate_choices()
	$Back.grab_focus()

func populate_choices() -> void:
	$Title.text = "Le carnet de la secte"
	$Choices.visible = true
	var c = game.calendar
	var rows = [
		["L","Le thé avec Lian",0], ["work","Travailler dans la cour",-1],
		["J","S’entraîner avec Jun",1], ["hall","Restaurer le pavillon",-1],
		["H","Étudier avec Shen",2], ["rest","Se reposer",-1]]
	if c.day() == 6 and not c.story.prepared: rows[3] = ["antidote","Préparer un antidote",2]
	for i in range(rows.size()):
		var row: Array = rows[i]
		var id: String = row[0]
		var detail: String
		if c.ranks.has(id):
			var rank: int = c.ranks[id]
			detail = "Lien %d / 5 → %s" % [rank,c.relation_reward(id).replace("Recrutement débloqué","Recrutement au rang 3")]

		elif id == "antidote": detail = "1 période · Dissipe le poison d’un allié en combat"
		elif id == "work": detail = "+%d réserves" % (c.Balance.WORK_KITCHEN if c.buildings.kitchen >= 1 else c.Balance.WORK_BASE)
		elif id == "hall": detail = "Niveau %d / 2 · Coût : %d réserves" % [c.buildings.hall,3 if c.buildings.hall == 0 else 4]
		else: detail = "Passer une période · Aucun coût en réserves"
		var reason: String = c.reason(id)
		if game.stage == CampaignSession.Stage.INTRODUCTION: reason = "Rejoins d’abord Lian au jardin."
		var entry = $Choices.get_child(i)
		entry.setup(id,row[1],detail,reason,row[2])
		entry.chosen.connect(commit)
	$Notice.text = "Chaque activité consomme une période. Les visites et les dialogues sont gratuits."

func commit(action: String) -> void:
	if game.busy: return
	if action in ["L","J","H"]: game.resident_activity(action)
	else: game.do_activity(action)

func populate_event() -> void:
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
	var day_index = int(maxi(3,c.slot-1)/3) if c.slot % 3 == 0 else int(c.slot/3)
	$Title.text = "Bilan du jour %d" % (day_index+1)
	$Date.text = "Fin de la séquence" if c.slot >= game.Progress.END_SLOT else ("Journée terminée" if c.slot % 3 == 0 else "Journée en cours")
	var lines: Array[String] = []
	for period in range(3):
		var activity = "À venir" if day_index*3+period >= c.slot else "Aucune activité enregistrée"
		for record in c.history:
			if int(record.slot) == day_index*3+period:
				activity = ACTION_NAMES.get(record.action,record.action)
				if record.action == "L" and int(record.slot) == 3: activity = "Première technique avec Lian"
				if record.action == "S01": activity = "Rencontre du marchand"
				if str(record.action).begins_with("buy:"): activity = "Achat : " + game.Cards.catalog()[str(record.action).substr(4)].name
		lines.append(PERIODS[period]+"\n"+activity)
	$Summary/Log.text = "\n\n".join(lines)
	$Summary/State.text = "Pavillon : %d / 2 restauré\n%d techniques possédées · %d cartes dans le deck\nLiens : Lian %d / 5 · Jun %d / 5 · Shen %d / 5" % [c.buildings.hall,c.collection.size(),c.deck.size(),c.ranks.L,c.ranks.J,c.ranks.H]
	$Summary/Art.texture = load("res://assets/hub/restored.png" if c.buildings.hall == 2 else "res://assets/hub/courtyard.png")
	$Notice.text = "Fin du jour 7 : suite en développement. Le deck et les duels libres restent accessibles." if c.slot >= game.Progress.END_SLOT else "Ta progression est conservée. Les valeurs affichées décrivent l’état actuel de la secte."

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		game.hub()
