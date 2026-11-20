extends Control

const Story = preload("res://visual/spy/story.gd")
var host
var line = 0
var committing = false

func setup(game) -> void:
	host = game
	$Portrait.present("spy")
	$Continue.pressed.connect(advance)
	show_line()

func show_line() -> void:
	$Title.text = Story.LINES[line][0]
	$Words.text = Story.LINES[line][1]
	$Continue.text = "L'accueillir dans la secte" if line == Story.LINES.size()-1 else "Continuer"
	$Page.text = "%d / %d" % [line+1,Story.LINES.size()]

func advance() -> void:
	if committing: return
	if line < Story.LINES.size()-1:
		line += 1
		show_line()
		return
	committing = true
	if Story.welcome(host.calendar,host.save_progress):
		host.notice = "Une nouvelle recrue rejoint la secte à l'essai."
		host.hub()
	else:
		$Words.text = "L'accueil n'a pas pu être enregistré. Ta progression reste inchangée. Réessaie pour terminer cette rencontre."
		$Continue.text = "Réessayer l'enregistrement"
		committing = false
