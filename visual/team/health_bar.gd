extends Range

var tint_progress = Color("c22e31"):
	set(value):
		tint_progress = value
		if is_node_ready(): _sync()

func _ready() -> void:
	value_changed.connect(func(_value): _sync())
	changed.connect(_sync)
	resized.connect(_sync)
	_sync()

func _sync() -> void:
	$Paint.size = Vector2(size.x * get_as_ratio(),size.y)
	$Paint.visible = value > min_value
	$Paint.modulate = tint_progress
