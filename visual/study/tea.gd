extends Control

const PERIODS = ["Matin", "Après-midi", "Soir"]
@export var reward_art: Dictionary = {}
var game
var closing = false
var elapsed = 0.0

func setup(controller, new_cards: Array, _action: String = "L") -> void:
	game = controller
	var c = game.calendar
	var previous_slot = maxi(0, c.slot - 1)
	var previous_rank = maxi(1, int(c.ranks.L) - 1)
	for record in c.history:
		if int(record.slot) == previous_slot and record.action == "L":
			previous_rank = int(record.get("before", {}).get("ranks", {}).get("L", previous_rank))
	$Time/Value.text = "%s → %s" % [PERIODS[previous_slot % 3], PERIODS[c.period()]]
	$Bond/Value.text = "Lian · Lien %d → %d" % [previous_rank, c.ranks.L]
	$Reward.visible = not new_cards.is_empty()
	$NoCard.visible = new_cards.is_empty()
	if not new_cards.is_empty():
		var id: String = new_cards[0]
		var card = game.Cards.catalog()[id]
		$Reward/Art.texture = reward_art.get(id, preload("res://visual/deck/tile.gd").illustration(id))
		$Reward/Name.text = card.name
		$Reward/Cost.text = "%d Qi" % card.cost
		$Reward/Effects.text = game.Cards.Effects.describe(card)
	else:
		$NoCard/Value.text = c.relation_reward("L", false)
	$Continue.pressed.connect(advance)
	$Continue.grab_focus()
	$Steam.visible = not game.reduced_motion
	$Petals.visible = not game.reduced_motion
	$Petals.set_process(not game.reduced_motion)

func _process(delta: float) -> void:
	if not is_instance_valid(game) or game.reduced_motion: return
	elapsed += delta
	$Steam.material.set_shader_parameter("steam_time", elapsed)
	$Branches.rotation = sin(elapsed * 0.42) * 0.006
	$Foreground.rotation = sin(elapsed * 0.37) * 0.004

func advance() -> void:
	if closing: return
	closing = true
	game.busy = false
	if game.calendar.slot >= game.Progress.END_SLOT or game.calendar.slot % 3 == 0: game.activities_ui(true)
	else: game.return_to_location()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		advance()
