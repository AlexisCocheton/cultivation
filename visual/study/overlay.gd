extends Control

var game
var gained: Array = []
var elapsed = 0.0
var finished = false
var closing = false
var resident = "H"
const NAMES = {"H":"Shen", "J":"Jun", "L":"Lian"}

func setup(controller, new_cards: Array, action: String = "H") -> void:
	game = controller
	gained = new_cards
	resident = action
	$BackdropArt.texture = preload("res://assets/ui/activities/study-background.png") if resident == "H" else preload("res://assets/team/arena.png")
	if resident != "H":
		$Chibi.texture = preload("res://assets/study/chibi-activities.png")
		$Chibi.scale = Vector2.ONE * (550.0 / ($Chibi.texture.get_width() / 4.0))
		$Chibi.frame = 0 if resident == "J" else 4
		$Title.text = "Entraînement avec Jun" if resident == "J" else "Le thé avec Lian"
		$Result.text = "Garde, frappe, parade…" if resident == "J" else "Un thé, quelques conseils, un lien qui grandit…"
	$Illustration.texture = preload("res://assets/ui/activities/study-people.png") if resident == "H" else preload("res://assets/ui/activities/training-people.png")
	$Continue.pressed.connect(advance)
	if game.reduced_motion: finish()

func _process(delta: float) -> void:
	if finished or not is_instance_valid(game): return
	elapsed += delta
	if resident != "H":
		if elapsed < 3.2:
			$Chibi.frame = (0 if resident == "J" else 4) + int(elapsed/0.4) % 4
		else: finish()
		return
	if elapsed < 2.8:
		$Chibi.frame = int(elapsed/0.35) % 4
	elif not gained.is_empty() and elapsed < 4.4:
		$Chibi.frame = 4 + mini(3,int((elapsed-2.8)/0.4))
		$Result.text = "Une technique devient claire !"
	else: finish()

func finish() -> void:
	finished = true
	$Chibi.hide()
	$Illustration.show()
	$Chibi.frame = 7 if not gained.is_empty() else 2
	if resident != "H": $Chibi.frame = 3 if resident == "J" else 7
	var names: Array[String] = []
	for id in gained: names.append(game.Cards.catalog()[id].name)
	$Result.text = "Une période écoulée · Lien avec %s : rang %d" % [NAMES[resident],game.calendar.ranks[resident]]
	$Result.text += "\n" + game.calendar.relation_reward(resident,false)
	$Continue.text = "Continuer"
	if not gained.is_empty() and $RewardSlot.get_child_count() == 0:
		var card = preload("res://visual/study/reward_card.tscn").instantiate()
		card.card_id = gained[0]
		card.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$RewardSlot.add_child(card)

func advance() -> void:
	if closing: return
	if not finished:
		finish()
		return
	closing = true
	game.busy = false
	if game.calendar.slot >= game.Progress.END_SLOT or game.calendar.slot % 3 == 0: game.activities_ui(true)
	else: game.return_to_location()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		advance()
