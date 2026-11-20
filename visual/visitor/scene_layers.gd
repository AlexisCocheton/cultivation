extends Control

var elapsed := 0.0

func set_reduced_motion(enabled: bool) -> void:
	set_process(not enabled)
	$Petals.set_process(not enabled)
	$Petals.visible = not enabled
	$Branches.rotation = 0.0

func _process(delta: float) -> void:
	if not is_visible_in_tree(): return
	elapsed += delta
	$Branches.rotation = sin(elapsed * 0.55) * 0.008
