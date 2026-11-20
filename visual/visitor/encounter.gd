extends Control
const CampaignSession = preload("res://game/campaign/session.gd")
const Battle = preload("res://game/battle.gd")
const Hud = preload("res://visual/combat/hud.tscn")
const Tile = preload("res://visual/deck/tile.gd")
var host
var battle = Battle.new()
var busy = false
var muted = false
var reduced_motion = false
var actors: Array = []
var phase = "intro"
var resolved = false

func setup(controller) -> void:
	host = controller
	muted = host.muted
	reduced_motion = host.reduced_motion
	$Conversation/SceneLayers.set_reduced_motion(reduced_motion)
	actors = [$EnemyMarker,$EnemyMarker,$EnemyMarker]
	$Arena/Recruit.texture = Tile.illustration("B01")
	$Conversation/Back.pressed.connect(leave_combat)
	$Conversation/Primary.pressed.connect(primary)
	if host.calendar.seen.has("visitor_won"):
		phase = "offer"
		show_words(tr("text.8b577e5cf977"), tr("text.c5de31f60ea2"), tr("text.4ea1e5d3de1e"))
	elif host.calendar.seen.has("visitor_defeated"):
		show_words("La voyageuse t’attend", tr("text.6c623786dd04"), "Demander une revanche")
	else:
		show_words(tr("text.b282443147e6"), tr("text.c11d1b07fc55"), "Relever le défi")

func show_words(title: String, words: String, action: String) -> void:
	$Arena.visible = false
	$Conversation.visible = true
	for child in $HUD.get_children():
		$HUD.remove_child(child)
		child.queue_free()
	$Conversation/Title.text = title
	$Conversation/Words.text = words
	$Conversation/Primary.text = action
	$Conversation/Terms.visible = phase == "intro"

func primary() -> void:
	if busy: return
	if phase == "intro": start_duel()
	elif phase == "save_error": finish_duel()
	else: host.hub()

func record_flag(flag: String) -> bool:
	var before = host.calendar.seen.duplicate()
	if not host.calendar.seen.has(flag): host.calendar.seen.append(flag)
	if host.save_progress(): return true
	host.calendar.seen = before
	return false

func start_duel() -> void:
	if busy or phase != "intro" or host.stage < CampaignSession.Stage.TRAINING_COMPLETE: return
	var error: String = host.calendar.validate_deck(host.calendar.deck,host.calendar.loadout)
	if error != "": $Conversation/Terms.text = error; return
	if not record_flag("visitor_met"):
		$Conversation/Terms.text = tr("text.30237d25ff6c")
		return
	battle.relation_ranks = host.calendar.ranks.duplicate()
	error = battle.start(host.calendar.deck,"visiteuse",randi())
	if error != "": $Conversation/Terms.text = error; return
	phase = "combat"
	resolved = false
	$Conversation.visible = false
	$Arena.visible = true
	combat_ui()

func combat_ui() -> void:
	for child in $HUD.get_children():
		$HUD.remove_child(child)
		child.queue_free()
	var hud = Hud.instantiate()
	$HUD.add_child(hud)
	hud.setup(self)

func save_progress() -> bool:
	host.muted = muted
	host.reduced_motion = reduced_motion
	return host.save_progress()

func play_card(index: int) -> void:
	if busy or phase != "combat" or index < 0 or index >= battle.hand.size(): return
	var before = battle.enemy_hp
	if not battle.play(index): return
	busy = true
	combat_ui()
	await pulse($Arena/Visitor if battle.enemy_hp < before else $Arena/Recruit)
	busy = false
	if battle.outcome != "": finish_duel()
	else: combat_ui()

func end_turn() -> void:
	if busy or phase != "combat": return
	busy = true
	var intent = battle.intent()
	battle.end_turn()
	combat_ui()
	await pulse($Arena/Recruit if intent.damage > 0 else $Arena/Visitor)
	busy = false
	if battle.outcome != "": finish_duel()
	else: combat_ui()

func pulse(portrait: TextureRect) -> void:
	host.tone(330)
	if reduced_motion: return
	var tween = create_tween()
	tween.tween_property(portrait,"modulate",Color(0.72,0.55,0.85),0.09)
	tween.tween_property(portrait,"modulate",Color.WHITE,0.14)
	await tween.finished

func finish_duel() -> void:
	if resolved or battle.outcome == "": return
	var won = battle.outcome == "victory"
	if not record_flag("visitor_won" if won else "visitor_defeated"):
		phase = "save_error"
		show_words("Sauvegarde impossible", tr("text.de72c256f244"), "Réessayer la sauvegarde")
		return
	resolved = true
	phase = "result"
	if won:
		show_words("Son sourire a changé", tr("text.5e6e71305996"), "Nous en reparlerons")
	else:
		show_words("Un fil d’avance", tr("text.f6e3495fb062"), "Préparer la revanche")

func leave_combat() -> void:
	if busy: return
	host.notice = tr("text.463e8c533924") if phase == "combat" else ""
	host.hub()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		leave_combat()
