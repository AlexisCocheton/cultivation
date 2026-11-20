extends Control

signal chosen(action: String)
var action = ""
var available = false
const ILLUSTRATIONS = {
	"L": preload("res://assets/ui/activities/strict/tea.png"),
	"J": preload("res://assets/ui/activities/strict/training.png"),
	"H": preload("res://assets/ui/activities/strict/study.png"),
	"work": preload("res://assets/ui/activities/strict/work.png"),
	"hall": preload("res://assets/ui/activities/strict/repair.png"),
	"rest": preload("res://assets/ui/activities/strict/rest.png"),
	"antidote": preload("res://assets/ui/events/antidote.png")
}

func setup(id: String, title: String, detail: String, reason: String, portrait_index: int = -1) -> void:
	action = id
	$Action.text = ""
	$Name.text = title
	$Action.disabled = reason != ""
	available = reason == ""
	$Action.tooltip_text = reason if reason != "" else "Consomme une période"
	$Detail.text = detail
	$Availability.text = reason.replace("Rang disponible à partir du jour ","Dès le jour ") if reason != "" else "1 période"
	$Availability.theme_type_variation = &"Unavailable" if reason != "" else &"Label"
	$Portrait.texture = ILLUSTRATIONS.get(id)
	$Portrait.modulate.a = 1.0 if available else 0.65
	$Action.pressed.connect(func(): chosen.emit(action))

func select(value: bool) -> void:
	$Action.set_pressed_no_signal(value)
	$Selection.visible = value

func invitation(value: bool) -> void:
	$Invitation.visible = value
