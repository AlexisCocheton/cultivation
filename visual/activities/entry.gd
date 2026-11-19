extends Control

signal chosen(action: String)
var action = ""

func setup(id: String, title: String, detail: String, reason: String, portrait_index: int = -1) -> void:
	action = id
	$Action.text = title
	$Action.disabled = reason != ""
	$Action.tooltip_text = reason if reason != "" else "Consomme une période"
	$Detail.text = detail
	$Availability.text = reason if reason != "" else "1 période"
	$Availability.theme_type_variation = &"Unavailable" if reason != "" else &"Label"
	$Portrait.visible = portrait_index >= 0
	if portrait_index >= 0:
		var atlas = AtlasTexture.new()
		atlas.atlas = preload("res://assets/hub/portraits.png")
		var cell = atlas.atlas.get_size()/Vector2(3,2)
		atlas.region = Rect2(Vector2(portrait_index,0)*cell,cell)
		$Portrait.texture = atlas
	$Action.pressed.connect(func(): chosen.emit(action))
