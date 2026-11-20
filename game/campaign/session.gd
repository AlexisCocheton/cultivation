extends RefCounted
# Numeric values are part of the v6 save contract; never renumber them.
const Stage = preload("res://game/campaign/stages.gd").Stage
const Calendar = preload("res://game/calendar.gd")
const Progress = preload("res://game/campaign/progress.gd")
var calendar = Calendar.new()
var stage: int = Stage.INTRODUCTION
var completed_duels: int = 0
var muted = false
var reduced_motion = false
func load_from(path: String) -> bool:
	var saved = Progress.read_progress(path)
	if saved.is_empty(): return false
	calendar.restore(saved.state)
	stage = int(saved.stage)
	completed_duels = saved.completed_duels
	muted = saved.muted
	reduced_motion = saved.reduced
	return true
func save_to(path: String) -> bool:
	return Progress.save_progress(calendar,stage,muted,reduced_motion,path,completed_duels)
