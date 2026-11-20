extends SceneTree

# Aperçu en mémoire uniquement : le lancement --script désactive la persistance.
func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.persistence = false
	game.stage = 3
	game.calendar.slot = 21
	game.hub()
