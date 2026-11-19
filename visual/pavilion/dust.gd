extends Node2D

var elapsed = 0.0
var motes: Array = []

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = 5210
	for i in range(36):
		motes.append(Vector4(rng.randf_range(440,1270),rng.randf_range(90,710),rng.randf_range(0,TAU),rng.randf_range(0.7,1.5)))

func _process(delta: float) -> void:
	elapsed += delta
	queue_redraw()

func _draw() -> void:
	for m in motes:
		var p = Vector2(m.x+sin(elapsed*0.22+m.z)*12,90+fposmod(m.y-90-elapsed*2.5,620))
		var alpha = 0.13+0.09*sin(elapsed*0.5+m.z)
		if Rect2(830,100,175,230).has_point(p): alpha *= 0.2
		draw_circle(p,m.w,Color(1,0.91,0.7,alpha))
