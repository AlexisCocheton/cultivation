extends Node2D
# The fixed-length blade is baked into every frame; no separate runtime layer.
const BODY_SCALE = 84.0/395.0
func present(frame: int, facing: float) -> void:
	scale = Vector2(BODY_SCALE*facing,BODY_SCALE)
	$Body.frame = clampi(frame,0,5)
	visible = true
