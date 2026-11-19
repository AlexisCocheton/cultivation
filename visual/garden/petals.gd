extends Node2D

var particles: Array = []
var elapsed = 0.0

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = 7143
	for i in range(42):
		particles.append({"x":rng.randf_range(-140,1100),"age":rng.randf_range(0,36),"speed":rng.randf_range(18,32),"drift":rng.randf_range(5,17),"phase":rng.randf_range(0,TAU),"radius":rng.randf_range(1.4,3.8)})

func _process(delta: float) -> void:
	elapsed += delta
	for p in particles:
		p.age += delta
		if p.age*p.speed > 920: p.age = 0.0
	queue_redraw()

func _draw() -> void:
	for p in particles:
		var t: float = p.age
		var point = Vector2(fposmod(p.x+t*p.drift+sin(t*0.7+p.phase)*23,1380)-50,t*p.speed-60)
		var opacity = minf(t,1.0)*clampf((860-point.y)/70,0,1)*0.76
		# Keep Lian's face unobstructed, with subtler petals in that part of the image.
		if Rect2(245,120,245,210).has_point(point): opacity *= 0.15
		var r: float = p.radius
		draw_set_transform(point,sin(t+p.phase),Vector2(1,maxf(0.22,absf(cos(t*1.8+p.phase)))))
		draw_colored_polygon(PackedVector2Array([Vector2(-r,0),Vector2(-r*0.4,-r*0.7),Vector2(r*0.7,-r*0.6),Vector2(r*1.6,0),Vector2(r*0.5,r*0.7),Vector2(-r*0.4,r*0.5)]),Color(1,0.66,0.76,opacity))
	draw_set_transform(Vector2.ZERO)
