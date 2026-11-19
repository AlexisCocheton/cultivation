extends Node2D

var game
var elapsed = 0.0
var expression = "neutral"
var transition: Tween
const FRAMES = {
	"neutral": preload("res://assets/pavilion/shen-study.png"),
	"kind": preload("res://assets/pavilion/shen-kind.png"),
	"serious": preload("res://assets/pavilion/shen-serious.png")
}

func present(value: String) -> void:
	if not FRAMES.has(value): value = "neutral"
	if value == expression: return
	if is_instance_valid(transition): transition.kill()
	$Previous.texture = $Painting.texture
	$Painting.texture = FRAMES[value]
	expression = value
	$Previous.modulate.a = 1.0
	$Previous.visible = not game.reduced_motion
	if $Previous.visible:
		transition = create_tween()
		transition.tween_property($Previous,"modulate:a",0.0,0.22)
		transition.tween_callback($Previous.hide)


func _process(delta: float) -> void:
	if not is_instance_valid(game): return
	if game.reduced_motion and $Previous.visible:
		if is_instance_valid(transition): transition.kill()
		$Previous.hide()
	var animated = visible and not game.reduced_motion
	if animated: elapsed += delta
	$Tea.material.set_shader_parameter("steam_time",elapsed)
	$Incense.material.set_shader_parameter("steam_time",elapsed*0.7+2.0)
	$Tea.visible = animated
	$Incense.visible = animated
	$Dust.visible = animated
	$Dust.set_process(animated)
