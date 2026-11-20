extends Node
const ACTIONS = ["move_left","move_right","move_up","move_down","interact","open_deck"]
const PATH = "user://input_bindings.cfg"
func _ready() -> void:
	var config = ConfigFile.new()
	if config.load(PATH) != OK: return
	for action in ACTIONS:
		var code = config.get_value("keys",action,0)
		if code is int and code > 0: apply_key(action,code)
func apply_key(action: String, code: int) -> void:
	InputMap.action_erase_events(action)
	var event = InputEventKey.new()
	event.physical_keycode = code
	InputMap.action_add_event(action,event)
func rebind(action: String, code: int) -> String:
	if not ACTIONS.has(action) or code <= 0: return "Touche invalide."
	if code == KEY_ESCAPE: return "Échap reste réservé au retour."
	for other in ACTIONS:
		if other == action: continue
		for event in InputMap.action_get_events(other):
			if event is InputEventKey and event.physical_keycode == code: return "Cette touche est déjà utilisée."
	var config = ConfigFile.new()
	config.load(PATH)
	config.set_value("keys",action,code)
	if config.save(PATH) != OK: return "Impossible d’enregistrer les touches."
	apply_key(action,code)
	return ""
func reset_bindings() -> String:
	if ConfigFile.new().save(PATH) != OK: return "Impossible d’enregistrer les touches."
	for action in ACTIONS:
		InputMap.action_erase_events(action)
		for event in ProjectSettings.get_setting("input/"+action).events:
			InputMap.action_add_event(action,event)
	return ""
func label_for(action: String) -> String:
	var names: Array[String] = []
	for event in InputMap.action_get_events(action):
		if event is InputEventKey: names.append(OS.get_keycode_string(event.physical_keycode))
	return " / ".join(names)
