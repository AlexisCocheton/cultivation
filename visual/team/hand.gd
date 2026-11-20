extends Control
const Card = preload("res://visual/team/hand_card.tscn")
var game
var cards: Array = []
var hovered = -1
var pressed = -1
var dragging = false
var origin = Vector2.ZERO
var pointer = Vector2.ZERO
func setup(controller) -> void: game = controller
func rebuild() -> void:
	pressed = -1
	dragging = false
	hovered = -1
	for child in get_children():
		remove_child(child)
		child.queue_free()
	cards.clear()
	var model = game.hand_model()
	var n: int = model.hand.size()
	var step = minf(196, (size.x-210)/maxi(1,n-1))
	var start = (size.x-(194+(n-1)*step))*0.5
	for i in range(n):
		var card = Card.instantiate()
		# Set identity before the tile enters the tree.
		var id: String = model.hand[i]
		card.get_node("Viewport/Card").card_id = id
		card.get_node("Viewport/Card").relation_ranks = model.relation_ranks
		card.get_node("Viewport/Card").combat_cost = model.character.card_cost(id)
		add_child(card)
		card.setup(id,i,can_play(i),game.selected == i)
		var arc = (float(i)-(n-1)*0.5)/maxf(1,(n-1)*0.5)
		# Fit the complete rotated face and its shadow inside both 232px and 252px hands.
		# At 5 degrees the 194x210 card + shadow reaches about 229px vertically.
		card.home = Vector2(start+i*step,maxf(0,size.y-236)-absf(arc)*2)
		card.home_angle = deg_to_rad(arc*5)
		card.position = card.home
		card.rotation = card.home_angle
		card.z_index = i
		card.focus_entered.connect(func(): hovered = card.index)
		card.gui_input.connect(func(event):
			if event.is_action_pressed("ui_accept") and can_play(card.index): game.select_card(card.index))
		cards.append(card)
func can_play(index: int) -> bool:
	return game != null and not blocked() and game.can_play_card(index)
func blocked() -> bool:
	return game == null or game.hand_blocked()
func hit(point: Vector2) -> int:
	# The exposed strip of every card stays reachable even under an enlarged neighbour.
	var local = get_global_transform_with_canvas().affine_inverse()*point
	if local.y >= 35:
		for i in range(cards.size()-1,-1,-1):
			if Rect2(cards[i].home,Vector2(194,210)).has_point(local): return i
	if hovered >= 0 and hovered < cards.size() and cards[hovered].contains(point): return hovered
	for i in range(cards.size()-1,-1,-1):
		if cards[i].contains(point): return i
	return -1
func _input(event: InputEvent) -> void:
	if blocked(): return
	if event is InputEventMouseMotion:
		pointer = event.position
		if pressed >= 0:
			if not dragging and event.position.distance_to(origin) > 8:
				dragging = true
				game.begin_card_drag(pressed)
			if dragging: game.preview_card_drop(pressed,event.position)
		else: hovered = hit(event.position)
	elif event is InputEventMouseButton:
		pointer = event.position
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and pressed >= 0:
			abort_drag()
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var index = hit(event.position)
				if index >= 0:
					hovered = index
					if can_play(index): pressed = index; origin = event.position
					get_viewport().set_input_as_handled()
			elif pressed >= 0:
				var index = pressed
				var was_dragging = dragging
				pressed = -1
				dragging = false
				get_viewport().set_input_as_handled()
				if was_dragging: game.drop_card(index,event.position)
				elif hit(event.position) == index: game.select_card(index)
	elif event.is_action_pressed("ui_cancel") and pressed >= 0:
		abort_drag()
		get_viewport().set_input_as_handled()
func abort_drag() -> void:
	pressed = -1
	dragging = false
	game.cancel_selection()
func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and pressed >= 0: abort_drag()
func _process(delta: float) -> void:
	for i in range(cards.size()):
		var card = cards[i]
		var active = i == hovered and not dragging and not blocked()
		var destination: Vector2 = card.home
		var angle: float = card.home_angle
		var zoom = 1.0
		card.z_index = i
		if active:
			destination.y -= 40 if game.selected == i else 105
			destination.x = clampf(destination.x,25,size.x-220)
			angle = 0
			zoom = 1.08 if game.selected == i else 1.24
			card.z_index = 40
		if dragging and i == pressed:
			destination = get_global_transform_with_canvas().affine_inverse()*pointer-Vector2(97,105)
			angle = 0
			zoom = 1.1
			card.z_index = 60
		card.pose(destination,angle,zoom,active or (dragging and i == pressed),delta)
