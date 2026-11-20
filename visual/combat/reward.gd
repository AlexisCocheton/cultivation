extends Control
func setup(game) -> void:
	$Continue.pressed.connect(game.deck_ui)
	$Return.pressed.connect(game.garden_ui)
	$Words.text = "Lien avec Lian · rang %d\n\nPétales tranchants rejoint ta collection.\n\nÀ équiper dans ton deck." % game.calendar.ranks.L
