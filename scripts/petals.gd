extends Node2D

var clock = 0.0
var particles: Array = []
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.seed = 4271
	for i in range(65):
		particles.append({"origin": Vector2(rng.randf_range(0,470),rng.randf_range(-100,120)), "age":rng.randf_range(0,24), "speed":rng.randf_range(17,30), "drift":rng.randf_range(17,39), "phase":rng.randf_range(0,TAU), "size":rng.randf_range(1.4,3.1)})

func _process(delta: float) -> void:
	clock += delta
	for p in particles:
		p.age += delta
		if p.age > 32:
			p.age = 0.0
	queue_redraw()

func _draw() -> void:
	for p in particles:
		var t: float = p.age
		var pos: Vector2 = p.origin + Vector2(t*p.drift + sin(t*1.5+p.phase)*17,t*p.speed)
		pos.x += sin(clock*1.15)*9
		var opacity = minf(t,1.0) * clampf((830-pos.y)/75,0,1)*0.8
		draw_set_transform(pos, sin(t*2+p.phase)*1.8)
		var flutter = maxf(0.25,abs(cos(t*3+p.phase)))
		draw_colored_polygon(PackedVector2Array([Vector2(-p.size,0),Vector2(0,-p.size*flutter),Vector2(p.size*1.6,0),Vector2(0,p.size*flutter)]),Color(0.97,0.63,0.72,opacity))
	draw_set_transform(Vector2.ZERO)
