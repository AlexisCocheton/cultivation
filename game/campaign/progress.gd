extends RefCounted
const CampaignStages = preload("res://game/campaign/stages.gd")

const Calendar = preload("res://game/calendar.gd")
const PATH = "user://sequence_visuelle_v2.json"
const VERSION = 6
const END_SLOT = 21 # Fin J7 ; arrivée de l’espionne J8, activités J8 à venir.
const MAX_SAVE_SLOT = 24 # Préparation J8 ; ne débloque pas les journées de jeu.

static func save_progress(calendar, stage: int, muted: bool, reduced: bool, path: String = PATH, completed_duels: int = 0) -> bool:
	var payload = {"version":VERSION,"state":calendar.snapshot(),"stage":stage,"muted":muted,"reduced":reduced,"completed_duels":completed_duels}
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
		if (previous.version == 2 or previous.version == 3) and not FileAccess.file_exists(path+".before-orthodox"):
			if DirAccess.copy_absolute(absolute,absolute+".before-orthodox") != OK: return false
		if previous.version < 5 and not FileAccess.file_exists(path+".before-relations"):
			if DirAccess.copy_absolute(absolute,absolute+".before-relations") != OK: return false
		if previous.version < 6 and not FileAccess.file_exists(path+".before-story"):
			if DirAccess.copy_absolute(absolute,absolute+".before-story") != OK: return false
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
	if payload.get("version") != 2 and payload.get("version") != 3 and payload.get("version") != 4 and payload.get("version") != 5 and payload.get("version") != VERSION: return {}
	var state = payload.get("state")
	if not state is Dictionary: return {}
	var valid = true
	var model = Calendar.new()
	var defaults = model.snapshot()
	for key in defaults:
		if key == "story" and payload.version < 6 and not state.has(key): continue
		if key in ["relation_version","party"] and payload.version < 5 and not state.has(key): continue
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
	if payload.version >= 5 and state.relation_version != Calendar.RELATION_VERSION: return {}
	for rank in state.ranks.values():
		if rank > (5 if payload.version >= 5 else 4): return {}
	if state.slot < 3 or state.slot > (9 if payload.version == 2 else (12 if payload.version == 3 else MAX_SAVE_SLOT)) or state.supplies < 0: return {}
	var stage = payload.get("stage")
	if not (stage is float or stage is int): return {}
	if stage != int(stage) or int(stage) not in [0,1,2,3]: return {}
	if not payload.get("muted") is bool or not payload.get("reduced") is bool: return {}
	var duels = payload.get("completed_duels",1 if stage >= CampaignStages.Stage.TRAINING_COMPLETE else 0)
	if not (duels is float or duels is int): return {}
	if duels < 0 or duels != int(duels): return {}
	payload["completed_duels"] = int(duels)
	for id in state.collection + state.deck:
		if not id is String or not model.Cards.catalog().has(id): valid = false
	if not valid: return {}
	if state.has("story"):
		if not state.story is Dictionary: return {}
		for field in defaults.story:
			if not state.story.has(field): return {}
			if field == "antidote":
				if not (state.story[field] is float or state.story[field] is int) or state.story[field] not in [0,1,0.0,1.0]: return {}
			elif typeof(state.story[field]) != typeof(defaults.story[field]): return {}
	if state.has("story") and not valid_story(state.story): return {}
	model.restore(state)
	if model.party_reason(model.party,true) != "": return {}
	if model.validate_deck(model.deck,model.loadout) != "": return {}
	return payload

static func natural(value) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and value == int(value) and value >= 0

static func valid_story(story: Dictionary) -> bool:
	if story.candidates not in ["","essai","attente"]: return false
	var seen: Array = []
	for id in story.invites:
		if id not in ["J","L"] or seen.has(id): return false
		seen.append(id)
	for id in story.recruit_choices:
		if id not in ["J","L","H"] or story.recruit_choices[id] not in ["A","B"]: return false
	var report: Dictionary = story.battle_report
	if report.is_empty(): return true
	if not report.get("members") is Array or report.members.size() != 2: return false
	if not natural(report.get("rounds")) or report.rounds < 1: return false
	if not natural(report.get("antidote_used")) or report.antidote_used > 1: return false
	seen.clear()
	for member in report.members:
		if not member is Dictionary: return false
		if member.get("id") not in ["J","L","H"] or seen.has(member.id): return false
		if not member.get("name") is String: return false
		for field in ["hp","guard_received","poison"]:
			if not natural(member.get(field)): return false
		seen.append(member.id)
	return true
