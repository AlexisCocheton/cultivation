extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	root.add_child(load("res://visual/combat/font_web_proposals.tscn").instantiate())
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://docs/ui-proposals/font-web-comparison.png")
	quit()
