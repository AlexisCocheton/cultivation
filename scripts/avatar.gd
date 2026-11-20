extends Node2D

const SHEET = preload("res://assets/manhua_walk_side.png")
const FRONT_SHEET = preload("res://assets/manhua_walk_front.png")
const BACK_SHEET = preload("res://assets/manhua_walk_back.png")
const COMBAT_SHEET = preload("res://assets/manhua_combat.png")
const FORGE_ATTACK = preload("res://assets/forge_attack/recruit_attack.tres")
const JUN_ATTACK = preload("res://assets/jun_attack/attack.tres")

enum Direction { SIDE, FRONT, BACK }
var direction = Direction.SIDE
var robe_color = Color("99b2ab")
var skin_color = Color("e4b593")
var hair_color = Color("292631")
var elder = false
var walking = false
var facing = 1.0
var tick = 0.0
var character_row = 0
var walk_frame = 1
var destination = Vector2.ZERO
var autonomous = false
var sprite: Sprite2D
var action = ""
var action_frame = 0
var guarding = false
var combat_ready = false
var action_history: Array[String] = []
var corrected_attack: Sprite2D

# Drawn poses; Jun has six attack frames, other actions retain four.
# The contact callback runs at the extension / bracing pose, not on button press.
func perform_action(kind: String, contact: Callable = Callable(), reduced: bool = false) -> void:
	if action != "": return
	action = kind
	action_history.append(kind)
	walking = false
	direction = Direction.SIDE
	var extended_attack = kind == "attack" and uses_extended_attack()
	var durations = [0.12,0.14,0.07,0.12,0.12,0.13] if extended_attack else [0.15,0.10,0.16,0.15]
	for frame in range(durations.size()):
		action_frame = frame
		_process(0)
		if frame == (3 if extended_attack else 2) and contact.is_valid(): contact.call()
		await get_tree().create_timer(0.05 if reduced else durations[frame]).timeout
	action = ""
	_process(0)

func uses_extended_attack() -> bool:
	return uses_jun_attack()

func uses_jun_attack() -> bool:
	return character_row == 2

func clear_combat_pose() -> void:
	guarding = false
	combat_ready = false
	action = ""
	sprite.modulate = Color.WHITE
	sprite.position.x = 0

func face_motion(motion: Vector2) -> void:
	# Preserve the last orientation at rest, including when pushing a boundary.
	if motion.length_squared() < 0.0001:
		return
	if absf(motion.y) >= absf(motion.x):
		direction = Direction.BACK if motion.y < 0 else Direction.FRONT
	else:
		direction = Direction.SIDE
		facing = signf(motion.x)

func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.texture = SHEET
	sprite.hframes = 4
	sprite.vframes = 4
	var cell_height = SHEET.get_height() / 4.0
	sprite.scale = Vector2.ONE * (92.0 / cell_height)
	sprite.position = Vector2(0,-45)
	var palette = ShaderMaterial.new()
	palette.shader = preload("res://shaders/character.gdshader")
	sprite.material = palette
	add_child(sprite)
	corrected_attack = Sprite2D.new()
	corrected_attack.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	corrected_attack.visible = false
	add_child(corrected_attack)

func _process(delta: float) -> void:
	if autonomous:
		var distance = position.distance_to(destination)
		walking = distance > 1.0
		if walking:
			var motion = destination - position
			face_motion(motion)
			position = position.move_toward(destination, 95.0 * delta)
	tick += delta
	walk_frame = int(tick * 7.5) % 4 if walking else 1
	if is_instance_valid(sprite):
		var selected_texture = SHEET
		if direction == Direction.FRONT:
			selected_texture = FRONT_SHEET
		elif direction == Direction.BACK:
			selected_texture = BACK_SHEET
		sprite.texture = selected_texture
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		sprite.scale = Vector2.ONE * (92.0 / (selected_texture.get_height() / 4.0))
		sprite.frame = character_row * 4 + walk_frame
		sprite.flip_h = direction == Direction.SIDE and facing < 0
		sprite.position.y = -45 + (0.0 if walking else sin(tick * 1.7) * 0.45)
		if (action != "" or guarding or combat_ready) and character_row in [0,2]:
			sprite.texture = COMBAT_SHEET
			sprite.scale = Vector2.ONE * (92.0 / (COMBAT_SHEET.get_height()/4.0))
			var combat_row = (0 if character_row == 0 else 1) + (0 if action == "attack" else 2)
			sprite.frame = combat_row*4 + (action_frame if action != "" else (2 if guarding else 0))
			sprite.flip_h = facing < 0
			sprite.position.y = -45
		corrected_attack.visible = (character_row == 0 or uses_jun_attack()) and action == "attack"
		sprite.visible = not corrected_attack.visible
		if corrected_attack.visible:
			if uses_jun_attack():
				corrected_attack.texture = JUN_ATTACK.get_frame_texture("attack",clampi(action_frame,0,5))
				# Shared scale and ground anchor for all six poses: no weapon rescaling.
				corrected_attack.scale = Vector2.ONE * (84.0/395.0)
				corrected_attack.position = Vector2(0,(256.0-480.0)*84.0/395.0)
				corrected_attack.offset = Vector2.ZERO
			else:
				corrected_attack.texture = FORGE_ATTACK.get_frame_texture("attack",action_frame)
				corrected_attack.scale = Vector2.ONE * (92.0/(COMBAT_SHEET.get_height()/4.0))
				corrected_attack.position = Vector2(0,-45)
				corrected_attack.offset = Vector2((321.0/2.0-163.75)*facing,0)
			corrected_attack.flip_h = facing < 0
		sprite.material.set_shader_parameter("customize", character_row == 0)
		sprite.material.set_shader_parameter("robe_color", robe_color)
		sprite.material.set_shader_parameter("skin_color", skin_color)
		sprite.material.set_shader_parameter("hair_color", hair_color)
	queue_redraw()

func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0, Vector2(1,0.28))
	draw_circle(Vector2.ZERO,18,Color(0.05,0.08,0.12,0.32))
	draw_set_transform(Vector2.ZERO)
