extends Node2D
# One immutable blade texture for all poses. Only its rigid transform changes.
const HILTS = [Vector2(260,231),Vector2(718,266)-Vector2(512,0),Vector2(1382,219)-Vector2(1024,0),Vector2(375,722)-Vector2(0,512),Vector2(731,778)-Vector2(512,512),Vector2(1284,743)-Vector2(1024,512)]
const ANGLES = [-20.0,0.0,0.0,0.0,0.0,-20.0]
const BODY_SCALE = 84.0/395.0
func present(frame: int, facing: float) -> void:
	frame = clampi(frame,0,5)
	scale = Vector2(BODY_SCALE*facing,BODY_SCALE)
	$Body.frame = frame
	$Blade.position = HILTS[frame]-Vector2(256,466)
	$Blade.rotation = deg_to_rad(ANGLES[frame])
	visible = true
