extends RefCounted
# Content is data; callbacks and progression stay in the campaign coordinator.
static func lines(id: String) -> Array:
	if _cache().dialogues.is_empty():
		_cache().dialogues = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogues/residents.json"))
	var result: Array = _cache().dialogues[id].duplicate(true)
	for row in result:
		row[0] = TranslationServer.translate(row[0])
		if row.size() == 4: row[3] = TranslationServer.translate(row[3])
	return result

static func recruitment(id: String) -> Array:
	if _cache().recruitment.is_empty():
		_cache().recruitment = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogues/recruitment.json"))
	var result: Array = _cache().recruitment[id].duplicate()
	for i in range(result.size()): result[i] = TranslationServer.translate(result[i])
	return result

static func _cache():
	return Engine.get_main_loop().root.get_node("DataCache")
