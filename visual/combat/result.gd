extends Control

func setup(game, words: String) -> void:
	$Title.text = "Victoire" if game.battle.outcome == "victory" else "Duel terminé"
	$Words.text = words
	$Portrait.present("J" if game.battle.outcome == "victory" else "rest")
	$Back.pressed.connect(game.hub)
