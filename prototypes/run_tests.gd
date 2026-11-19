extends SceneTree

const Calendar = preload("res://prototypes/calendar.gd")
const Battle = preload("res://prototypes/battle.gd")
const Cards = preload("res://prototypes/cards.gd")
var checks = 0
var failures: Array = []
var report = {"rules":"etape4-v0.2","calendar":[],"battles":[],"campaigns":[],"limitations":["Agent glouton fixe, pas de test humain.","Les duels de référence isolent les styles ; les simulations de campagne utilisent uniquement les cartes acquises.","Pas de mesure de durée réelle ni de qualité narrative."]}
const ROUTES = {
	"reconstruction":"M01 L J H work kitchen M02 L J H S01 work fight hall workshop M03 L J S02 S03 S04 S05 fight S06 M04 fight work fight workshop L work hall work fight fight kitchen M05 rest rest rest rest M06",
	"equipement":"M01 J H L work kitchen M02 J H L S01 work fight hall workshop M03 J H S02 S03 S04 S05 fight S06 M04 fight work fight buy:Q01 J work buy:Q03 work fight fight work M05 rest rest rest rest M06"}

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures.append(message)
		push_error(message)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	for route_name in ROUTES:
		for victories in [false,true]:
			var c = Calendar.new()
			c.interest = route_name == "reconstruction"
			for action in ROUTES[route_name].split(" "):
				var won: bool = victories or action in ["M01","M06"]
				check(c.act(action,won) == "","Route %s slot %d action %s" % [route_name,c.slot,action])
				check(c.supplies >= 0,"Nonnegative reserves")
			check(c.complete and c.slot == 42,"Campaign ends at slot 42")
			check(c.act("work") != "","No day 15")
			check(c.before_final.slot == 41,"Final checkpoint before event")
			check(c.before_preparation.slot == 36,"Preparation checkpoint")
			report.calendar.append({"route":route_name,"optional_victories":victories,"periods":c.slot,"reserves":c.supplies,"ranks":c.ranks.duplicate(),"repairs":c.repairs(),"events":c.event_count(),"cards":c.collection.size(),"romance":c.romance})
			var checkpoint = c.before_final.duplicate(true)
			c.restore(checkpoint)
			check(c.act("M06",false) != "" and c.slot == 41,"Final failure does not advance")
			check(c.before_final == checkpoint,"Failure preserves checkpoint")
			c.restore(checkpoint)
			check(c.act("M06",true) == "" and c.complete,"Final retry succeeds")
	var c = Calendar.new()
	var before = c.snapshot()
	check(c.act("work") != "" and c.snapshot() == before,"Rejected action is atomic")
	c.act("M01")
	c.act("L")
	check(c.reason("L") != "","One rank per day")
	c.act("rest")
	check(c.reason("L") != "","Rank 2 unavailable before J3")
	c.slot = 6
	check(c.act("M02",true,"wrong") != "","Invalid choice rejected")
	c.act("M02",true,"E02")
	check(c.collection.has("E02") and not c.collection.has("E01"),"Exclusive oath")
	c.supplies = 0
	before = c.snapshot()
	check(c.act("hall") != "" and c.snapshot() == before,"No spending without funds")
	c.slot = 10
	c.act("S01")
	check(c.reason("S01") != "","Unique event cannot repeat")
	c.slot = 8
	check(c.reason("fight") != "","No night training")
	c.slot = 10
	c.optional_wins = 3
	var amount = c.supplies
	c.act("fight",true)
	check(c.supplies == amount,"Optional reward cap")
	c.save_lab("user://lab-test.json")
	var disk = JSON.parse_string(FileAccess.get_file_as_string("user://lab-test.json"))
	var loaded = Calendar.new()
	loaded.restore(disk.state)
	check(loaded.snapshot() == c.snapshot(),"Calendar JSON round trip")
	test_battle_rules()
	test_owned_decks()
	await test_ui()
	for name in Cards.PRESETS:
		check(Cards.validate(Cards.PRESETS[name]) == "","Preset legal: "+name)
		for repairs in [0,3,6]:
			simulate(name,"inspecteur",repairs,100)
		for profile in ["partenaire","offensif","defensif"]:
			simulate(name,profile,0,50)
		for pressure in [2,4]:
			simulate(name,"inspecteur",3,100,pressure)
	for route_name in ROUTES:
		for name in ["Jun · offensif","Shen · défensif","Lian · enchaînements"]:
			simulate_campaign(route_name,name,50)
	report["checks"] = checks
	report["failures"] = failures
	report["passed"] = failures.is_empty()
	var file = FileAccess.open("res://prototypes/results.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(report,"\t"))
	print("STAGE 4 CHECKS: ",checks,"; FAILURES: ",failures.size())
	for row in report.battles:
		if row.profile == "inspecteur": print(row)
	quit(0 if failures.is_empty() else 1)

func fresh() -> RefCounted:
	var b = Battle.new()
	b.tuning = {} # Stable arithmetic examples for the original mechanics.
	b.start(Cards.PRESETS["Départ"],"inspecteur",42)
	return b

func test_owned_decks() -> void:
	var c = Calendar.new()
	var old_state = c.snapshot()
	var invalid = c.deck.duplicate()
	invalid[0] = "J03"
	check(c.configure(invalid,c.loadout) != "" and c.snapshot() == old_state,"Reject locked card atomically")
	invalid = c.deck.duplicate()
	invalid.pop_back()
	check(c.configure(invalid,c.loadout) != "","Reject eleven-card deck")
	c.grant("Q01")
	invalid = c.deck.duplicate()
	invalid[0] = "Q01"
	check(c.configure(invalid,c.loadout) != "","Owned equipment must occupy a slot")
	var slots = {"weapon":"Q01","talisman":"","item":""}
	check(c.configure(invalid,slots) == "","Equip owned weapon and its card")
	check(c.slot == 0 and c.supplies == 6,"Deck edits consume no time or reserves")
	check(c.configure(invalid,{"weapon":"Q02","talisman":"","item":""}) != "","Reject unowned weapon")
	check(c.configure(Cards.PRESETS["Départ"],slots) != "","Reject missing equipped card")
	c.grant("O01")
	c.grant("L01")
	c.grant("L02")
	c.grant("E01")
	for name in Cards.PRESETS:
		var equipment = c.suggested_loadout(Cards.PRESETS[name])
		equipment.item = "O01"
		var candidate = c.suggested_deck(Cards.PRESETS[name],equipment)
		check(c.configure(candidate,equipment) == "","Suggestion contains acquired cards and proper slots: "+name)
	var snapshot = c.snapshot()
	c.save_lab("user://deck-test.json")
	var disk = JSON.parse_string(FileAccess.get_file_as_string("user://deck-test.json"))
	var loaded = Calendar.new()
	loaded.restore(disk.state)
	check(loaded.deck == c.deck and loaded.loadout == c.loadout,"Deck and equipment survive disk save")
	c.configure(Cards.PRESETS["Départ"],{"weapon":"","talisman":"","item":""})
	c.restore(snapshot)
	check(c.deck == snapshot.deck and c.loadout == snapshot.loadout,"Checkpoint restores deck and slots")
	var old_save = snapshot.duplicate(true)
	old_save.erase("deck")
	old_save.erase("loadout")
	c.restore(old_save)
	check(c.validate_deck(c.deck,c.loadout) == "" and c.deck == Cards.PRESETS["Départ"],"v0.1 save gets legal starter deck")
	c.slot = 41
	c.act("M06",false)
	var checkpoint = c.before_final.duplicate(true)
	c.deck[0] = "J03"
	check(c.reason("M06") != "","Final blocks injected unavailable card")
	c.restore(checkpoint)
	check(c.validate_deck(c.deck,c.loadout) == "","Final retry restores legal deck")
	var b = Battle.new()
	b.start(Cards.PRESETS["Lian · enchaînements"],"inspecteur",42)
	check(b.intent().damage == 10,"v0.2 boss initial pressure")
	b.turn = 3
	check(b.intent().damage == 12,"v0.2 telegraphed pressure rises at turn four")
	b.played = 2
	check(b.damage_for("L01") == 12 and b.damage_for("L03") == 18,"v0.2 Lian combos")
	check(b.cards.H01.block == 8 and b.cards.H03.block == 10,"v0.2 Shen guard")

func test_ui() -> void:
	var lab = load("res://prototypes/lab.tscn").instantiate()
	root.add_child(lab)
	await process_frame
	var initial = lab.calendar.snapshot()
	lab.open_editor()
	lab.remove_draft(0)
	lab.commit_editor()
	check(lab.editing and lab.calendar.snapshot() == initial,"UI rejects incomplete draft without mutation")
	lab.add_draft("J03")
	check(not lab.draft.has("J03"),"UI cannot add locked card")
	lab.suggest("Jun · offensif")
	lab.commit_editor()
	check(not lab.editing and lab.calendar.validate_deck(lab.calendar.deck,lab.calendar.loadout) == "","UI recommendation filters collection")
	lab.selected_deck = "Jun · offensif"
	lab.pressure = 4
	lab.begin_battle("M01","partenaire")
	var actual: Array = lab.battle.hand + lab.battle.pile
	actual.sort()
	var expected: Array = lab.calendar.deck.duplicate()
	expected.sort()
	check(actual == expected and lab.battle.boss_pressure == 0,"Campaign ignores unlocked sandbox preset and pressure")
	lab.battle = null
	lab.calendar.grant("Q01")
	lab.open_editor()
	lab.change_slot(1,"weapon",["","Q01"])
	check(lab.draft.has("Q01") and lab.draft.size() == 13,"Equipment insertion needs an explicit replacement")
	lab.remove_draft(0)
	lab.commit_editor()
	check(lab.calendar.loadout.weapon == "Q01" and lab.calendar.deck.has("Q01"),"UI commits equipped card")
	lab.queue_free()
	await process_frame

func simulate_campaign(route_name: String, style: String, samples: int) -> void:
	var wins = 0
	var intermediate_wins = 0
	var remaining = 0
	var final_sizes: Array = []
	var battle_count = 0
	for seed_value in range(samples):
		var c = Calendar.new()
		c.interest = route_name == "reconstruction"
		for action in ROUTES[route_name].split(" "):
			var won = true
			if action in ["M01","M03","M04","M06","S02","S05","fight"]:
				var equipment = c.suggested_loadout(Cards.PRESETS[style])
				if c.collection.has("O01"): equipment.item = "O01"
				var candidate = c.suggested_deck(Cards.PRESETS[style],equipment)
				check(c.configure(candidate,equipment) == "","Campaign deck is acquired")
				var foe = "partenaire"
				if action in ["M03","S05"]: foe = "offensif"
				if action == "S02": foe = "defensif"
				if action == "M06": foe = "inspecteur"
				var b = Battle.new()
				b.start(c.deck,foe,seed_value*100+c.slot,c.repairs(),c.buildings.kitchen==2)
				if action == "M01": b.enemy_hp = 18; b.enemy_max = 18
				if action == "M04": b.enemy_hp = 40; b.enemy_max = 40
				var safety = 0
				while b.outcome == "" and b.turn < 50 and safety < 1000:
					var index = b.bot_index()
					if index >= 0: b.play(index)
					else: b.end_turn()
					safety += 1
				check(b.outcome != "","Campaign fight ends")
				battle_count += 1
				won = b.outcome == "victory"
				if action == "M06":
					wins += int(won)
					final_sizes.append(c.collection.size())
				else: intermediate_wins += int(won)
			var error = c.act(action,won,"E02" if style.begins_with("Shen") else "E01")
			check(error == "" or (action == "M06" and not won),"Campaign action remains feasible: "+action)
		remaining += c.supplies
	report.campaigns.append({"route":route_name,"style":style,"samples":samples,"final_wins":wins,"intermediate_wins":intermediate_wins,"battles":battle_count,"mean_reserves":remaining/float(samples),"min_collection_at_final":final_sizes.min(),"max_collection_at_final":final_sizes.max(),"meal":route_name=="reconstruction","seeds":"combat_seed = campaign_seed * 100 + period_index; campaign_seed 0..49"})

func test_battle_rules() -> void:
	check(Cards.catalog().size() == 30,"Exactly thirty cards")
	check(Cards.validate(["B01"]) != "","Wrong deck size rejected")
	var invalid = Cards.PRESETS["Départ"].duplicate()
	invalid[0] = "unknown"
	check(Cards.validate(invalid) != "","Unknown card rejected")
	var b = fresh()
	b.hand = ["J02","B08","B01","B02"]
	b.pile.clear()
	b.discard.clear()
	b.play(0)
	b.play(0)
	b.play(0)
	b.play(0)
	check(b.enemy_hp == 72 and b.block == 5 and b.energy == 0,"Exposed bonus order")
	b.end_turn()
	check(b.hp == 42 and b.energy == 3 and b.block == 0 and not b.exposed,"Enemy damage and reset")
	b = fresh()
	b.hand = ["B06"]
	b.pile.clear()
	b.discard.clear()
	b.play(0)
	check(b.hand.is_empty() and b.discard == ["B06"],"Card cannot draw itself during resolution")
	b = fresh()
	b.hand = []
	for i in range(10): b.hand.append("B01")
	var pile_size = b.pile.size()
	b.draw_cards(2)
	check(b.hand.size() == 10 and b.pile.size() == pile_size,"Hand cap does not lose cards")
	b = fresh()
	b.hand = ["B03","Q04","O01","O02"]
	b.hp = 44
	b.play(0)
	b.play(0)
	b.play(0)
	b.play(0)
	check(b.removed.size() == 4 and b.hp == 45 and b.energy == 4,"Exhaust healing qi")
	b.start(Cards.PRESETS["Départ"],"inspecteur",42)
	check(b.removed.is_empty() and b.hp == 45,"New fight resets state")
	b.hand = ["J03"]
	b.hp = 2
	b.enemy_hp = 1
	b.play(0)
	check(b.outcome == "defeat","Mutual death is defeat")
	check(not b.play(0),"Cannot act after fight")
	b = fresh()
	b.hand = ["L01","B01","B01"]
	b.energy = 0
	check(not b.play(0) and b.hand.size() == 3,"Insufficient qi is atomic")
	b.energy = 3
	b.play(1)
	b.play(1)
	b.play(0)
	check(b.enemy_hp == 62,"Combo checks previous two cards")
	b = fresh()
	b.enemy_hp = 40
	check(b.intent().damage == 8,"Phase does not alter already announced intent")
	b.end_turn()
	check(b.hp == 37 and b.phase == 1 and b.intent().damage == 7,"Boss phase changes next turn")
	b = fresh()
	b.turn = 1
	b.end_turn()
	check(b.enemy_block == 8,"Enemy block persists into player turn")
	b.hand = ["B01"]
	var old_hp = b.enemy_hp
	b.play(0)
	check(b.enemy_hp == old_hp and b.enemy_block == 2,"Enemy block absorbs damage")
	b = fresh()
	b.start(Cards.PRESETS["Départ"],"inspecteur",42,6,true)
	check(b.enemy_max == 66 and b.max_hp == 50,"Building preparation bonuses")
	for id in Cards.catalog():
		b = fresh()
		b.hand = [id]
		check(b.play(0),"Every card executes: "+id)
	var a = fresh()
	b = fresh()
	check(a.hand == b.hand and a.pile == b.pile,"Seeded shuffle reproducible")

func simulate(name: String, profile: String, repairs: int, samples: int, pressure: int = 0) -> void:
	var wins = 0
	var turns = 0
	var health = 0
	var timeouts = 0
	for seed_value in range(samples):
		var b = Battle.new()
		b.start(Cards.PRESETS[name],profile,seed_value,repairs,false)
		b.boss_pressure = pressure
		while b.outcome == "" and b.turn < 50:
			var actions = 0
			while b.outcome == "" and actions < 50:
				var index = b.bot_index()
				if index < 0: break
				b.play(index)
				actions += 1
			check(actions < 50,"No infinite card loop")
			b.end_turn()
		if b.outcome == "victory": wins += 1
		if b.outcome == "": timeouts += 1
		turns += b.turn+1
		health += b.hp
		check(b.hand.size()+b.pile.size()+b.discard.size()+b.removed.size() == 12,"Card conservation")
	report.battles.append({"deck":name,"profile":profile,"repairs":repairs,"samples":samples,"wins":wins,"win_rate":float(wins)/samples,"mean_turns":float(turns)/samples,"mean_hp_all_runs":float(health)/samples,"timeouts":timeouts,"seed_first":0,"seed_last":samples-1,"meal":false,"experimental_attack_bonus":pressure})
