extends Control
var home = Vector2.ZERO
var home_angle = 0.0
var index = -1
var playable = true
func setup(id: String, slot: int, enabled: bool, selected: bool) -> void:
	index = slot
	playable = enabled
	var card = $Viewport/Card
	card.card_id = id
	card.mark_selected(selected)
	var data = card.Cards.catalog(card.relation_ranks)[id]
	if data.block > 0 and data.damage == 0:
		card.get_node("Effects").text = card.get_node("Effects").text.replace("%d garde" % data.block,"%d garde à un allié" % data.block)
		card.tooltip_text += "\nGarde : allié choisi."
		if data.persistent: card.tooltip_text += " L’effet persistant reste sur le lanceur."
	$Face.modulate = Color.WHITE if enabled else Color(0.65,0.65,0.65,1)
	tooltip_text = card.tooltip_text
func contains(point: Vector2) -> bool:
	return Rect2(Vector2.ZERO,size).has_point(get_global_transform_with_canvas().affine_inverse()*point)
func pose(destination: Vector2, angle: float, zoom: float, active: bool, delta: float) -> void:
	var weight = minf(1,delta*20)
	position = position.lerp(destination,weight)
	rotation = lerp_angle(rotation,angle,weight)
	scale = scale.lerp(Vector2.ONE*zoom,weight)
	var tilt = Vector2.ZERO
	if active:
		var local = get_local_mouse_position()-size*0.5
		tilt = Vector2(clampf(local.x/600,-0.2,0.2),clampf(-local.y/800,-0.12,0.12))
	$Face.material.set_shader_parameter("tilt",tilt)
	$Face.material.set_shader_parameter("sheen",0.055 if active else 0.0)
