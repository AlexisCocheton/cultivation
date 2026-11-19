extends Node2D

const State = preload("res://scripts/state.gd")
const Avatar = preload("res://scripts/avatar.gd")
const Fighter = preload("res://scripts/fighter.gd")
const CREAM = Color("eadcbd")
const GOLD = Color("d8af70")
const ROBES = [Color("9eafa4"), Color("a56870"), Color("617f9a")]
const SKINS = [Color("e6ba96"), Color("be8a66"), Color("8c604c")]
const HAIRS = [Color("282735"), Color("684337"), Color("c5c1af")]
const SCHEDULE = {
	"Lian": [Vector2(370,515), Vector2(900,535), Vector2(300,575)],
	"Jun": [Vector2(1030,560), Vector2(750,630), Vector2(960,540)],
	"Shen": [Vector2(650,470), Vector2(390,540), Vector2(650,490)]
}
var state = State.new()
var player: Node2D
var actors = {}
var target = Vector2(650,640)
var destination_id = ""
var ui: Control
var modal: Control
var modal_box: VBoxContainer
var status: Label
var prompt: Label
var notice: Label
var phase_tint: ColorRect
var roster: VBoxContainer
var fight = null
var nearest = ""
var elapsed = 0.0
var scene_clock = 0.0
var screenshot_taken = false
var scenery: ShaderMaterial
var visible_repairs = Vector3.ZERO

func _ready() -> void:
	var theme = Theme.new()
	theme.default_font_size = 17
	theme.set_color("font_color", "Label", CREAM)
	theme.set_color("font_color", "Button", CREAM)
	for kind in ["normal", "hover", "pressed", "disabled", "focus"]:
		var style = StyleBoxFlat.new()
		style.bg_color = Color("263b3d") if kind != "hover" else Color("41615b")
		if kind == "disabled":
			style.bg_color = Color("282c31")
		style.border_color = Color("65786a") if kind != "focus" else GOLD
		style.set_border_width_all(1)
		style.set_corner_radius_all(4)
		style.content_margin_left = 14
		style.content_margin_right = 14
		style.content_margin_top = 10
		style.content_margin_bottom = 10
		theme.set_stylebox(kind, "Button", style)
	var backdrop = Sprite2D.new()
	backdrop.texture = load("res://assets/sect_courtyard.png")
	backdrop.centered = false
	backdrop.z_index = -10
	scenery = ShaderMaterial.new()
	scenery.shader = preload("res://shaders/courtyard.gdshader")
	scenery.set_shader_parameter("restored", load("res://assets/sect_restored.png"))
	backdrop.material = scenery
	backdrop.scale = Vector2(1280.0 / backdrop.texture.get_width(), 832.0 / backdrop.texture.get_height())
	add_child(backdrop)
	var layer = Node2D.new()
	layer.y_sort_enabled = true
	layer.z_index = -5
	add_child(layer)
	for person in SCHEDULE:
		var actor = Avatar.new()
		actor.character_row = {"Lian":1,"Jun":2,"Shen":3}[person]
		actor.robe_color = {"Lian": Color("b87987"), "Jun": Color("58738b"), "Shen": Color("aaa18a")}[person]
		actor.elder = person == "Shen"
		if actor.elder:
			actor.hair_color = Color("dfd9c7")
		layer.add_child(actor)
		actors[person] = actor
	player = Avatar.new()
	player.position = target
	layer.add_child(player)
	var petals = preload("res://scripts/petals.gd").new()
	petals.z_index = 2
	add_child(petals)
	var canvas = CanvasLayer.new()
	add_child(canvas)
	ui = Control.new()
	ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.theme = theme
	canvas.add_child(ui)
	phase_tint = ColorRect.new()
	phase_tint.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	phase_tint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(phase_tint)
	var top = panel(ui, Vector2(22,18), Vector2(1236,86))
	var heading = label(top, "LES CENDRES DU PRUNIER", 25, GOLD)
	heading.position = Vector2(22,10)
	status = label(top, "", 16)
	status.position = Vector2(22,49)
	var buttons = HBoxContainer.new()
	buttons.position = Vector2(685,21)
	top.add_child(buttons)
	button(buttons, "Techniques", show_deck)
	button(buttons, "Journal", show_journal)
	button(buttons, "Repos", rest_dialog)
	button(buttons, "Portrait", customize)
	var sidebar = panel(ui, Vector2(24,127), Vector2(238,221))
	var sidebox = VBoxContainer.new()
	sidebox.position = Vector2(16,13)
	sidebox.size.x = 206
	sidebox.add_theme_constant_override("separation", 12)
	sidebar.add_child(sidebox)
	label(sidebox, "LA SECTE SURVIT ENCORE", 14, GOLD)
	roster = VBoxContainer.new()
	sidebox.add_child(roster)
	label(sidebox, "Rencontrez les disciples.\nChaque activité coûte une période.\nL'exploration reste libre.", 13)
	var lower = panel(ui, Vector2(22,753), Vector2(1236,61))
	prompt = label(lower, "", 17, GOLD)
	prompt.position = Vector2(18,8)
	label(lower, "ZQSD / WASD / flèches : marcher    •    Clic : se déplacer    •    E : interagir    •    Tab : techniques    •    Échap : fermer", 13).position = Vector2(18,35)
	notice = label(ui, "", 17, CREAM)
	notice.position = Vector2(300,710)
	notice.size = Vector2(900,35)
	notice.add_theme_color_override("font_shadow_color", Color.BLACK)
	notice.add_theme_constant_override("shadow_offset_x", 2)
	notice.add_theme_constant_override("shadow_offset_y", 2)
	var loaded = state.load_game()
	refresh()
	if not loaded:
		customize(true)
	else:
		toast("Bienvenue à nouveau, %s. Votre progression a été chargée." % state.hero_name)
	if "--smoke" in OS.get_cmdline_user_args():
		close_modal()
		if "--combat" in OS.get_cmdline_user_args():
			start_fight(false)
		if "--restored" in OS.get_cmdline_user_args():
			state.repairs = 3
			refresh()
			visible_repairs = Vector3.ONE

func panel(parent: Node, pos: Vector2, dimensions: Vector2) -> Panel:
	var result = Panel.new()
	result.position = pos
	result.size = dimensions
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.065,0.105,0.12,0.95)
	style.border_color = Color("736950")
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	result.add_theme_stylebox_override("panel", style)
	parent.add_child(result)
	return result

func label(parent: Node, text: String, font_size: int = 17, color: Color = CREAM) -> Label:
	var result = Label.new()
	result.text = text
	result.add_theme_font_size_override("font_size", font_size)
	result.add_theme_color_override("font_color", color)
	parent.add_child(result)
	return result

func button(parent: Node, text: String, callback: Callable, disabled: bool = false) -> Button:
	var result = Button.new()
	result.text = text
	result.disabled = disabled
	result.pressed.connect(callback)
	parent.add_child(result)
	return result

func clear_children(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

func refresh() -> void:
	status.text = "Jour %02d  /  %s     •     Inspection : %s     •     Réserves %d     •     Restauration %d/3" % [state.day, State.PERIODS[state.period], "terminée" if state.inspection_done else "J−%d" % maxi(0,7-state.day), state.supplies, state.repairs]
	phase_tint.color = [Color(0.65,0.78,0.9,0.02), Color(1,0.68,0.35,0.05), Color(0.08,0.12,0.32,0.37)][state.period]
	player.robe_color = ROBES[state.robe]
	player.hair_color = HAIRS[state.hair]
	player.skin_color = SKINS[state.skin]
	clear_children(roster)
	for person in SCHEDULE:
		if not actors[person].autonomous:
			actors[person].position = SCHEDULE[person][state.period]
		actors[person].destination = SCHEDULE[person][state.period]
		actors[person].autonomous = true
		label(roster, "%s  ·  %s  ·  Lien %d" % [person, {"Lian":"Confidente", "Jun":"Rival", "Shen":"Mentor"}[person], state.affinity[person]], 14)
	queue_redraw()

func _process(delta: float) -> void:
	scene_clock += delta
	var repair_target = Vector3(float(state.repairs >= 1),float(state.repairs >= 2),float(state.repairs >= 3))
	visible_repairs = visible_repairs.move_toward(repair_target,delta * 1.5)
	scenery.set_shader_parameter("restoration",visible_repairs)
	scenery.set_shader_parameter("wind_time",scene_clock)
	elapsed += delta
	if elapsed > 7:
		notice.text = ""
	player.walking = false
	if not is_instance_valid(modal):
		var movement = Vector2(float(held([KEY_D,KEY_RIGHT]))-float(held([KEY_A,KEY_Q,KEY_LEFT])), float(held([KEY_S,KEY_DOWN]))-float(held([KEY_W,KEY_Z,KEY_UP])))
		if movement.length() > 0:
			destination_id = ""
			target = player.position + movement.normalized() * 20
		var old_position = player.position
		player.position = player.position.move_toward(target, 180 * delta)
		player.position.y = clampf(player.position.y, 450, 735)
		player.position.x = clampf(player.position.x, 180, 1130)
		player.walking = old_position.distance_to(player.position) > 0.1
		player.face_motion(player.position - old_position)
		nearest = ""
		var distance = 88.0
		for id in locations():
			var d = player.position.distance_to(locations()[id])
			if d < distance:
				distance = d
				nearest = id
		prompt.text = "[E]  %s" % interaction_name(nearest) if nearest != "" else "Cour du Prunier — approchez un disciple ou un lieu marqué."
		if destination_id != "" and player.position.distance_to(target) < 8:
			var id = destination_id
			destination_id = ""
			interact(id)
		if state.day >= 7 and not state.inspection_done and not is_instance_valid(modal):
			inspection_dialog()
	queue_redraw()
	if "--smoke" in OS.get_cmdline_user_args() and scene_clock > 1 and not screenshot_taken:
		screenshot_taken = true
		var preview_path = "res://tests/hub-restored.png" if "--restored" in OS.get_cmdline_user_args() else "res://tests/hub-preview.png"
		get_viewport().get_texture().get_image().save_png("res://tests/combat-preview.png" if "--combat" in OS.get_cmdline_user_args() else preview_path)
		get_tree().quit()

func held(keys: Array) -> bool:
	for key in keys:
		if Input.is_key_pressed(key):
			return true
	return false

func locations() -> Dictionary:
	var result = {"hall": Vector2(700,450), "cuisine": Vector2(200,540), "atelier": Vector2(1110,650)}
	for person in actors:
		result[person] = actors[person].position
	return result

func interaction_name(id: String) -> String:
	return {"hall":"Restaurer le pavillon", "cuisine":"Aider aux cuisines", "atelier":"Atelier · équiper une lame", "Lian":"Parler à Lian", "Jun":"Défier Jun", "Shen":"Écouter maître Shen"}.get(id, "")

func _draw() -> void:
	if not is_instance_valid(player):
		return
	var font = ThemeDB.fallback_font
	for id in locations():
		var p: Vector2 = locations()[id]
		var text = id if actors.has(id) else {"hall":"PAVILLON", "cuisine":"CUISINES", "atelier":"ATELIER"}[id]
		var offset = 106 if actors.has(id) else 20
		var width = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
		draw_style_box(name_style(), Rect2(p.x-width/2-8,p.y-offset-17,width+16,25))
		draw_string(font, p + Vector2(-width/2,-offset), text, HORIZONTAL_ALIGNMENT_LEFT,-1,14, CREAM)
		if id == nearest:
			draw_arc(p,22,0,TAU,32,GOLD,2)
	draw_arc(player.position,19,0,TAU,32,Color("b9ddc7"),1.5)
	if player.position.distance_to(target) > 10 and not is_instance_valid(modal):
		draw_arc(target,7,0,TAU,12,Color(0.9,0.8,0.6,0.6),1)

func name_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.06,0.1,0.12,0.8)
	style.set_corner_radius_all(3)
	return style

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			if fight == null:
				close_modal()
		elif not is_instance_valid(modal):
			if event.keycode == KEY_E and nearest != "":
				interact(nearest)
			elif event.keycode == KEY_TAB:
				show_deck()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and not is_instance_valid(modal):
		var point = get_global_mouse_position()
		destination_id = ""
		for id in locations():
			if point.distance_to(locations()[id] - Vector2(0,30)) < 50:
				destination_id = id
				target = locations()[id] + Vector2(0,35)
				return
		target = Vector2(clampf(point.x,180,1130),clampf(point.y,450,735))

func open_modal(title: String, description: String) -> void:
	close_modal()
	modal = Control.new()
	modal.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui.add_child(modal)
	var dim = ColorRect.new()
	dim.color = Color(0.02,0.04,0.07,0.72)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	modal.add_child(dim)
	var frame = panel(modal,Vector2(250,126),Vector2(780,590))
	var scroll = ScrollContainer.new()
	scroll.position = Vector2(28,24)
	scroll.size = Vector2(724,542)
	frame.add_child(scroll)
	modal_box = VBoxContainer.new()
	modal_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	modal_box.add_theme_constant_override("separation",16)
	scroll.add_child(modal_box)
	label(modal_box,title,29,GOLD)
	var body = label(modal_box,description,18)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func close_modal() -> void:
	if is_instance_valid(modal):
		ui.remove_child(modal)
		modal.queue_free()
	modal = null
	target = player.position if is_instance_valid(player) else target

func toast(message: String) -> void:
	notice.text = message
	elapsed = 0

func finish_activity(message: String) -> void:
	state.record(message)
	state.advance()
	close_modal()
	refresh()
	toast(message)

func customize(first: bool = false) -> void:
	open_modal("Une nouvelle feuille", "La secte ne compte plus que trois résidents. Dans sept jours, un inspecteur décidera de son avenir. Votre arrivée peut tout changer." if first else "Votre recrue · apparence et nom")
	var name_input = LineEdit.new()
	name_input.text = state.hero_name
	name_input.max_length = 20
	modal_box.add_child(name_input)
	var selectors = []
	for spec in [["Tenue",["Jade pâle","Prunier","Bleu d'encre"],state.robe],["Cheveux",["Encre","Châtain","Argent"],state.hair],["Teint",["Clair","Ambré","Brun"],state.skin]]:
		label(modal_box,spec[0],15)
		var select = OptionButton.new()
		for item in spec[1]:
			select.add_item(item)
		select.selected = spec[2]
		modal_box.add_child(select)
		selectors.append(select)
	button(modal_box,"Franchir les portes" if first else "Enregistrer",func():
		state.hero_name = name_input.text.strip_edges() if not name_input.text.strip_edges().is_empty() else "Yun"
		state.robe = selectors[0].selected
		state.hair = selectors[1].selected
		state.skin = selectors[2].selected
		state.save_game()
		close_modal()
		refresh()
		toast("Parlez à maître Shen pour découvrir les techniques de la secte.")
	)

func interact(id: String) -> void:
	if actors.has(id):
		var lines = {
			"Lian":["Les pétales tombent, mais l'arbre tient encore. Tu crois que nous pouvons en faire autant ?", "Une technique n'est pas une collection de gestes. Regarde l'espace entre les coups.", "La cuisine est enfin calme. Reste un peu… ici, je peux oublier l'inspection."],
			"Jun":["Une recrue ? Très bien. Montre-moi que tu sais tenir une lame avant de promettre de sauver la secte.", "Tu progresses. Ne prends pas ça pour un compliment… Allez, encore une passe !", "J'ai réparé ces mannequins trois fois. Tant que je suis là, cette cour ne restera pas vide."],
			"Shen":["Nous n'avons plus de richesses à offrir. Seulement quelques techniques, et la responsabilité de les transmettre.", "Une journée ne suffit pas à rebâtir un pavillon. Mais elle suffit à en relever une pierre.", "L'inspection est au septième matin. Cultive tes liens, restaure notre maison et prépare tes techniques."]}
		open_modal(id + " · " + {"Lian":"la fleur tenace", "Jun":"le rival fidèle", "Shen":"le dernier maître"}[id], "« %s »\n\nLien : %d · Une technique est transmise au niveau 2.\nTous les personnages sont adultes." % [lines[id][state.period],state.affinity[id]])
		button(modal_box,"Passer du temps ensemble  ·  1 période",func():
			var message = state.bond(id)
			close_modal()
			refresh()
			toast(message)
		)
		if id == "Jun":
			button(modal_box,"Duel d'entraînement  ·  1 période  ·  +2 réserves si victoire",func(): start_fight(false))
		if id == "Lian" and state.affinity.Lian >= 3 and state.period == 2:
			button(modal_box,"Confier vos sentiments  ·  1 période",func():
				state.romance = true
				finish_activity("Lian prend votre main. Un premier lien amoureux est né.")
			, state.romance)
		button(modal_box,"À bientôt  ·  sans coût",close_modal)
	elif id == "hall":
		open_modal("Le pavillon des anciens", "Le toit laisse passer la pluie, mais les fondations tiennent encore.\nChaque restauration coûte 2 réserves et une période.\nÀ 3/3, la secte réussit le critère matériel de l'inspection.\nRestauration actuelle : %d/3." % state.repairs)
		button(modal_box,"Réparer le pavillon  ·  2 réserves + 1 période",func():
			state.supplies -= 2
			state.repairs += 1
			finish_activity(["Les marches et le soubassement sont restaurés.","La toiture est réparée : plus une tuile ne manque.","Boiseries et bannières neuves : le pavillon retrouve sa splendeur."][state.repairs-1])
		, state.supplies < 2 or state.repairs >= 3)
		button(modal_box,"Retour",close_modal)
	elif id == "cuisine":
		open_modal("Un foyer encore chaud", "Éplucher les légumes, préparer le riz, trier les herbes… La secte tient aussi grâce à ces gestes.\nCette activité rapporte 2 réserves.")
		button(modal_box,"Aider aux cuisines  ·  1 période",func():
			state.supplies += 2
			finish_activity("Les réserves de la secte augmentent de 2.")
		)
		button(modal_box,"Retour",close_modal)
	else:
		open_modal("L'atelier silencieux", "Une vieille épée attend une nouvelle main. Sa restauration ajoute la carte Lame restaurée à votre deck.\nCoût : 2 réserves et une période.")
		button(modal_box,"Restaurer et équiper la lame",func():
			state.supplies -= 2
			state.equipment = true
			state.deck.append("lame")
			finish_activity("Épée équipée : Lame restaurée rejoint votre deck.")
		, state.supplies < 2 or state.equipment)
		button(modal_box,"Retour",close_modal)

func rest_dialog() -> void:
	open_modal("Laisser le temps passer", "Vous passez à la période suivante. Le soir, cela commence une nouvelle journée.\nLes disciples changent de lieu selon leur emploi du temps.")
	button(modal_box,"Se reposer  ·  1 période",func(): finish_activity("Vous prenez un moment de repos."))
	button(modal_box,"Retour",close_modal)

func show_deck() -> void:
	open_modal("Vos techniques", "%d cartes · Équipement : %s\nLes liens de niveau 2 enseignent une technique. Dans cette version, toutes les cartes acquises sont dans votre deck." % [state.deck.size(),"épée restaurée" if state.equipment else "sabre d'entraînement"])
	var counts = {}
	for id in state.deck:
		counts[id] = counts.get(id,0) + 1
	for id in counts:
		var card = State.CARDS[id]
		label(modal_box,"%s ×%d  ·  %d qi\n%s" % [card.name,counts[id],card.cost,card.text],17)
	button(modal_box,"Retour à la cour",close_modal)

func show_journal() -> void:
	open_modal("Chronique du Prunier", "OBJECTIF · Avant le septième matin\nRestaurer le pavillon 3/3 et gagner le duel d'inspection.\n\nHORAIRES\nLian : prunier → entraînement → cuisine\nJun : mannequins → cour → entraînement\nShen : pavillon → prunier → pavillon\n\n" + "\n\n".join(state.journal))
	button(modal_box,"Retour",close_modal)

func inspection_dialog() -> void:
	open_modal("Le septième matin", "L'inspecteur a franchi les portes. Le temps de la préparation est terminé.\n\nRestauration : %d/3\nTechniques dans votre deck : %d\n\nPour sauver la secte, le pavillon doit être restauré et vous devez remporter le duel." % [state.repairs,state.deck.size()])
	button(modal_box,"Représenter la secte",func(): start_fight(true))

func start_fight(boss: bool) -> void:
	fight = Fighter.new()
	fight.start(state.deck,boss)
	show_fight()

func show_fight() -> void:
	open_modal("L'inspection du Prunier" if fight.boss else "Duel dans la cour", "%s : %d / 40 PV    ·    Garde : %d    ·    Qi : %d / 3\n%s : %d PV\nINTENTION : infliger %d dégâts à la fin de votre tour.\nLa garde disparaît au début de votre prochain tour." % [state.hero_name,fight.hp,fight.block,fight.energy,"Inspecteur" if fight.boss else "Jun",fight.enemy_hp,fight.intent()])
	modal_box.add_theme_constant_override("separation",10)
	var row = HFlowContainer.new()
	row.add_theme_constant_override("h_separation",10)
	row.add_theme_constant_override("v_separation",10)
	modal_box.add_child(row)
	for i in range(fight.hand.size()):
		var card = State.CARDS[fight.hand[i]]
		var card_button = button(row,"%d QI\n%s\n\n%s" % [card.cost,card.name,card.text],play_card.bind(i),fight.energy < card.cost)
		card_button.custom_minimum_size = Vector2(220,100)
		card_button.add_theme_font_size_override("font_size",13)
	label(modal_box,"Pioche : %d  ·  Défausse : %d" % [fight.draw_pile.size(),fight.discard.size()],14)
	button(modal_box,"Terminer le tour",func():
		fight.end_turn()
		if fight.hp <= 0:
			finish_fight(false)
		else:
			show_fight()
	)
	button(modal_box,"Concéder le duel",func(): finish_fight(false))

func play_card(index: int) -> void:
	if fight.play(index):
		if fight.enemy_hp <= 0:
			finish_fight(true)
		else:
			show_fight()

func finish_fight(won: bool) -> void:
	var boss: bool = fight.boss
	fight = null
	if boss:
		state.inspection_done = true
		state.inspection_won = won and state.repairs >= 3
		var message = "La secte conserve ses portes ouvertes. Le Prunier refleurira." if state.inspection_won else "L'inspecteur accorde un sursis. Il faudra renforcer la secte pour convaincre le conseil."
		state.record(message)
		state.save_game()
		refresh()
		open_modal("Le Prunier refleurit" if state.inspection_won else "Un printemps à reconquérir", message + "\n\nFin du premier chapitre prototype. Vous pouvez continuer à explorer et développer vos liens.")
		button(modal_box,"Retour à la secte",close_modal)
	else:
		if won:
			state.supplies += 2
		finish_activity("Duel remporté : +2 réserves." if won else "Jun vous aide à vous relever. Une défaite est aussi une leçon.")
