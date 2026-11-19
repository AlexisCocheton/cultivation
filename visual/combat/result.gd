extends Control

func setup(game, words: String) -> void:
	$Title.text = "Victoire" if game.battle.outcome == "victory" else "Duel terminé"
	$Words.text = words
	var texture = AtlasTexture.new()
	texture.atlas = preload("res://assets/portraits_manhua.png")
	var cell = texture.atlas.get_size() / Vector2(3,2)
	texture.region = Rect2(Vector2(cell.x,cell.y),cell)
	$Portrait.texture = texture
	$Back.pressed.connect(game.hub)
