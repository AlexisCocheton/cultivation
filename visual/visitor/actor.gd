extends "res://scripts/avatar.gd"
# Four registered poses; same contact timing/interface as other duel actors.
const POSES = preload("res://assets/visitor/combat-poses.png")
var foot_lines: Array[float] = []
var pose_scale = 1.0
func _ready() -> void:
	super._ready()
	var clean_alpha = ShaderMaterial.new()
	clean_alpha.shader = preload("res://visual/visitor/alpha_cleanup.gdshader")
	sprite.material = clean_alpha
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var image = POSES.get_image()
	var cell = Vector2i(image.get_width()/2,image.get_height()/2)
	var maximum_height = 1
	for i in range(4):
		var bounds = preload("res://visual/team/actor.gd").ink_limits(image.get_region(Rect2i(Vector2i(i%2,i/2)*cell,cell)))
		foot_lines.append(float(bounds.y))
		maximum_height = maxi(maximum_height,bounds.y-bounds.x)
	pose_scale = 92.0/maximum_height
func uses_extended_attack() -> bool: return false
func _process(delta: float) -> void:
	if not is_instance_valid(sprite) or foot_lines.size() != 4: return
	tick += delta
	sprite.texture = POSES
	sprite.hframes = 2
	sprite.vframes = 2
	var pose = 3 if guarding else 0
	if action == "attack": pose = [0,1,2,0][action_frame]
	elif action != "": pose = [0,3,3,3][action_frame]
	sprite.frame = pose
	sprite.scale = Vector2.ONE * pose_scale
	sprite.flip_h = facing > 0
	sprite.position = Vector2(0,-(foot_lines[pose]-POSES.get_height()/4.0)*pose_scale)
	if action.is_empty(): sprite.position.y += sin(tick*1.7)*0.35
	corrected_attack.visible = false
	queue_redraw()
