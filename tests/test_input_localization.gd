extends SceneTree
const Book = preload("res://game/presentation/dialogue_book.gd")
var failures = 0
var checks = 0
func _initialize(): call_deferred("run")
func check(ok: bool, message: String):
	checks += 1
	if not ok: failures += 1; push_error(message)
func codes(action: String) -> Array:
	var values = []
	for event in InputMap.action_get_events(action):
		if event is InputEventKey: values.append(event.physical_keycode)
	return values
func run():
	var bindings = root.get_node("InputBindings")
	var existed = FileAccess.file_exists(bindings.PATH)
	var backup = FileAccess.get_file_as_bytes(bindings.PATH) if existed else PackedByteArray()
	check(bindings.reset_bindings() == "", "Reset bindings")
	var defaults = {}
	for action in bindings.ACTIONS: defaults[action] = codes(action)
	check(KEY_Q in defaults.move_left and KEY_A in defaults.move_left, "AZERTY/QWERTY defaults")
	for pair in [["move_left",KEY_LEFT],["move_right",KEY_RIGHT],["move_up",KEY_UP],["move_down",KEY_DOWN]]:
		check(pair[1] in defaults[pair[0]], "Correct directional arrow " + pair[0])
		for other in defaults:
			if other != pair[0]: check(not pair[1] in defaults[other], "Arrow does not cross actions " + other)
	check(bindings.rebind("move_left",KEY_J) == "", "Remap allowed key")
	check(codes("move_left") == [KEY_J], "Remap active")
	bindings.apply_key("move_left",KEY_K)
	bindings._ready()
	check(codes("move_left") == [KEY_J], "Persisted remap reload")
	check(bindings.rebind("interact",KEY_J) != "", "Duplicate binding rejected")
	check(codes("interact") == defaults.interact, "Conflict leaves old binding intact")
	check(bindings.rebind("interact",KEY_ESCAPE) != "", "Escape reserved")
	check(bindings.rebind("unknown",KEY_K) != "", "Unknown action rejected")
	check(bindings.rebind("interact",0) != "", "Invalid key rejected")
	var panel = load("res://visual/settings/controls.tscn").instantiate()
	root.add_child(panel)
	await process_frame
	check(panel.get_node("Paper/move_left").text == bindings.label_for("move_left"), "Settings labels use binding source")
	panel.get_node("Paper/move_left").pressed.emit()
	check(panel.pending == "move_left", "Capture started from UI")
	var event = InputEventKey.new()
	event.pressed = true; event.keycode = KEY_ESCAPE; event.physical_keycode = KEY_ESCAPE
	panel._input(event)
	check(panel.pending == "" and codes("move_left") == [KEY_J], "Escape cancels capture")
	panel.get_node("Paper/move_left").pressed.emit()
	event.keycode = KEY_K; event.physical_keycode = KEY_K
	panel._input(event)
	check(panel.pending == "" and codes("move_left") == [KEY_K], "UI commits valid binding")
	panel.get_node("Paper/Reset").pressed.emit()
	for action in bindings.ACTIONS: check(codes(action) == defaults[action], "Reset restores " + action)
	if DisplayServer.get_name() != "headless":
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/input-settings.png")
	panel.queue_free()
	var locale = TranslationServer.get_locale()
	TranslationServer.set_locale("fr")
	var source = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogues/residents.json"))
	var translations = JSON.parse_string(FileAccess.get_file_as_string("res://data/locales/fr.json"))
	for id in source:
		var rows = Book.lines(id)
		check(rows.size() == source[id].size(), "Dialogue length " + id)
		for i in range(rows.size()):
			var indexes = [0,3] if rows[i].size() == 4 else [0]
			for column in indexes:
				var key = source[id][i][column]
				check(translations.has(key) and rows[i][column] == translations.get(key), "Translated dialogue " + key)
				check(not rows[i][column].begins_with("dialogue."), "No raw translation key")
		rows[0][0] = "mutation"
		check(Book.lines(id)[0][0] != "mutation", "Dialogue copies isolated")
	TranslationServer.set_locale(locale)
	if existed:
		var file = FileAccess.open(bindings.PATH,FileAccess.WRITE)
		file.store_buffer(backup); file.close()
	else: DirAccess.remove_absolute(ProjectSettings.globalize_path(bindings.PATH))
	await create_timer(0.5).timeout
	print("INPUT_LOCALIZATION: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)


