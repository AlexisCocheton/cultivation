extends Control
signal card_requested(id: String)
const SCENES = preload("res://visual/activities/entry.gd").ILLUSTRATIONS
const ICONS = [preload("res://assets/ui/hub/icons/morning.png"),preload("res://assets/ui/hub/icons/afternoon.png"),preload("res://assets/ui/hub/icons/evening.png")]
var acquired_card = ""
func _ready() -> void:
	$Card.pressed.connect(func(): card_requested.emit(acquired_card))
	$Outcome.meta_clicked.connect(func(id): card_requested.emit(str(id)))


func setup(period: String, activity: String, records: Array, cards) -> void:
	$Period.text = period
	$Icon.texture = ICONS[["Matin","Après-midi","Soir"].find(period)]
	$CardHeading.hide()
	$GainWash.hide()
	$Activity.text = activity
	$Card.visible = false
	$Art.visible = not records.is_empty()
	if records.is_empty():
		$Outcome.text = ""
		return
	var record: Dictionary = records.back()
	var action = str(record.action)
	$Art.texture = SCENES.get(action,preload("res://visual/activities/art.gd").texture(action))
	$Art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED if SCENES.has(action) else TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var lines: Array[String] = []
	for item in records:
		if not item.has("before"):
			lines.append("Réserves après l’activité : %d" % item.supplies)
			continue
		var before: Dictionary = item.before
		if int(item.supplies) != int(before.supplies):
			var delta = int(item.supplies)-int(before.supplies)
			var ink = "#416527" if delta > 0 else "#9b2c24"
			lines.append("Réserves\n[color=%s][font_size=36]%d → %d (%+d)[/font_size][/color]" % [ink,before.supplies,item.supplies,delta])
		for id in item.get("ranks",{}):
			if int(item.ranks[id]) != int(before.ranks[id]):
				lines.append("Lien avec %s\n[color=#416527][font_size=36]%d → %d[/font_size][/color]" % [{"L":"Lian","J":"Jun","H":"Shen"}.get(id,id),before.ranks[id],item.ranks[id]])
		for id in item.get("buildings",{}):
			if int(item.buildings[id]) != int(before.buildings[id]):
				lines.append("%s : %d → %d" % [{"hall":"Pavillon","kitchen":"Cuisine","workshop":"Atelier"}.get(id,id),before.buildings[id],item.buildings[id]])
		for id in item.get("gained",[]):
			if $Card.visible: lines.append("Technique acquise : [url=%s]%s[/url]" % [acquired_card,cards.catalog()[acquired_card].name])
			acquired_card = id
			$Card/Name.text = cards.catalog()[id].name
			$CardHeading.show()
			$Card/Art.texture = preload("res://visual/deck/tile.gd").illustration(id)
			$Card.visible = true
			$Card.tooltip_text = cards.description(id)
			$Card.mouse_filter = Control.MOUSE_FILTER_STOP
		if item.action == "antidote": lines.append("Antidote préparé · 1 dose")
	if lines.is_empty(): lines.append("Une période écoulée")
	$Outcome.text = "\n".join(lines)
	$GainWash.visible = lines.size() == 1 and "[font_size=" in lines[0]
	if not $Card.visible: $Outcome.offset_right = 984.0
