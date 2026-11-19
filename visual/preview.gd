extends Node2D

const Calendar = preload("res://prototypes/calendar.gd")
const Battle = preload("res://prototypes/battle.gd")
const Cards = preload("res://prototypes/cards.gd")
const Avatar = preload("res://scripts/avatar.gd")
const Card = preload("res://visual/card.gd")
const Progress = preload("res://visual/progress.gd")
const HUB_POSITIONS = [Vector2(420,650),Vector2(350,540),Vector2(1040,520),Vector2(885,330)]
const HUB_SCALES = [1.65,1.65,1.65,1.25]
const PORTRAITS = preload("res://assets/portraits_manhua.png")
var calendar = Calendar.new()
var battle = Battle.new()
var stage = 0
var mode = "hub"
var busy = false
var muted = false
var reduced_motion = false
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
var completed_duels = 0
var activity_sprites: Array = []
var garden_scene: Node2D
var pavilion_scene: Node2D
var location = "courtyard"

func _ready() -> void:
	DisplayServer.window_set_title("Les Cendres du Prunier — Séquence visuelle")
	if OS.get_cmdline_user_args().has("--test-route"):
		DisplayServer.window_set_title("Les Cendres du Prunier — Parcours de test")
	calendar.slot = 3
	calendar.seen = ["M01"]
	persistence = not OS.get_cmdline_args().has("--script")
	if persistence:
		load_progress()
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

func resident_activity(action: String) -> void:
	if busy or stage == 0 or calendar.slot >= Progress.END_SLOT: return
	if action not in ["H","J","L"]: return
	var before = calendar.collection.duplicate()
	# Apply and save exactly once, before the purely visual sequence.
	if do_activity(action) != "": return
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
	var motion = Vector2(float(Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT))-float(Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_Q) or Input.is_physical_key_pressed(KEY_LEFT)),float(Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN))-float(Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_Z) or Input.is_physical_key_pressed(KEY_UP)))
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
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		var nearest = nearest_resident()
		if nearest > 0: talk(nearest)
	if event.is_action_pressed("ui_cancel"): menu_ui()

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
		lian_dialogue_line(0,stage == 0)
	elif index == 2:
		dialogue(2,stage >= 2,"Lian t'a montré un mouvement ? Bien. Voyons s'il tient quand quelqu'un te répond.\n\nObserve mon intention avant de jouer. La garde disparaît après mon attaque." if stage >= 2 else "Tu tiens ton sabre comme un balai. Va donc voir Lian, et prépare une vraie technique avant de venir me défier.","Duel d'entraînement" if stage >= 2 else "Revenir après l'entraînement",start_combat if stage >= 2 else hub)
	else:
		shen_dialogue_line(0)

func shen_dialogue_line(line: int) -> void:
	var lines = [
		["Une secte ne se relève pas en un jour.","serious"],
		["Le temps passé avec un disciple compte autant qu'une poutre replacée.","kind"],
		["Aujourd'hui, apprends une technique. Ensuite, trouve-lui une place parmi les douze que tu emportes.","neutral"]
	]
	var next: Callable = return_to_location if line == 2 else func(): shen_dialogue_line(line+1)
	dialogue(3,lines[line][1] == "kind",lines[line][0],"Je m'en souviendrai." if line == 2 else "Continuer",next)
	if location == "pavilion": pavilion_scene.present(lines[line][1])

func lian_dialogue_line(line: int, introduction: bool) -> void:
	var lines = [
		["Le toit fuit. Les dalles se fendent. Mais regarde cette branche : elle fleurit encore.","listening","thoughtful","Continuer"],
		["Tu crois qu'il reste quelque chose à sauver ici ?","listening","neutral","« Si vous êtes encore là, alors oui. »"],
		["Alors commence par tenir ton sabre sans crisper les épaules.","listening","amused","Continuer"],
		["Deux gestes pour ouvrir le chemin, puis le troisième comme un pétale emporté par le vent.","explaining","smile","S'entraîner avec Lian · 1 période"]
	] if introduction else [
		["N'essaie pas de frapper plus fort que Jun.","listening","thoughtful","Continuer"],
		["Fais-le attendre, puis surprends-le.","listening","amused","Continuer"],
		["Pétales tranchants gagne en puissance après deux cartes jouées dans le même tour.","explaining","smile","Préparer mes techniques"]
	]
	var row: Array = lines[line]
	var next: Callable = func(): lian_dialogue_line(line+1,introduction)
	if line == lines.size()-1: next = learn if introduction else deck_ui
	dialogue(1,row[2] in ["smile","amused"],row[0],row[3],next,{"pose":row[1],"expression":row[2]})

func learn() -> void:
	if stage != 0: return
	var error = calendar.act("L")
	if error != "": notice = error; hub(); return
	stage = 1
	save_progress()
	mode = "reward"
	clear_ui()
	header("Lien avec Lian · rang 1 atteint   /   Le matin laisse place à l'après-midi")
	panel(Vector2(300,176),Vector2(680,544))
	label("UNE TECHNIQUE TRANSMISE",Vector2(350,201),Vector2(580,40),29)
	var card = Card.new()
	card.card_id = "L01"
	card.position = Vector2(550,270)
	ui.add_child(card)
	label("Pétales tranchants rejoint ta collection.\nIl faut l'équiper pour la piocher en combat.",Vector2(365,548),Vector2(550,66),21)
	button("Composer mon deck",Vector2(390,637),Vector2(500,50),deck_ui)
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
	if selected < 0 or selected >= calendar.deck.size(): return
	var plan = calendar.replacement_plan(selected,id)
	notice = plan.error
	if notice == "": notice = calendar.configure(plan.deck,plan.loadout)
	if notice == "":
		notice = "Deck enregistré pour cette séquence."
		selected = -1
		if stage == 1 and calendar.deck.has("L01"): stage = 2
		save_progress()
	deck_ui()

func merchant_ui() -> void:
	if busy or stage == 0 or calendar.slot >= Progress.END_SLOT or calendar.day() != 4:
		notice = "Le marchand est présent au jour 4."
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
	if stage < 2: return
	free_duel = stage >= 3 or calendar.slot >= Progress.END_SLOT
	if not free_duel:
		var unavailable = calendar.reason("fight")
		if unavailable != "": notice = unavailable; hub(); return
	save_progress()
	var error = calendar.validate_deck(calendar.deck,calendar.loadout)
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
	if busy or mode != "combat": return
	if index < 0 or index >= battle.hand.size(): return
	var id: String = battle.hand[index]
	var card: Dictionary = battle.cards[id]
	if card.cost > battle.energy: return
	var old_hp = battle.enemy_hp
	busy = true
	combat_ui()
	var strike = battle.damage_for(id) > 0
	var contact = func():
		battle.play(index)
		combat_ui()
		if strike:
			impact(actors[2],old_hp-battle.enemy_hp,"BLOQUÉ")
		else:
			impact(player,0,"+%d GARDE" % card.block if card.block > 0 else "SOUFFLE")
	if strike:
		await attack_motion(player,actors[2],contact)
	else:
		await player.perform_action("guard",contact,reduced_motion)
	if strike and card.block > 0:
		await player.perform_action("guard",Callable(),reduced_motion)
	player.guarding = battle.block > 0
	actors[2].guarding = battle.enemy_block > 0
	player._process(0)
	actors[2]._process(0)
	busy = false
	if battle.outcome != "": finish_combat()
	else: combat_ui()

func end_turn() -> void:
	if busy or mode != "combat": return
	busy = true
	var old_hp = battle.hp
	var intent = battle.intent()
	combat_ui()
	var contact = func():
		battle.end_turn()
		combat_ui()
		if intent.damage > 0: impact(player,old_hp-battle.hp,"PARADE")
		else: impact(actors[2],0,"+%d GARDE" % intent.block)
	if intent.damage > 0:
		await attack_motion(actors[2],player,contact)
	else:
		await actors[2].perform_action("guard",contact,reduced_motion)
	if intent.damage > 0 and intent.block > 0:
		await actors[2].perform_action("guard",Callable(),reduced_motion)
	player.guarding = battle.block > 0
	actors[2].guarding = battle.enemy_block > 0
	player._process(0)
	actors[2]._process(0)
	busy = false
	if battle.outcome != "": finish_combat()
	else: combat_ui()

func attack_motion(attacker: Node2D, defender: Node2D, contact: Callable) -> void:
	var origin = attacker.position
	if not reduced_motion:
		var approach = create_tween()
		approach.tween_property(attacker,"position:x",defender.position.x-attacker.facing*115,0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		await approach.finished
	await attacker.perform_action("attack",contact,reduced_motion)
	if not reduced_motion:
		var retreat = create_tween()
		retreat.tween_property(attacker,"position",origin,0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await retreat.finished

func impact(actor: Node2D, damage: int, message: String = "GARDE") -> void:
	tone(180 if damage > 0 else 440)
	var floating = label("−%d" % damage if damage > 0 else message,actor.position+Vector2(-100,-210),Vector2(260,50),28,Color("ffbbb5") if damage > 0 else Color("abe7d4"))
	var tween = create_tween()
	if not reduced_motion:
		var stroke = Line2D.new()
		if damage > 0:
			stroke.points = PackedVector2Array([Vector2(-60,0),Vector2(50,-140),Vector2(-20,-50)])
		else:
			for i in range(19):
				var angle = -PI/2 + i*PI/18
				stroke.add_point(Vector2(cos(angle)*60*actor.facing,sin(angle)*85-85))
		stroke.width = 7
		stroke.default_color = Color("ffe6c7") if damage > 0 else Color("9ae3d7")
		stroke.position = actor.position
		add_child(stroke)
		tween.parallel().tween_property(stroke,"modulate:a",0.0,0.24)
		tween.parallel().tween_property(floating,"position:y",floating.position.y-35,0.24)
		if damage > 0:
			actor.sprite.modulate = Color("ffadad")
			tween.parallel().tween_property(actor.sprite,"modulate",Color.WHITE,0.2)
		tween.tween_callback(stroke.queue_free)
	else: tween.tween_interval(0.12)
	await tween.finished
	if is_instance_valid(floating): floating.queue_free()

func finish_combat() -> void:
	if mode != "combat" or battle.outcome == "": return
	var first_duel = not free_duel
	if first_duel:
		var error = calendar.act("fight",battle.outcome == "victory")
		if error != "": notice = error
	stage = 3
	completed_duels += 1
	save_progress()
	restore_actors()
	var words = "Pas mal. Cette fois, tu as vraiment écouté ton adversaire." if battle.outcome == "victory" else "Tu annonçais chaque mouvement avec tes épaules. Ça se travaille."
	if first_duel:
		words += "\n\nUne période s'est écoulée." + (" La secte a gagné une réserve." if battle.outcome == "victory" else " Pas de récompense cette fois.")
	else: words += "\n\nDuel libre terminé : aucun temps ni réserve modifié."
	words += "\nTu peux rejouer ce duel pour essayer d'autres enchaînements."
	words += "\nJun hausse le niveau pour le prochain duel." if completed_duels <= 4 else "\nJun maintient son niveau d’entraînement maximal."
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
	notice = "Entraînement quitté : aucun temps ni réserve consommé."
	hub()

func restart() -> void:
	calendar = Calendar.new()
	calendar.slot = 3
	calendar.seen = ["M01"]
	stage = 0
	completed_duels = 0
	selected = -1
	notice = ""
	restore_actors()
	save_progress()
	hub()

func load_progress() -> bool:
	var saved = Progress.read_progress(save_path)
	if saved.is_empty(): return false
	calendar.restore(saved.state)
	stage = int(saved.stage)
	completed_duels = saved.completed_duels
	muted = saved.muted
	reduced_motion = saved.reduced
	notice = "Progression reprise. Un duel interrompu reprend avant le combat."
	return true

func save_progress() -> bool:
	if not persistence: return true
	var saved = Progress.save_progress(calendar,stage,muted,reduced_motion,save_path,completed_duels)
	if not saved: notice = "Échec de sauvegarde : la progression reste en mémoire."
	return saved

func update_restoration() -> void:
	var level: int = calendar.buildings.hall
	scenery.set_shader_parameter("restoration",Vector3(float(level >= 1),float(level >= 2),float(level >= 2)))

func confirm_restart() -> void:
	dialogue(3,false,"Recommencer effacera la progression de cette séquence. Les sauvegardes du laboratoire et de l'ancien prototype restent séparées.","Recommencer cette séquence",restart)

func activities_ui(show_summary: bool = false) -> void:
	mode = "activities"
	player.walking = false
	clear_ui()
	var screen = preload("res://visual/activities/menu.tscn").instantiate()
	ui.add_child(screen)
	screen.setup(self,show_summary)

func do_activity(action: String, choice = "E01") -> String:
	if busy or mode == "combat" or calendar.slot >= Progress.END_SLOT: return "Activité indisponible."
	var before = calendar.supplies
	var owned = calendar.collection.duplicate()
	var error = calendar.act(action,true,choice)
	if error != "": notice = error; activities_ui(); return error
	var gained: Array[String] = []
	for id in calendar.collection:
		if not owned.has(id): gained.append(Cards.catalog()[id].name)
	notice = "Une période écoulée. Réserves : %+d." % [calendar.supplies-before]
	if not gained.is_empty(): notice += " Acquis : " + ", ".join(gained) + ". À équiper dans le deck."
	if action == "hall": notice += " Le pavillon est réparé au niveau %d." % calendar.buildings.hall
	if stage == 0 and calendar.collection.has("L01"): stage = 1
	save_progress()
	update_restoration()
	if calendar.slot >= Progress.END_SLOT or calendar.slot % 3 == 0: activities_ui(true)
	else: hub()
	return ""

func tone(frequency: float) -> void:
	if muted: return
	var bytes = PackedByteArray()
	var count = 6600
	bytes.resize(count*2)
	for i in range(count):
		var t = i/22050.0
		var value = sin(TAU*frequency*t)*exp(-t*18)*0.45 + sin(TAU*frequency*2.01*t)*exp(-t*30)*0.12
		bytes.encode_s16(i*2,int(value*32767))
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	stream.data = bytes
	sound.stream = stream
	sound.play()
