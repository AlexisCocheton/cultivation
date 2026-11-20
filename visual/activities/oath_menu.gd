extends "res://visual/activities/menu.gd"
var committing_oath = false

func setup(controller, show_summary: bool = false) -> void:
	super.setup(controller,show_summary)
	$PeriodStrip.hide()
	$Title.hide()
	$Rule.hide()
	$Notice.hide()
	$Event/Chibi.hide()
	$Reserves.text = "Réserves %d" % game.calendar.supplies
	$Reward.text = "+%d réserve" % game.calendar.Balance.EVENT_RESERVES

func populate_event() -> void:
	$Scenery.hide()
	$Event.show()
	$Title.text = "Le serment de l’aube"
	$Event/Words.text = "Shen rassemble les disciples. Quel engagement guidera tes efforts ?"
	for id in ["E01","E02"]:
		var data = game.Cards.catalog()[id]
		var button = $Event.get_node(id)
		button.text = "Choisir"
		button.tooltip_text = "Choisir « %s »" % data.name
		$Event.get_node(id+"Name").text = data.name
		$Event.get_node(id+"Cost").text = str(data.cost)
		$Event.get_node(id+"Way").text = game.Cards.way_name(id)
		$Event.get_node(id+"Art").texture = preload("res://visual/deck/tile.gd").illustration(id)
		$Event.get_node(id+"Effect").text = game.Cards.Effects.compact_description(data)
		button.pressed.connect(func(): choose_oath(id))

func choose_oath(id: String) -> void:
	if committing_oath or game.busy or game.calendar.slot != 6: return
	committing_oath = true
	$Event/E01.disabled = true
	$Event/E02.disabled = true
	var error: String = game.do_activity("M02",id)
	if error != "" and is_inside_tree():
		committing_oath = false
		$Event/E01.disabled = false
		$Event/E02.disabled = false
		$Error.text = error
		$Error.show()
