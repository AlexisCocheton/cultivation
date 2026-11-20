extends Button

const Cards = preload("res://game/cards.gd")
const ART = preload("res://assets/card_illustrations.png")
var card_id = "B01"

func _ready() -> void:
	custom_minimum_size = Vector2(176,246)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	tooltip_text = Cards.description(card_id)
	for state in ["normal","hover","pressed","disabled","focus"]:
		var box = StyleBoxFlat.new()
		box.bg_color = Color("142b36") if state != "hover" else Color("244752")
		box.border_color = Color("c6a66b") if state != "disabled" else Color("53616a")
		box.set_border_width_all(2)
		box.set_corner_radius_all(8)
		add_theme_stylebox_override(state,box)
	var c = Cards.catalog()[card_id]
	var quadrant = 1 if card_id.begins_with("L") else (0 if c.damage > 0 else (2 if c.block > 0 else 3))
	var atlas = AtlasTexture.new()
	atlas.atlas = ART
	var cell = ART.get_size()/2
	atlas.region = Rect2(Vector2(quadrant%2,int(quadrant/2))*cell,cell)
	var art = TextureRect.new()
	art.texture = atlas
	art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.position = Vector2(8,36)
	art.size = Vector2(160,102)
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(art)
	caption("%d QI" % c.cost,Vector2(12,8),Vector2(150,25),17,Color("edd2a0"))
	caption(c.name,Vector2(10,144),Vector2(156,40),16,Color("fff1d8"))
	var description = Cards.description(card_id).split("\n")[1]
	description = description.replace("retirée après usage jusqu'au prochain combat","Épuisement")
	caption(description,Vector2(10,184),Vector2(156,57),13,Color("d1dedf"))

func caption(value: String, pos: Vector2, extent: Vector2, font_size: int, color: Color) -> void:
	var label = Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.position = pos
	label.size = extent
	label.clip_text = true
	label.add_theme_font_size_override("font_size",font_size)
	label.add_theme_color_override("font_color",color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)
