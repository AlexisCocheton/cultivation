extends SceneTree

const State = preload("res://legacy/prototype/state.gd")
const Fighter = preload("res://legacy/prototype/fighter.gd")
var failures = 0

func check(condition: bool, description: String) -> void:
	if not condition:
		push_error(description)
		failures += 1

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var state = State.new()
	state.bond("Lian")
	check(not state.deck.has("petales"), "No card before bond level 2")
	state.bond("Lian")
	check(state.deck.has("petales"), "Bond level 2 awards card")
	state.bond("Lian")
	check(state.deck.count("petales") == 1, "No duplicate relationship reward")
	check(state.day == 2 and state.period == 0, "Three activities advance one day")
	state.hero_name = "Test recrue"
	state.save_game("user://test_save.json")
	var restored = State.new()
	check(restored.load_game("user://test_save.json"), "Save loads")
	check(restored.hero_name == state.hero_name and restored.deck == state.deck and restored.day == 2, "Save round trip")
	var fighter = Fighter.new()
	fighter.start(state.deck, false)
	check(fighter.hand.size() == 5 and fighter.energy == 3, "Opening hand and energy")
	fighter.hand = ["petales", "garde", "contre", "frappe"]
	fighter.draw_pile.clear()
	fighter.discard.clear()
	check(fighter.play(0) and fighter.enemy_hp == 26, "Attack damages enemy")
	fighter.play(0)
	fighter.play(0)
	check(fighter.block == 9 and fighter.energy == 0, "Defense and qi costs")
	check(not fighter.play(0), "Cannot play with insufficient qi")
	fighter.end_turn()
	check(fighter.hp == 40 and fighter.block == 0 and fighter.energy == 3, "Block absorbs intent and resets")
	check(fighter.hand.size() == 4, "Discard reshuffles without losing cards")
	var game = load("res://legacy/prototype/main.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.close_modal()
	game.state = State.new()
	game.refresh()
	game.interact("cuisine")
	for child in game.modal_box.get_children():
		if child is Button and child.text.begins_with("Aider"):
			child.pressed.emit()
			break
	check(game.state.supplies == 5 and game.state.period == 1, "Cuisine button awards supplies and consumes time")
	game.interact("atelier")
	for child in game.modal_box.get_children():
		if child is Button and child.text.begins_with("Restaurer"):
			child.pressed.emit()
			break
	check(game.state.equipment and game.state.deck.has("lame") and game.state.supplies == 3, "Equipment button spends supplies and grants card")
	game.interact("hall")
	for child in game.modal_box.get_children():
		if child is Button and child.text.begins_with("Réparer"):
			child.pressed.emit()
			break
	check(game.state.repairs == 1 and game.state.supplies == 1 and game.state.day == 2, "Repair button and day rollover")
	for person in ["Lian", "Jun", "Shen", "hall", "cuisine", "atelier"]:
		game.interact(person)
		check(is_instance_valid(game.modal), "Interaction opens: " + person)
		game.close_modal()
	var original = game.actors.Lian.position
	game.state.advance()
	game.refresh()
	check(game.actors.Lian.destination != original, "Schedule changes NPC destination")
	game.actors.Lian._process(0.1)
	check(game.actors.Lian.walking and game.actors.Lian.position != original, "NPC walks to scheduled location")
	game.start_fight(false)
	game.fight.enemy_hp = 1
	game.fight.hand = ["frappe"]
	var before = game.state.supplies
	game.play_card(0)
	check(game.fight == null and game.state.supplies == before + 2, "Duel victory returns to hub with reward")
	game.state.repairs = 3
	game.start_fight(true)
	game.finish_fight(true)
	check(game.state.inspection_won and game.state.inspection_done, "Restoration and duel win inspection")
	game.close_modal()
	game.state.inspection_done = false
	game.state.repairs = 0
	game.start_fight(true)
	game.finish_fight(true)
	check(not game.state.inspection_won, "Duel alone cannot pass inspection")
	game.close_modal()
	game.queue_free()
	await process_frame
	print("GAME TESTS: ", "PASS" if failures == 0 else "FAIL (%d)" % failures)
	quit(0 if failures == 0 else 1)
