extends Node2D

var game
var elapsed = 0.0
@export var appearances: Resource = preload("res://visual/garden/lian_appearances.tres")
var requested_pose = "sword_care"
var requested_expression = "smile"
var displayed_key = "sword_care/smile"
var transition: Tween

func present(pose: String, expression: String) -> void:
	requested_pose = pose
	requested_expression = expression
	var resolved: Dictionary = appearances.resolve(pose,expression)
	if resolved.is_empty(): return
	if resolved.key == displayed_key: return
	if is_instance_valid(transition): transition.kill()
	$Previous.texture = $Painting.texture
	$Previous.material.set_shader_parameter("variant_region",$Painting.material.get_shader_parameter("variant_region"))
	$Painting.texture = resolved.texture
	displayed_key = resolved.key
	var region = Vector4.ZERO
	if displayed_key.begins_with("listening/"): region = Vector4(0.215,0.16,0.335,0.33)
	if displayed_key == "explaining/smile": region = Vector4(0.14,0.16,0.51,0.73)
	$Painting.material.set_shader_parameter("variant_region",region)
	$Previous.modulate.a = 1.0
	$Previous.visible = not game.reduced_motion
	if $Previous.visible:
		transition = create_tween()
		transition.tween_property($Previous,"modulate:a",0.0,0.22)
		transition.tween_callback($Previous.hide)

func _process(delta: float) -> void:
	if not visible or not is_instance_valid(game): return
	var animated = not game.reduced_motion
	if not animated and $Previous.visible:
		if is_instance_valid(transition): transition.kill()
		$Previous.hide()
	if animated: elapsed += delta
	$Painting.material.set_shader_parameter("breeze_time",elapsed)
	$Painting.material.set_shader_parameter("motion_amount",1.0 if animated else 0.0)
	$Previous.material.set_shader_parameter("breeze_time",elapsed)
	$Previous.material.set_shader_parameter("motion_amount",1.0 if animated else 0.0)
	$Steam.material.set_shader_parameter("steam_time",elapsed)
	$Steam.visible = animated
	$Petals.visible = animated
	$Petals.set_process(animated)
