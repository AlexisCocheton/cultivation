extends RefCounted

const Calendar = preload("res://prototypes/calendar.gd")
const PATH = "user://sequence_visuelle_v2.json"
const END_SLOT = 12 # End of day 4; old slot 9 resumes on day 4 morning.

static func save_progress(calendar, stage: int, muted: bool, reduced: bool, path: String = PATH, completed_duels: int = 0) -> bool:
	var payload = {"version":3,"state":calendar.snapshot(),"stage":stage,"muted":muted,"reduced":reduced,"completed_duels":completed_duels}
	var file = FileAccess.open(path+".tmp",FileAccess.WRITE)
	if file == null: return false
	file.store_string(JSON.stringify(payload))
	file.flush()
	var write_error = file.get_error()
	file.close()
	if write_error != OK or _read_file(path+".tmp").is_empty(): return false
	var absolute = ProjectSettings.globalize_path(path)
	var previous = _read_file(path)
	if not previous.is_empty():
		# Only rotate a validated primary; preserve a good backup after recovery.
		# Keep a permanent pre-migration copy, separately from the rotating backup.
		if previous is Dictionary and previous.get("version") == 2 and not FileAccess.file_exists(path+".before-day4"):
			if DirAccess.copy_absolute(absolute,absolute+".before-day4") != OK: return false
		if DirAccess.copy_absolute(absolute,absolute+".bak") != OK: return false
	return DirAccess.rename_absolute(absolute+".tmp",absolute) == OK

static func read_progress(path: String = PATH) -> Dictionary:
	for candidate in [path,path+".bak"]:
		var payload = _read_file(candidate)
		if not payload.is_empty(): return payload
	return {}

# Validate one file only: never mistake its fallback for a valid primary.
static func _read_file(candidate: String) -> Dictionary:
	if not FileAccess.file_exists(candidate): return {}
	var parser = JSON.new()
	if parser.parse(FileAccess.get_file_as_string(candidate)) != OK: return {}
	var payload = parser.data
	if not payload is Dictionary: return {}
	if payload.get("version") != 2 and payload.get("version") != 3: return {}
	var state = payload.get("state")
	if not state is Dictionary: return {}
	var valid = true
	var model = Calendar.new()
	var defaults = model.snapshot()
	for key in defaults:
		if not state.has(key): valid = false; break
		var expected = defaults[key]
		var value = state[key]
		if expected is int:
			if not (value is float or value is int) or value != int(value): valid = false; break
		elif typeof(expected) != typeof(value): valid = false; break
	if not valid: return {}
	for key in ["ranks","last_day","buildings"]:
		for field in defaults[key]:
			var value = state[key].get(field)
			if not (value is float or value is int) or value != int(value) or value < 0: valid = false
	if not valid: return {}
	if state.slot < 3 or state.slot > (9 if payload.version == 2 else END_SLOT) or state.supplies < 0: return {}
	var stage = payload.get("stage")
	if not (stage is float or stage is int): return {}
	if stage != int(stage) or int(stage) not in [0,1,2,3]: return {}
	if not payload.get("muted") is bool or not payload.get("reduced") is bool: return {}
	var duels = payload.get("completed_duels",1 if stage >= 3 else 0)
	if not (duels is float or duels is int): return {}
	if duels < 0 or duels != int(duels): return {}
	payload["completed_duels"] = int(duels)
	for id in state.collection + state.deck:
		if not id is String or not model.Cards.catalog().has(id): valid = false
	if not valid: return {}
	model.restore(state)
	if model.validate_deck(model.deck,model.loadout) != "": return {}
	return payload
