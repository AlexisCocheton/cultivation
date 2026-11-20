extends Control

const Art = preload("res://visual/activities/art.gd")
const GARDEN = preload("res://assets/ui/tea/garden.png")
const HALL = preload("res://assets/ui/activities/study-background.png")
const COURT = preload("res://assets/team/arena.png")
const GATE = preload("res://assets/ui/visitor/gate.png")

func _ready() -> void:
	resized.connect(update_frame)
	update_frame()

func update_frame() -> void:
	$Backdrop.material.set_shader_parameter("panel_size",size)

func present(key: String) -> void:
	$People.visible = true
	$Backdrop.texture = COURT
	match key:
		"L", "invite":
			$Backdrop.texture = GARDEN
			$People.texture = Art.texture("L")
		"H":
			$Backdrop.texture = HALL
			$People.texture = Art.texture("H")
		"antidote", "prepare":
			$Backdrop.texture = HALL
			$People.texture = preload("res://assets/ui/events/antidote.png")
		"spy":
			$Backdrop.texture = GATE
			$People.texture = preload("res://assets/ui/events/spy-welcome.png")
		"merchant":
			$Backdrop.texture = GATE
			$People.texture = preload("res://assets/events/merchant-chibi.png")
		"return", "oath":
			$Backdrop.texture = HALL
			$People.texture = preload("res://assets/events/oath-chibi.png")
		"candidates":
			$Backdrop.texture = GATE
			$People.visible = false
		_:
			$People.texture = Art.texture(key)
	update_frame()
