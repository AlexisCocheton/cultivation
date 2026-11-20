extends SceneTree

const Calendar = preload("res://game/calendar.gd")
const Progress = preload("res://game/campaign/progress.gd")
const Story = preload("res://visual/spy/story.gd")
var failures = 0
var checks = 0

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(message)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var calendar = Calendar.new()
	for slot in range(3,21):
		calendar.slot = slot
		check(not Story.pending(calendar),"Pas d'arrivée avant J8")
	calendar.slot = 21
	check(Story.pending(calendar),"Arrivée J8 matin")
	var before = calendar.snapshot().duplicate(true)
	check(not Story.welcome(calendar,func(): return false),"Échec sauvegarde signalé")
	check(calendar.snapshot() == before,"Échec sans mutation")
	var path = "user://spy_arrival_test.json"
	check(Story.welcome(calendar,func(): return Progress.save_progress(calendar,3,true,true,path,7)),"Accueil sauvegardé")
	check(not Story.pending(calendar),"Événement unique")
	check(not Story.welcome(calendar,func(): return true),"Double validation impossible")
	var payload = Progress.read_progress(path)
	check(not payload.is_empty(),"Sauvegarde J8 lisible")
	if not payload.is_empty():
		var restored = Calendar.new()
		restored.restore(payload.state)
		check(not Story.pending(restored),"Reprise sans doublon")
		check(payload.completed_duels == 7,"Compteur Jun conservé")
		var expected = before.duplicate(true)
		expected.seen.append(Story.ARRIVED)
		check(restored.snapshot() == expected,"Seul le marqueur d'accueil change")
	calendar.restore(before)
	calendar.slot = 22
	check(Story.pending(calendar),"Rattrapage après J8 matin")
	calendar.complete = true
	check(not Story.pending(calendar),"Pas après fin de campagne")
	calendar.complete = false
	calendar.slot = 9
	check(Progress.save_progress(calendar,3,false,false,path,2),"Sauvegarde actuelle J4 compatible")
	check(Progress.read_progress(path).state.slot == 9,"J4 non avancé")
	root.size = Vector2i(1280,832)
	root.content_scale_size = Vector2i(1280,832)
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.persistence = false
	game.stage = 3
	game.calendar.slot = 21
	game.hub()
	check(game.mode == "spy_arrival","Déclenchement depuis la cour")
	var screen = game.ui.get_child(0)
	check(screen.get_node("Portrait/People").texture != null,"Portrait validé chargé")
	if DisplayServer.get_name() != "headless":
		await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("res://tests/spy-arrival.png")
	for i in range(4): screen.advance()
	check(game.mode == "hub","Retour cour après accueil")
	check(game.calendar.seen.has(Story.ARRIVED),"Accueil enregistré par interface")
	check(game.calendar.slot == 21,"Aucune période consommée")
	game.hub()
	check(game.mode == "hub","Pas de redéclenchement")
	game.queue_free()
	await process_frame
	print("Spy arrival: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
