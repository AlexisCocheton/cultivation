extends Button

const Cards = preload("res://prototypes/cards.gd")
const ART = preload("res://assets/card_illustrations.png")
@export var card_id = "B01"

static func illustration(id: String) -> AtlasTexture:
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
	$Cost.text = "%d" % data.cost
	$Effects.text = Cards.description(card_id).split("\n")[1].replace("retirée après usage jusqu'au prochain combat", "Épuisement")
	tooltip_text = Cards.description(card_id)
	mouse_entered.connect(func(): self_modulate = Color(1.12, 1.08, 1.02))
	mouse_exited.connect(func(): self_modulate = Color.WHITE)

func mark_selected(value: bool) -> void:
	$Selected.visible = value
	$SelectionBorder.visible = value
	$Line.color = Color("be282c") if value else Color("605247")
