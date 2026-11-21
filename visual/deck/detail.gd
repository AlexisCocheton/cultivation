extends Control
var return_focus: Control
func _ready() -> void:
	visibility_changed.connect(sync_focus)
	if visible: sync_focus()
func sync_focus() -> void:
	if is_visible_in_tree():
		return_focus = get_viewport().gui_get_focus_owner()
		$Close.grab_focus()
	elif is_instance_valid(return_focus) and return_focus.is_visible_in_tree():
		return_focus.grab_focus()
func _input(event: InputEvent) -> void:
	if not is_visible_in_tree(): return
	if event.is_action_pressed("ui_focus_next") or event.is_action_pressed("ui_focus_prev"):
		$Close.grab_focus()
		get_viewport().set_input_as_handled()
