extends RefCounted

static func texture(action: String) -> Texture2D:
	if action == "H": return preload("res://assets/ui/activities/study-people.png")
	if action == "J": return preload("res://assets/ui/activities/training-people.png")
	if action == "L": return preload("res://assets/ui/tea/people.png")
	var atlas = AtlasTexture.new()
	if action in ["work", "hall", "rest"]:
		atlas.atlas = preload("res://assets/study/chibi-chores.png")
		var cell = atlas.atlas.get_size() / Vector2(3, 1)
		atlas.region = Rect2(Vector2(["work","hall","rest"].find(action),0) * cell,cell)
		return atlas
	if action in ["L", "J"]:
		atlas.atlas = preload("res://assets/study/chibi-activities.png")
		var cell = atlas.atlas.get_size() / Vector2(4, 2)
		atlas.region = Rect2(Vector2(2, 1 if action != "J" else 0) * cell, cell)
		return atlas
	if action in ["H", "antidote"]:
		atlas.atlas = preload("res://assets/study/chibi-study.png")
		var cell = atlas.atlas.get_size() / Vector2(4, 2)
		atlas.region = Rect2(Vector2(1, 0) * cell, cell)
		return atlas
	if action == "S01" or action.begins_with("buy:"):
		return preload("res://assets/events/merchant-chibi.png")
	if action.begins_with("M"):
		return preload("res://assets/events/oath-chibi.png")
	return preload("res://assets/hub/restored.png") if action == "hall" else preload("res://assets/hub/courtyard.png")
