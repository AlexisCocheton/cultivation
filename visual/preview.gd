extends Node2D

const DialogueBook = preload("res://game/presentation/dialogue_book.gd")
const CombatPresenter = preload("res://visual/combat/presenter.gd")
var combat_presenter = CombatPresenter.new(self)
const Tone = preload("res://game/presentation/tone.gd")

const Calendar = preload("res://game/calendar.gd")
const Battle = preload("res://game/battle.gd")
const Cards = preload("res://game/cards.gd")
const Avatar = preload("res://scripts/avatar.gd")
const Card = preload("res://visual/card.gd")
const Progress = preload("res://game/campaign/progress.gd")
const HUB_POSITIONS = [Vector2(420,650),Vector2(350,540),Vector2(1040,520),Vector2(885,330)]
const HUB_SCALES = [1.65,1.65,1.65,1.25]
const PORTRAITS = preload("res://assets/portraits_manhua.png")
const CampaignSession = preload("res://game/campaign/session.gd")
var session = CampaignSession.new()
var calendar:
	get: return session.calendar
	set(value): session.calendar = value
var battle = Battle.new()
var stage: int:
	get: return session.stage
	set(value): session.stage = value
var mode = "hub"
var busy = false
var muted: bool:
	get: return session.muted
	set(value): session.muted = value
var reduced_motion: bool:
	get: return session.reduced_motion
	set(value): session.reduced_motion = value
var actors: Array = []
var player: Node2D
var target = Vector2(640,650)
var ui: Control
var scenery: ShaderMaterial
var petals: Node2D
var clock_time = 0.0
var sound: AudioStreamPlayer
var selected = -1
var notice = ""
var deck_tab = "deck"
var deck_detail: Node
var inspected_card = ""
var persistence = true
var save_path = Progress.PATH
var free_duel = false
var completed_duels: int:
	get: return session.completed_duels
	set(value): session.completed_duels = value
var activity_sprites: Array = []
var garden_scene: Node2D
var pavilion_scene: Node2D
var location = "courtyard"

func _ready() -> void:
	DisplayServer.window_set_title(tr("text.5fed42997869"))
	if OS.get_cmdline_user_args().has("--test-route"):
		DisplayServer.window_set_title(tr("text.a1f42517f54c"))
	if OS.get_cmdline_user_args().has("--story-route"):
		call_deferred("open_story_route")
	calendar.slot = 3
	calendar.seen = ["M01"]
	persistence = not OS.get_cmdline_args().has("--script")
	if persistence:
		var loaded = load_progress()
		if not loaded and OS.get_cmdline_user_args().has("--story-route"):
			calendar.slot = 13
			calendar.seen = ["M01","M02"]
			calendar.ranks = {"J":2,"L":2,"H":2}
			calendar.collection.append_array(["J01","L01","H01","E01"])
			calendar.deck[0] = "L01"
			calendar.deck[2] = "J01"
			calendar.deck[4] = "H01"
			stage = CampaignSession.Stage.TRAINING_COMPLETE
			completed_duels = 1
			save_progress()
	var background = Sprite2D.new()
	background.texture = preload("res://assets/hub/courtyard.png")
	background.centered = false
	background.scale = Vector2(1280.0/background.texture.get_width(),832.0/background.texture.get_height())
	scenery = ShaderMaterial.new()
	scenery.shader = preload("res://shaders/hub_courtyard.gdshader")
	scenery.set_shader_parameter("restored",preload("res://assets/hub/restored.png"))
	background.material = scenery
	add_child(background)
	for i in range(4):
		var actor = Avatar.new()
		actor.character_row = i
		actor.position = HUB_POSITIONS[i]
		actor.scale = Vector2.ONE * HUB_SCALES[i]
		actor.direction = Avatar.Direction.FRONT
		add_child(actor)
		actors.append(actor)
	player = actors[0]
	target = player.position
	setup_activity_sprites()
	garden_scene = preload("res://visual/garden/scene.tscn").instantiate()
	garden_scene.game = self
	garden_scene.visible = false
	add_child(garden_scene)
	pavilion_scene = preload("res://visual/pavilion/scene.tscn").instantiate()
	pavilion_scene.game = self
	pavilion_scene.visible = false
	add_child(pavilion_scene)
	petals = Node2D.new()
	petals.set_script(preload("res://scripts/petals.gd"))
	add_child(petals)
	var layer = CanvasLayer.new()
	add_child(layer)
	ui = Control.new()
	ui.theme = preload("res://visual/deck/theme.tres")
	ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.add_child(ui)
	sound = AudioStreamPlayer.new()
	sound.volume_db = -24
	add_child(sound)
	hub()
	if OS.get_cmdline_user_args().has("--deck"): deck_ui()
	if OS.get_cmdline_user_args().has("--garden"): garden_ui()
	if OS.get_cmdline_user_args().has("--pavilion"): pavilion_ui()
	if OS.get_cmdline_user_args().has("--activities"): activities_ui()

func clear_ui() -> void:
	for child in ui.get_children():
		ui.remove_child(child)
		child.queue_free()

func panel(pos: Vector2, extent: Vector2, color = Color("102630")) -> Panel:
	var p = Panel.new()
	p.position = pos
	p.size = extent
	p.add_theme_stylebox_override("panel",ui.theme.get_stylebox("panel","Panel"))
	ui.add_child(p)
	return p

func label(text: String, pos: Vector2, extent: Vector2, font_size = 20, color = Color("29252a")) -> Label:
	var l = Label.new()
	l.text = text
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.position = pos
	l.size = extent
	l.add_theme_font_size_override("font_size",font_size)
	l.add_theme_color_override("font_color",color)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(l)
	return l

func button(text: String, pos: Vector2, extent: Vector2, callback: Callable, enabled = true) -> Button:
	var b = Button.new()
	b.text = text
	b.position = pos
	b.size = extent
	b.disabled = not enabled
	b.add_theme_font_size_override("font_size",18)
	b.pressed.connect(callback)
	ui.add_child(b)
	return b

func header(subtitle: String) -> void:
	panel(Vector2(20,18),Vector2(1240,88))
	label("LES CENDRES DU PRUNIER",Vector2(40,26),Vector2(660,40),27).theme_type_variation = &"Title"
	label(subtitle,Vector2(40,66),Vector2(820,32),17,Color("554a40"))
	button("Son : " + ("non" if muted else "oui"),Vector2(1000,32),Vector2(115,44),func(): muted = not muted; refresh())
	button("Effets : " + ("doux" if reduced_motion else "oui"),Vector2(1124,32),Vector2(120,44),func(): reduced_motion = not reduced_motion; refresh())

func refresh() -> void:
	save_progress()
	for child in ui.get_children():
		if child is Button and child.text.begins_with("Son :"):
			child.text = "Son : " + ("non" if muted else "oui")
		if child is Button and child.text.begins_with("Effets :"):
			child.text = "Effets : " + ("doux" if reduced_motion else "oui")

func hub() -> void:
	if not calendar.story.battle_report.is_empty():
		if not calendar.story.return_seen:
			story_ui("return")
			return
		if calendar.story.candidates == "":
			story_ui("candidates")
			return
	location = "courtyard"
	garden_scene.visible = false
	pavilion_scene.visible = false
	mode = "hub"
	clear_ui()
	update_restoration()
	var hud = preload("res://visual/hub/hud.tscn").instantiate()
	ui.add_child(hud)
	hud.setup(self)
	update_hub_actors()
	spy_arrival_ui()

func spy_arrival_ui() -> void:
	if busy or stage < CampaignSession.Stage.TRAINING_COMPLETE or not preload("res://visual/spy/story.gd").pending(calendar): return
	mode = "spy_arrival"
	player.walking = false
	clear_ui()
	var screen = preload("res://visual/spy/arrival.tscn").instantiate()
	ui.add_child(screen)
	screen.setup(self)

func garden_ui() -> void:
	pavilion_scene.visible = false
	location = "garden"
	mode = "garden"
	player.walking = false
	garden_scene.visible = true
	garden_scene.present("sword_care","smile")
	clear_ui()
	var screen = preload("res://visual/garden/ui.tscn").instantiate()
	ui.add_child(screen)
	screen.setup(self)
	update_hub_actors()

func pavilion_ui() -> void:
	location = "pavilion"
	mode = "pavilion"
	player.walking = false
	garden_scene.visible = false
	pavilion_scene.visible = true
	pavilion_scene.present("neutral")
	clear_ui()
	var screen = preload("res://visual/pavilion/ui.tscn").instantiate()
	ui.add_child(screen)
	screen.setup(self)
	update_hub_actors()

func study_with_shen() -> void:
	resident_activity("H")

func resident_activity(action: String, choice: String = "") -> void:
	if busy or stage == CampaignSession.Stage.INTRODUCTION or calendar.slot >= Progress.END_SLOT: return
	if action not in ["H","J","L"]: return
	if calendar.reason(action) != "": notice = calendar.reason(action); return
	if calendar.ranks[action] == 2 and choice == "":
		story_ui("recruit:" + action)
		return
	var old_story = calendar.story.duplicate(true)
	if choice != "": calendar.story.recruit_choices[action] = choice
	var before = calendar.collection.duplicate()
	# Apply and save exactly once, before the purely visual sequence.
	if do_activity(action) != "":
		calendar.story = old_story
		return
	var gained: Array = []
	for id in calendar.collection:
		if not before.has(id): gained.append(id)
	if action == "H": pavilion_ui()
	elif action == "L": garden_ui()
	else: hub()
	busy = true
	mode = "study" if action == "H" else "resident_activity"
	clear_ui()
	var overlay = preload("res://visual/study/overlay.tscn").instantiate()
	ui.add_child(overlay)
	overlay.setup(self,gained,action)

func return_to_location() -> void:
	if location == "garden": garden_ui()
	elif location == "pavilion": pavilion_ui()
	else: hub()

func menu_ui() -> void:
	mode = "menu"
	player.walking = false
	clear_ui()
	var menu = preload("res://visual/hub/menu.tscn").instantiate()
	ui.add_child(menu)
	menu.setup(self)

func nearest_resident() -> int:
	var nearest = -1
	var distance = 155.0
	for i in [2]:
		var candidate = player.position.distance_to(actors[i].position)
		if candidate < distance:
			distance = candidate
			nearest = i
	return nearest

func setup_activity_sprites() -> void:
	var sheet = preload("res://assets/hub/activities.png")
	for i in range(2):
		var sprite = Sprite2D.new()
		var atlas = AtlasTexture.new()
		atlas.atlas = sheet
		var cell = sheet.get_size() / Vector2(2,1)
		atlas.region = Rect2(Vector2(i*cell.x,0),cell)
		sprite.texture = atlas
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
		sprite.scale = Vector2.ONE * (165.0 if i == 0 else 125.0) / cell.y
		sprite.offset = Vector2(0,-cell.y/2+cell.y*0.055)
		add_child(sprite)
		activity_sprites.append(sprite)
		var shadow = Sprite2D.new()
		shadow.texture = preload("res://assets/hub/contact-shadow.svg")
		shadow.scale = Vector2.ONE * 1.8
		shadow.position = Vector2(0,30)
		shadow.z_index = -1
		sprite.add_child(shadow)

func update_hub_actors() -> void:
	for i in range(4): actors[i].z_index = int(actors[i].position.y)
	actors[0].visible = mode != "dialogue" and location == "courtyard"
	actors[2].visible = mode != "dialogue" and location == "courtyard"
	for i in range(2):
		var resident = actors[1 if i == 0 else 3]
		activity_sprites[i].position = resident.position
		activity_sprites[i].z_index = int(resident.position.y)
		activity_sprites[i].visible = false
		resident.visible = false
	if mode == "hub":
		var phase = fmod(clock_time,5.0)
		actors[2].facing = 1
		actors[2].direction = Avatar.Direction.SIDE
		actors[2].combat_ready = true
		actors[2].action = "attack" if phase < 0.8 and not reduced_motion else ""
		actors[2].action_frame = mini(3,int(phase/0.2))

func walkable_position(point: Vector2) -> Vector2:
	var result = point.clamp(Vector2(190,430),Vector2(1140,737))
	# Keep the recruit in front of the reading ledge and clear of the stone table.
	if result.x < 340 and result.y < 585: result.y = 585
	return result

func _process(delta: float) -> void:
	clock_time += delta
	scenery.set_shader_parameter("wind_time",0.0 if reduced_motion else clock_time)
	petals.visible = not reduced_motion and location == "courtyard"
	update_hub_actors()
	if mode != "hub": return
	var motion = Input.get_vector("move_left","move_right","move_up","move_down")
	if motion != Vector2.ZERO:
		target = walkable_position(player.position + motion.normalized()*200)
	var direction = target-player.position
	player.walking = direction.length() > 3
	if player.walking:
		player.face_motion(direction)
		player.position = walkable_position(player.position.move_toward(target,190*delta))
		if player.position.x in [190.0,1140.0] or player.position.y in [430.0,737.0]: target = player.position

func _unhandled_input(event: InputEvent) -> void:
	if mode != "hub": return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		target = walkable_position(get_global_mouse_position())
	if event.is_action_pressed("interact") and not event.is_echo():
		var nearest = nearest_resident()
		if nearest > 0: talk(nearest)
	if event.is_action_pressed("ui_cancel"): menu_ui()
	elif event.is_action_pressed("open_deck"): deck_ui()

func portrait(index: int, happy: bool, pos: Vector2, extent: Vector2) -> void:
	var texture = AtlasTexture.new()
	texture.atlas = PORTRAITS
	var cell = PORTRAITS.get_size()/Vector2(3,2)
	texture.region = Rect2(Vector2(index-1,int(happy))*cell,cell)
	var view = TextureRect.new()
	view.texture = texture
	view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	view.position = pos
	view.size = extent
	view.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(view)

func dialogue(index: int, happy: bool, words: String, choice: String, action: Callable, presentation: Dictionary = {}) -> void:
	mode = "dialogue"
	player.walking = false
	actors[2].action = ""
	clear_ui()
	var view = preload("res://visual/hub/dialogue.tscn").instantiate()
	ui.add_child(view)
	view.setup(self,index,happy,words,choice,action)
	if index == 1 and location == "garden":
		garden_scene.present(presentation.get("pose","sword_care"),presentation.get("expression","smile" if happy else "neutral"))

func talk(index: int) -> void:
	if index == 1:
		lian_dialogue_line(0,stage == CampaignSession.Stage.INTRODUCTION)
	elif index == 2:
		dialogue(2,stage >= CampaignSession.Stage.DECK_PREPARED,tr("text.8c750bf6eee7") if stage >= CampaignSession.Stage.DECK_PREPARED else tr("text.037d8fad7c6c"),"Duel d'entraînement" if stage >= CampaignSession.Stage.DECK_PREPARED else tr("text.59dc273bc091"),start_combat if stage >= CampaignSession.Stage.DECK_PREPARED else hub)
	else:
		shen_dialogue_line(0)

func shen_dialogue_line(line: int) -> void:
	var lines = DialogueBook.lines("shen")
	var next: Callable = return_to_location if line == 2 else func(): shen_dialogue_line(line+1)
	dialogue(3,lines[line][1] == "kind",lines[line][0],"Je m'en souviendrai." if line == 2 else "Continuer",next)
	if location == "pavilion": pavilion_scene.present(lines[line][1])

func lian_dialogue_line(line: int, introduction: bool) -> void:
	var lines = DialogueBook.lines("lian_intro" if introduction else "lian_advice")
	var row: Array = lines[line]
	var next: Callable = func(): lian_dialogue_line(line+1,introduction)
	if line == lines.size()-1: next = learn if introduction else deck_ui
	dialogue(1,row[2] in ["smile","amused"],row[0],row[3],next,{"pose":row[1],"expression":row[2]})

func learn() -> void:
	if stage != CampaignSession.Stage.INTRODUCTION: return
	var before = calendar.snapshot()
	var error = calendar.act("L")
	if error != "": notice = error; hub(); return
	stage = CampaignSession.Stage.TECHNIQUE_LEARNED
	if not save_progress():
		calendar.restore(before)
		stage = CampaignSession.Stage.INTRODUCTION
		hub()
		return
	mode = "reward"
	clear_ui()
	var reward = preload("res://visual/combat/reward.tscn").instantiate()
	ui.add_child(reward)
	reward.setup(self)
	tone(660)

func deck_ui() -> void:
	mode = "deck"
	player.walking = false
	clear_ui()
	var menu = preload("res://visual/deck/menu.tscn").instantiate()
	ui.add_child(menu)
	menu.setup(self)
	deck_detail = menu.get_node("Detail")

func show_deck_detail(id: String) -> void:
	if is_instance_valid(deck_detail): deck_detail.get_parent().inspect(id)

func replace_card(id: String) -> void:
	var before = calendar.snapshot()
	var previous_stage = stage
	if selected < 0 or selected >= calendar.deck.size(): return
	var plan = calendar.replacement_plan(selected,id)
	notice = plan.error
	if notice == "": notice = calendar.configure(plan.deck,plan.loadout)
	if notice == "":
		notice = tr("text.34e3ed4ae613")
		selected = -1
		if stage == CampaignSession.Stage.TECHNIQUE_LEARNED and calendar.deck.has("L01"): stage = CampaignSession.Stage.DECK_PREPARED
		if not save_progress():
			calendar.restore(before)
			stage = previous_stage
	deck_ui()

func visitor_ui() -> void:
	if busy or stage < CampaignSession.Stage.TRAINING_COMPLETE: return
	mode = "visitor"
	player.walking = false
	clear_ui()
	var screen = preload("res://visual/visitor/encounter.tscn").instantiate()
	ui.add_child(screen)
	screen.setup(self)

func merchant_ui() -> void:
	if busy or stage == CampaignSession.Stage.INTRODUCTION or calendar.slot >= Progress.END_SLOT or calendar.day() != 4:
		notice = tr("text.ae4f5a37407a")
		hub()
		return
	mode = "merchant"
	player.walking = false
	clear_ui()
	var screen = preload("res://visual/merchant/menu.tscn").instantiate()
	ui.add_child(screen)
	screen.setup(self)

func start_combat() -> void:
	pavilion_scene.visible = false
	location = "courtyard"
	garden_scene.visible = false
	if stage < CampaignSession.Stage.DECK_PREPARED: return
	free_duel = stage >= CampaignSession.Stage.TRAINING_COMPLETE or calendar.slot >= Progress.END_SLOT
	if not free_duel:
		var unavailable = calendar.reason("fight")
		if unavailable != "": notice = unavailable; hub(); return
	if not save_progress(): hub(); return
	var error = calendar.validate_deck(calendar.deck,calendar.loadout)
	battle.relation_ranks = calendar.ranks.duplicate()
	if error == "": error = battle.start(calendar.deck,"partenaire",randi(),0,false,completed_duels)
	if error != "": notice = error; hub(); return
	mode = "combat"
	actors[2].action = ""
	player.combat_ready = true
	actors[2].combat_ready = true
	player.position = Vector2(310,482)
	player.scale = Vector2.ONE*2.1
	player.direction = Avatar.Direction.SIDE
	player.facing = 1
	player.walking = false
	actors[2].position = Vector2(965,482)
	actors[2].scale = Vector2.ONE*2.1
	actors[2].direction = Avatar.Direction.SIDE
	actors[2].facing = -1
	actors[1].visible = false
	actors[3].visible = false
	combat_ui()

func combat_ui() -> void:
	clear_ui()
	var hud = preload("res://visual/combat/hud.tscn").instantiate()
	ui.add_child(hud)
	hud.setup(self)

func play_card(index: int) -> void:
	await combat_presenter.play_card(index)

func end_turn() -> void:
	await combat_presenter.end_turn()

func attack_motion(attacker: Node2D, defender: Node2D, contact: Callable) -> void:
	await combat_presenter.attack_motion(attacker,defender,contact)

func impact(actor: Node2D, damage: int, message: String = "GARDE") -> void:
	await combat_presenter.impact(actor,damage,message)

func finish_combat() -> void:
	if mode != "combat" or battle.outcome == "": return
	var before = calendar.snapshot()
	var previous_stage = stage
	var previous_duels = completed_duels
	var first_duel = not free_duel
	if first_duel:
		var error = calendar.act("fight",battle.outcome == "victory")
		if error != "":
			notice = error
			combat_ui()
			return
	stage = CampaignSession.Stage.TRAINING_COMPLETE
	completed_duels += 1
	if not save_progress():
		calendar.restore(before)
		stage = previous_stage
		completed_duels = previous_duels
		notice = tr("text.4a5b8c430634")
		combat_ui()
		return
	restore_actors()
	var words = tr("text.08bb0f1d8567") if battle.outcome == "victory" else tr("text.106ee77f863f")
	if first_duel:
		words += tr("text.e51072be8b73") + (tr("text.fefdcbe727a2") if battle.outcome == "victory" else tr("text.c33eb2cbe75d"))
	else: words += tr("text.d9720195a7ae")
	words += tr("text.b1290abcd7bf")
	words += tr("text.da1823780de7") if completed_duels <= 4 else tr("text.ce43e55753b9")
	mode = "dialogue"
	clear_ui()
	var result = preload("res://visual/combat/result.tscn").instantiate()
	ui.add_child(result)
	result.setup(self,words)

func health_bar(pos: Vector2, extent: Vector2, current: int, maximum: int, color: Color) -> void:
	var background = ColorRect.new()
	background.color = Color("344b50")
	background.position = pos
	background.size = extent
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(background)
	var fill = ColorRect.new()
	fill.color = color
	fill.size = Vector2(extent.x*float(current)/maximum,extent.y)
	fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.add_child(fill)

func restore_actors() -> void:
	for i in range(4):
		actors[i].clear_combat_pose()
		actors[i].position = HUB_POSITIONS[i]
		actors[i].scale = Vector2.ONE * HUB_SCALES[i]
		actors[i].visible = true
		actors[i].direction = Avatar.Direction.FRONT
	target = player.position

func leave_combat() -> void:
	restore_actors()
	notice = tr("text.b764d1577270")
	hub()

func restart() -> void:
	calendar = Calendar.new()
	calendar.slot = 3
	calendar.seen = ["M01"]
	stage = CampaignSession.Stage.INTRODUCTION
	completed_duels = 0
	selected = -1
	notice = ""
	restore_actors()
	save_progress()
	hub()

func load_progress() -> bool:
	if not session.load_from(save_path): return false
	notice = tr("text.56a101154a26")
	return true

func save_progress() -> bool:
	if not persistence: return true
	var saved = session.save_to(save_path)
	if not saved: notice = tr("text.34e48c8b0d0f")
	return saved

func update_restoration() -> void:
	var level: int = calendar.buildings.hall
	scenery.set_shader_parameter("restoration",Vector3(float(level >= 1),float(level >= 2),float(level >= 2)))

func confirm_restart() -> void:
	dialogue(3,false,tr("text.dd46913d5453"),tr("text.f601866c5cfa"),restart)

func activities_ui(show_summary: bool = false, skip_story: bool = false) -> void:
	if not show_summary and not skip_story:
		if calendar.day() == 6 and not calendar.story.warned:
			story_ui("prepare")
			return
		if (calendar.invitation_available("J") and calendar.reason("J") == "") or (calendar.invitation_available("L") and calendar.reason("L") == ""):
			story_ui("invite")
			return
	if calendar.slot == 18 and not show_summary:
		territory_ui()
		return
	mode = "activities"
	player.walking = false
	clear_ui()
	var screen = preload("res://visual/activities/menu.tscn").instantiate()
	ui.add_child(screen)
	screen.setup(self,show_summary)

func do_activity(action: String, choice = "E01") -> String:
	if busy or mode in ["combat","team_combat"] or calendar.slot >= Progress.END_SLOT: return "Activité indisponible."
	if action == "M03":
		territory_ui()
		return tr("text.5adbcf51df9f")
	var transaction = calendar.snapshot()
	var previous_stage = stage
	var before = calendar.supplies
	var owned = calendar.collection.duplicate()
	var error = calendar.act(action,true,choice)
	if error != "": notice = error; activities_ui(); return error
	var gained: Array[String] = []
	for id in calendar.collection:
		if not owned.has(id): gained.append(Cards.catalog()[id].name)
	notice = tr("text.b2bd430dac97") % [calendar.supplies-before]
	if not gained.is_empty(): notice += " Acquis : " + ", ".join(gained) + tr("text.7365eab6555f")
	if action == "hall": notice += tr("text.c9b2dd6376d3") % calendar.buildings.hall
	if stage == CampaignSession.Stage.INTRODUCTION and calendar.collection.has("L01"): stage = CampaignSession.Stage.TECHNIQUE_LEARNED
	if not save_progress():
		calendar.restore(transaction)
		stage = previous_stage
		return tr("text.0293c1414ef0")
	update_restoration()
	if calendar.slot >= Progress.END_SLOT or calendar.slot % 3 == 0: activities_ui(true)
	else: hub()
	return ""

func tone(frequency: float) -> void:
	if not muted: Tone.play(sound,frequency)

func territory_ui() -> void:
	if busy or calendar.slot != 18: return
	mode = "territory"
	player.walking = false
	clear_ui()
	var screen = preload("res://visual/team/encounter.tscn").instantiate()
	ui.add_child(screen)
	screen.setup(self)

func start_territory() -> bool:
	if busy or mode != "territory" or calendar.slot != 18: return false
	var error = calendar.validate_deck(calendar.deck,calendar.loadout)
	if error == "": error = calendar.party_reason(calendar.party,true)
	if error != "": notice = error; return false
	# Save the preparation state before entering. Interrupted fights resume here.
	if not save_progress(): return false
	mode = "team_combat"
	clear_ui()
	var screen = preload("res://visual/team/lab.tscn").instantiate()
	screen.host = self
	ui.add_child(screen)
	return true

func finish_territory() -> bool:
	if mode != "team_combat" or calendar.slot != 18: return false
	var screen = ui.get_child(0)
	if screen.battle.outcome != "victory" or screen.busy: return false
	var before = calendar.snapshot()
	calendar.story.battle_report = screen.battle.report()
	calendar.story.antidote = screen.battle.antidotes
	if calendar.act("M03",true) != "":
		calendar.restore(before)
		return false
	if not save_progress():
		calendar.restore(before)
		return false
	notice = tr("text.0a24de33f1c6") % calendar.Balance.EVENT_RESERVES
	hub()
	return true

func story_ui(page: String) -> void:
	mode = "story"
	player.walking = false
	clear_ui()
	var screen = preload("res://visual/story/panel.tscn").instantiate()
	ui.add_child(screen)
	screen.setup(self,page)

func story_ack(field: String, value) -> void:
	var previous = calendar.snapshot()
	calendar.story[field] = value
	if not save_progress():
		calendar.restore(previous)
		ui.get_child(0).get_node("Error").text = tr("text.efa0e1282eb9")
		return
	if field == "warned": activities_ui(false,true)
	else: hub()

func companions_ui(id: String = "J") -> void:
	var screen = preload("res://visual/team/companions.tscn").instantiate()
	ui.add_child(screen)
	screen.setup(self,id)

func open_story_route() -> void:
	get_window().title = tr("text.ae9c3a206073")
	if calendar.story.battle_report.is_empty(): activities_ui()
