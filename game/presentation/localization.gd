extends Node
# French is the fallback. Add data/locales/<locale>.json without changing code.
func _ready() -> void:
	var names = DirAccess.get_files_at("res://data/locales")
	for file in names:
		if not file.ends_with(".json"): continue
		var data = JSON.parse_string(FileAccess.get_file_as_string("res://data/locales/"+file))
		if not data is Dictionary: continue
		var translation = Translation.new()
		translation.locale = file.get_basename()
		for key in data: translation.add_message(key,str(data[key]))
		TranslationServer.add_translation(translation)
