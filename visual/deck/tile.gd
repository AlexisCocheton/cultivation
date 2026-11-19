extends Button

const Cards = preload("res://prototypes/cards.gd")
const MANHUA = preload("res://assets/card_manhua_atlas.png")
const MANHUA_IDS = ["B01","B02","B03","B04","B05","B06","B07","B08","L01","H02","E03","Q01"]
const ART = preload("res://assets/card_illustrations.png")
@export var card_id = "B01"

static func illustration(id: String) -> AtlasTexture:
	if MANHUA_IDS.has(id):
		var index = MANHUA_IDS.find(id)
		var art = AtlasTexture.new()
		art.atlas = MANHUA
		var extent = MANHUA.get_size()/Vector2(4,3)
		var crop_y = [0.20,0.20,0.0,0.12,0.12,0.0,0.15,0.12,0.0,0.0,0.05,0.10][index]
		art.region = Rect2(Vector2(index%4,int(index/4))*extent+Vector2(2,extent.y*crop_y),Vector2(extent.x-4,extent.y*0.60))
		return art
	var data = Cards.catalog()[id]
	var quadrant = 1 if id.begins_with("L") else (0 if data.damage > 0 else (2 if data.block > 0 else 3))
	# The protective oath uses the guard illustration in every card view.
	if id == "E02": quadrant = 2
	var atlas = AtlasTexture.new()
	atlas.atlas = ART
	var cell = ART.get_size() / 2
	atlas.region = Rect2(Vector2(quadrant % 2, int(quadrant / 2)) * cell, cell)
	return atlas

func _ready() -> void:
	var data = Cards.catalog()[card_id]
	$Art.texture = illustration(card_id)
	$Name.text = data.name
	$Way.text = Cards.way_name(card_id)
	$Cost.text = "%d" % data.cost
	$Effects.text = Cards.description(card_id).split("\n")[1].replace("retirée après usage jusqu'au prochain combat", "Épuisement")
	match card_id:
		"B07": $Effects.text = "%d garde · Persistante\nMain +2 · Pioche +1/t" % data.block
		"H02": $Effects.text = "%d garde · Persistante\n+1 Force/tour suivant" % data.block
		"B04": $Effects.text = "11 + (deck −12) dégâts\nTaille initiale"
		"B06": $Effects.text = "Pioche 2\n3 si deck initial ≥16"
	tooltip_text = Cards.description(card_id)
	mouse_entered.connect(func(): self_modulate = Color(1.12, 1.08, 1.02))
	mouse_exited.connect(func(): self_modulate = Color.WHITE)

func mark_selected(value: bool) -> void:
	$Selected.visible = value
	$SelectionBorder.visible = value
	$Line.color = Color("be282c") if value else Color("605247")
