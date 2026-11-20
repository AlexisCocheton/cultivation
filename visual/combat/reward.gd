extends Control
func setup(game) -> void:
	$Continue.pressed.connect(game.deck_ui)
