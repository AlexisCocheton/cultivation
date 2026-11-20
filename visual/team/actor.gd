extends "res://scripts/avatar.gd"

const TEAM_SHEETS = [
	preload("res://assets/team/lian-weapons-v2.png"),
	preload("res://assets/team/captain-weapons-v2.png"),
	preload("res://assets/team/attacker-weapons-v2.png"),
	preload("res://assets/team/protector-weapons-v2.png")
]
var team_index = 0
var lian_attack: Node2D
var downed = false
var enraged = false
var poisoned = false
var guard_amount = 0
var guard_flash = 0.0
var guard_break = 0.0
static var frame_bottoms: Array = []
static var body_scales: Array[float] = []

static func ink_limits(image: Image) -> Vector2i:
	# Ignore near-transparent generator noise when measuring feet and body height.
	var top = 0
	var bottom = image.get_height()-1
	for y in range(image.get_height()):
		var found = false
		for x in range(image.get_width()):
			if image.get_pixel(x,y).a > 0.1:
				top = y
				found = true
				break
		if found: break
	for y in range(image.get_height()-1,-1,-1):
		var found = false
		for x in range(image.get_width()):
			if image.get_pixel(x,y).a > 0.1:
				bottom = y
				found = true
				break
		if found: break
	return Vector2i(top,bottom+1)

func _ready() -> void:
	super._ready()
	lian_attack = preload("res://visual/team/lian_attack.tscn").instantiate()
	add_child(lian_attack)
	if frame_bottoms.is_empty():
		for sheet in TEAM_SHEETS:
			var image = sheet.get_image()
			var cell = Vector2i(image.get_width()/2,image.get_height()/2)
			var bottoms: Array[float] = []
			for i in range(4):
				var frame = image.get_region(Rect2i(Vector2i(i%2,i/2)*cell,cell))
				var limits = ink_limits(frame)
				bottoms.append(float(limits.y))
				# One constant scale for all poses; never resize a weapon frame by frame.
				if i == 0: body_scales.append(84.0/maxf(1,limits.y-limits.x))
			frame_bottoms.append(bottoms)

func uses_extended_attack() -> bool:
	return team_index in [1,2]

func uses_jun_attack() -> bool:
	return team_index == 1

func configure(index: int, appearance: int = -1) -> void:
	team_index = index if appearance < 0 else appearance
	character_row = 3 if team_index == 6 else (0 if team_index == 0 else 2)
	facing = 1.0 if index < 3 else -1.0
	direction = Direction.SIDE
	combat_ready = true

func set_guard(value: int) -> void:
	if value != guard_amount:
		guard_flash = 0.35
		if guard_amount > 0 and value == 0: guard_break = 0.3
	guard_amount = value
	guarding = value > 0

func _process(delta: float) -> void:
	guard_flash = maxf(0,guard_flash-delta)
	guard_break = maxf(0,guard_break-delta)
	if is_instance_valid(sprite):
		sprite.hframes = 4
		sprite.vframes = 4
	super._process(delta)
	if not is_instance_valid(sprite): return
	lian_attack.visible = false
	if team_index == 2 and action == "attack":
		sprite.visible = false
		corrected_attack.visible = false
		lian_attack.present(action_frame,facing)
	elif team_index >= 2 and team_index < 6:
		corrected_attack.visible = false
		sprite.visible = true
		var sheet = TEAM_SHEETS[team_index-2]
		sprite.texture = sheet
		sprite.frame = 0
		sprite.hframes = 2
		sprite.vframes = 2
		sprite.material.set_shader_parameter("customize",false)
		sprite.scale = Vector2.ONE * body_scales[team_index-2]
		var pose = 3 if guarding else 0
		if action == "attack": pose = [0,1,2,0][action_frame]
		elif action != "": pose = [0,3,3,3][action_frame]
		sprite.frame = pose
		sprite.flip_h = facing < 0
		sprite.position.y = -(frame_bottoms[team_index-2][pose]-sheet.get_height()/4.0)*sprite.scale.y
	if action == "": sprite.position.y += sin(tick*1.7+team_index)*0.4
	modulate = Color(0.45,0.45,0.45,0.55) if downed else Color.WHITE
	queue_redraw()

func _draw() -> void:
	super._draw()
	if guard_break > 0 and not downed:
		for i in range(4):
			var center = Vector2((22+12*(1.0-guard_break/0.3))*facing,-62+i*11)
			draw_line(center,center+Vector2(6*facing,-5),Color(0.7,1,1,guard_break/0.3),1.5,true)
	if enraged and not downed:
		# Short drifting ink wisps behind shoulders, never a geometric ring.
		for side in [-1,1]:
			for strand in range(2):
				var points = PackedVector2Array()
				for i in range(22):
					var t = float(i)/21.0
					var x = (25.0 + strand*5 + sin(t*8+tick*1.2+strand)*4) * side
					points.append(Vector2(x,-35-t*43))
				draw_polyline(points,Color(0.43,0.10,0.14,0.5-strand*0.17),1.35-strand*0.45,true)
	if poisoned and not downed:
		for i in range(3):
			draw_circle(Vector2(-13+i*13,-20-fmod(tick*12+i*9,45)),2,Color(0.6,0.9,0.3,0.65))
