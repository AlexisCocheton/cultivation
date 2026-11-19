extends HBoxContainer

var actor: Node2D

func setup(enemy: Node2D, announced: Dictionary) -> void:
	actor = enemy
	$Attack.visible = announced.damage > 0
	$Guard.visible = announced.block > 0
	$Attack/Value.text = str(announced.damage)
	$Guard/Value.text = str(announced.block)
	$Attack.tooltip_text = "Prochaine action : %d dégâts, avant ta garde." % announced.damage
	$Guard.tooltip_text = "Prochaine action : gagne %d garde." % announced.block
	_process(0)

func _process(_delta: float) -> void:
	if not is_instance_valid(actor): return
	size = get_combined_minimum_size()
	# Follow the fighter during the lunge too; stay above the head, not the HP panel.
	var head = actor.get_global_transform_with_canvas() * Vector2(0,-96)
	position = head - Vector2(size.x/2.0,52)
