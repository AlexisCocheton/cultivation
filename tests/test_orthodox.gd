extends SceneTree
const Cards = preload("res://prototypes/cards.gd")
const Battle = preload("res://prototypes/battle.gd")
const Calendar = preload("res://prototypes/calendar.gd")
const Progress = preload("res://visual/progress.gd")
var checks = 0
var failures = 0

func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(message)

func deck_of(size: int) -> Array:
	var deck = Cards.PRESETS["Départ"].duplicate()
	var extra = ["B03","B05","B06","B08","H01","H02","L01","J01","J02"]
	while deck.size() < size: deck.append(extra[deck.size()-12])
	return deck

func capture(name: String) -> void:
	if DisplayServer.get_name() == "headless": return
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/"+name+".png")

func run() -> void:
	for size in range(12,21):
		check(Cards.validate(deck_of(size)) == "","Valid size %d" % size)
	check(Cards.validate(deck_of(21)) != "","Reject 21")
	check(Cards.validate(deck_of(12).slice(0,11)) != "","Reject 11")
	var b = Battle.new()
	check(b.start(deck_of(20),"inspecteur",42) == "","Start large deck")
	check(b.damage_for("B04") == 19,"Large deck damage")
	b.hand = ["B07","H02"]
	check(b.play(0) and b.play(0),"Play two powers")
	check(b.active == ["B07","H02"] and b.hand_limit == 12 and b.strength == 0,"Powers activate, growth delayed")
	b.end_turn()
	check(b.strength == 1 and b.hand.size() == 6,"Next turn strength and draw")
	check(b.damage_for("B04") == 20,"Strength included in scaling attack")
	b.end_turn()
	check(b.strength == 2,"Growth once each turn")
	b.hand.clear()
	b.pile.clear()
	for i in range(20): b.pile.append("B01")
	b.draw_cards(50)
	check(b.hand.size() == 12,"Expanded hand cap")
	check(not b.hand.has("B07") and b.active.has("B07"),"Played copy stays active")
	b.start(deck_of(12),"partenaire",1)
	check(b.active.is_empty() and b.strength == 0 and b.hand_limit == 10 and b.damage_for("B04") == 11,"New combat resets powers and size")
	for size in [12,16,20]:
		b.start(deck_of(size),"inspecteur",12)
		b.hand = ["B06"]
		check(b.play(0) and b.hand.size() == (2 if size == 12 else 3),"Draw threshold")
	b.start(deck_of(20),"inspecteur",12)
	b.hand = ["B07","B07"]
	b.energy = 5
	check(b.play(0) and b.play(0) and b.hand_limit == 14,"Two copies stack")
	b.end_turn()
	check(b.hand.size() == 7,"Two powers draw seven")
	b.hp = 1
	b.block = 0
	b.turn = 2
	b.active.append("H02")
	b.end_turn()
	check(b.outcome == "defeat" and b.strength == 0,"No power triggers after death")
	var c = Calendar.new()
	c.slot = 6
	for id in Cards.catalog(): c.grant(id)
	var plan = c.resize_plan("H02")
	check(plan.error == "" and c.configure(plan.deck,plan.loadout) == "" and c.deck.size() == 13,"Add without replacement")
	plan = c.resize_plan("",12)
	check(plan.error == "" and c.configure(plan.deck,plan.loadout) == "" and c.deck.size() == 12,"Remove to minimum")
	check(c.resize_plan("",0).error != "","Minimum guard")
	plan = c.resize_plan("Q01")
	check(c.configure(plan.deck,plan.loadout) == "" and c.loadout.weapon == "Q01","Add equipment")
	check(c.resize_plan("Q02").error != "","Occupied slot cannot grow deck")
	plan = c.resize_plan("",12)
	check(c.configure(plan.deck,plan.loadout) == "" and c.loadout.weapon == "","Remove equipment clears slot")
	c.configure(deck_of(20),c.loadout)
	var path = "user://orthodox_%d.json" % Time.get_ticks_usec()
	check(Progress.save_progress(c,3,false,false,path,2),"Save twenty cards")
	check(Progress.read_progress(path).get("state",{}).get("deck",[]).size() == 20,"Reload twenty cards")
	var old_path = path+".legacy"
	var old_state = c.snapshot()
	old_state.deck = Cards.PRESETS["Départ"].duplicate()
	var old_file = FileAccess.open(old_path,FileAccess.WRITE)
	var old_text = JSON.stringify({"version":3,"state":old_state,"stage":3,"muted":false,"reduced":false,"completed_duels":2})
	old_file.store_string(old_text)
	old_file.close()
	check(not Progress.read_progress(old_path).is_empty(),"Read v3")
	check(Progress.save_progress(c,3,false,false,old_path,2),"Upgrade v3 to v4")
	check(FileAccess.get_file_as_string(old_path+".before-orthodox") == old_text,"Archive previous version")
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.calendar = c
	game.stage = 3
	game.selected = 0
	game.deck_ui()
	var menu = game.ui.get_child(0)
	check(menu.get_node("Deck").text == "Deck 20 / 20","Dynamic count")
	menu.resize_deck()
	check(c.deck.size() == 19,"UI remove")
	game.deck_tab = "collection"
	game.inspected_card = "B01"
	game.deck_ui()
	game.ui.get_child(0).resize_deck()
	check(c.deck.size() == 20,"UI add")
	game.show_deck_detail("B07")
	await capture("orthodox-deck")
	game.start_combat()
	game.battle.hand = ["B07","H02"]
	game.battle.play(0)
	game.battle.play(0)
	game.battle.end_turn()
	game.combat_ui()
	var strength = game.battle.strength
	game.combat_ui()
	check(game.battle.strength == strength,"Redraw UI does not trigger effects")
	await capture("orthodox-combat")
	game.queue_free()
	await process_frame
	# Reproducible comparisons: same card pool, legal decks, no claim of human balance.
	var results: Array = []
	for size in [12,16,20]:
		var wins = 0
		var turns = 0
		for seed_value in range(100):
			var comparison: Array = ["B01","B02","B03","B04","B05","B06","B07","B08","H01","H02","L01","J01"]
			for i in range(size-12): comparison.append("B%02d" % (i+1))
			b.start(comparison,"inspecteur",seed_value,3)
			var actions = 0
			while b.outcome == "" and actions < 1000:
				var index = b.bot_index()
				if index < 0: b.end_turn()
				else: b.play(index)
				actions += 1
			check(b.outcome != "","No infinite loop")
			check(b.hand.size()+b.pile.size()+b.discard.size()+b.removed.size()+b.active.size() == size,"Conserve all cards including powers")
			wins += int(b.outcome == "victory")
			turns += b.turn+1
		results.append({"size":size,"wins":wins,"samples":100,"mean_turns":turns/100.0})
	var file = FileAccess.open("res://tests/orthodox-results.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(results,"\t"))
	file.close()
	print("ORTHODOX: %d checks, %d failures; %s" % [checks,failures,JSON.stringify(results)])
	quit(1 if failures else 0)
