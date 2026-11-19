extends Resource

# Keys are "pose/expression". Each image is a complete, aligned garden plate.
# Missing variants resolve to the existing illustration rather than a broken image.
@export var default_key = "sword_care/smile"
@export var frames: Dictionary = {}

func resolve(pose: String, expression: String) -> Dictionary:
	for key in [pose + "/" + expression, pose + "/neutral", default_key]:
		if frames.get(key) is Texture2D:
			return {"key": key, "texture": frames[key]}
	return {}
