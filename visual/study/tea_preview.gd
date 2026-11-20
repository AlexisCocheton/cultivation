extends Node

const Calendar = preload("res://game/calendar.gd")
const Cards = preload("res://game/cards.gd")
const Progress = preload("res://game/campaign/progress.gd")
var calendar = Calendar.new()
var reduced_motion = false
var busy = true

func _ready() -> void:
	calendar.slot = 11
	calendar.ranks.L = 4
	calendar.history = [{"slot":10,"action":"L","before":{"ranks":{"L":3}}}]
	$Tea.setup(self,["L02"])
	await get_tree().create_timer(0.2).timeout
	DisplayServer.window_set_title("Le thé avec Lian — Aperçu des calques (sans sauvegarde)")
	if OS.get_cmdline_user_args().has("--capture"):
		await get_tree().create_timer(0.8).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("res://docs/ui-activities-2026-11-20/the-lian-godot.png")
		get_tree().quit()

func return_to_location() -> void:
	get_tree().quit()

func activities_ui(_summary: bool = false) -> void:
	get_tree().quit()
