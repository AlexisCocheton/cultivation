extends SceneTree
# Public card-data contract: validation/UI share the same rules, and cached data stays private.
const Cards = preload("res://game/cards.gd")
const Calendar = preload("res://game/calendar.gd")
const Battle = preload("res://game/battle.gd")
const Balance = preload("res://game/balance.gd")
var checks = 0
var failures = 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1; push_error(label)
func deck_of(size: int) -> Array:
	var deck = Cards.PRESETS["Départ"].duplicate()
	var extra = ["B03","B05","B06","B08","H01","H02","L01","J01"]
	while deck.size() < size: deck.append(extra[deck.size()-12])
	return deck
func fresh(size: int = 12):
	var b = Battle.new()
	check(b.start(deck_of(size),"partenaire",42) == "","Prepare isolated battle")
	return b
func run() -> void:
	var ordinary = Cards.catalog()
	var original = JSON.stringify(ordinary)
	ordinary.B01.damage = 999
	ordinary.B07.effects[0].amount = 999
	ordinary.erase("J02")
	check(JSON.stringify(Cards.catalog()) == original,"Mutating returned catalogue/nested effects cannot contaminate cache")
	var mastered = Cards.catalog({"J":5,"L":5,"H":5})
	check(mastered.J01.damage == Cards.catalog().J01.damage+3,"Mastery modifies only requested rank variant")
	var mastery_copy = JSON.stringify(mastered)
	mastered.J01.name = "corrupted"
	mastered.B07.effects.clear()
	check(JSON.stringify(Cards.catalog({"H":5,"J":5,"L":5})) == mastery_copy,"Equivalent reordered rank dictionaries produce isolated data")
	check(JSON.stringify(Cards.catalog()) == original,"Mastery caller mutations do not affect ordinary cards")
	var tuning = Balance.COMBAT.duplicate(true)
	tuning.cards.H01.block = 15
	var tuned = Cards.catalog({"H":5},tuning)
	check(tuned.H01.block == 18,"Balance overrides combine with mastery once")
	tuned.H01.block = -99
	check(Cards.catalog({"H":5},tuning).H01.block == 18,"Tuned result cannot mutate cached variant")
	tuning.cards.H01.block = 17
	check(Cards.catalog({"H":5},tuning).H01.block == 20,"Modified tuning value selects a new variant")
	check(Cards.catalog().H01.block == 8,"Custom tuning does not contaminate defaults")
	var first = fresh()
	var second = fresh()
	first.character.cards.B01.damage = 99
	first.character.cards.B07.effects[0].amount = 99
	check(second.character.cards.B01.damage == 6 and Cards.catalog().B01.damage == 6,"Character-local card tuning cannot leak into another battle")
	check(second.character.cards.B07.effects[0].amount != 99,"Nested effect data is character-local")
	check(Cards.copy_limit("B01") == 2 and Cards.copy_limit("J01") == 1,"Copy limits come from shared definitions")
	for id in Cards.catalog():
		var excessive = Cards.PRESETS["Départ"].duplicate()
		for i in range(Cards.copy_limit(id)+1): excessive.append(id)
		check(Cards.validate(excessive) != "","Reject excess copies of "+id)
		check(Calendar.equipment_slot(id) == Cards.equipment_slot(id),"Calendar uses shared equipment slot for "+id)
	for slot_name in Cards.EQUIPMENT_GROUPS:
		var group: Array = Cards.EQUIPMENT_GROUPS[slot_name]
		check(group.size() >= 2,"Equipment group can exercise exclusivity")
		check(Cards.equipment_slot(group[0]) == slot_name,"Group maps to declared slot")
		check(Cards.exclusive_conflict([group[0]],group[1]) == group[0],"Conflicting item is reported")
		check(Cards.validate(Cards.PRESETS["Départ"]+[group[0],group[1]]) != "","Validator rejects occupied equipment slot")
	check(Cards.exclusive_conflict(["E01"],"E02") == "E01" and Cards.exclusive_conflict(["E02"],"E01") == "E02","Oath exclusivity is symmetric")
	check(Cards.exclusive_conflict(["B01"],"B02") == "","Ordinary techniques are not exclusive")
	var calendar = Calendar.new()
	for id in Cards.catalog(): calendar.grant(id)
	check(calendar.resize_plan("B01").error != "","Calendar rejects third base copy")
	var weapon_plan = calendar.resize_plan("Q01")
	check(weapon_plan.error == "" and calendar.configure(weapon_plan.deck,weapon_plan.loadout) == "","Calendar equips legal weapon")
	check(calendar.resize_plan("Q02").error != "","Calendar rejects second weapon")
	var replacement = calendar.replacement_plan(0,"Q02")
	check(replacement.error == "" and replacement.loadout.weapon == "Q02" and not replacement.deck.has("Q01"),"Weapon replacement swaps its own slot")
	# UI and rules agree without writing a campaign save.
	var game = load("res://visual/preview.tscn").instantiate()
	root.add_child(game)
	await process_frame
	game.stage = 3
	for id in Cards.catalog(): game.calendar.grant(id)
	game.deck_ui()
	var menu = game.ui.get_child(0)
	check(menu.add_reason("B01") != "","Deck menu rejects third base copy")
	menu.add_card("Q01")
	check(menu.add_reason("Q02") != "","Deck menu respects shared weapon group")
	menu.remove_card("Q01")
	menu.add_card("E01")
	check(menu.add_reason("E02") != "","Deck menu respects shared oath group")
	var limit_visible = false
	for item in menu.get_node("Scroll/Grid").get_children():
		if item.get_node("Card").card_id == "B01": limit_visible = item.get_node("Copies").text == "2/2"
	check(limit_visible,"UI copy denominator matches shared rule")
	game.queue_free()
	await create_timer(0.5).timeout
	# New IDs reuse effects unchanged: no ID dispatch in runtime resolution.
	var b = fresh(16)
	var invented = b.cards.B08.duplicate(true)
	invented.name = "Technique de test"
	invented.exhaust = false
	invented.persistent = true
	invented.effects.append_array(b.cards.H02.effects.duplicate(true))
	b.character.cards["TEST_NEW"] = invented
	b.hand = ["TEST_NEW"]
	check(b.target_kind(0) == "self" and b.play(0),"New ID runs composed existing effects")
	check(b.bonus == 2 and b.active.has("TEST_NEW"),"New ID grants its immediate bonus and becomes persistent")
	b.end_turn()
	check(b.strength == 1,"New ID persistent strength triggers without known-card ID")
	check(Cards.describe_data(invented).contains("+2") and Cards.describe_data(invented).contains("Force"),"Description uses effect data for new ID")
	b = fresh(16)
	b.character.cards["TEST_READ"] = b.cards.B06.duplicate(true)
	b.hand = ["TEST_READ"]
	b.energy = 0
	check(b.character.card_cost("TEST_READ") == 0 and b.can_play(0) and b.play(0),"Cost-discount effect works on a new ID")
	check(b.energy == 0 and b.hand.size() == 2,"Discount card always draws two for zero qi at 16")
	b = fresh()
	b.character.cards["TEST_EXPOSE"] = b.cards.J02.duplicate(true)
	b.hand = ["TEST_EXPOSE","B01"]
	check(b.target_kind(0) == "enemy" and b.play(0) and b.exposed,"Expose effect and enemy targeting work on new ID")
	check(b.play(0) and b.enemy_hp == b.enemy_max-9,"New expose effect modifies later damage")
	b = fresh()
	b.character.cards["TEST_POWER"] = b.cards.B07.duplicate(true)
	b.hand = ["TEST_POWER"]
	check(b.play(0) and b.hand_limit == 12,"New power expands hand")
	b.end_turn()
	check(b.hand.size() == 6,"New power draws extra next turn")
	for size in [12,15,16,20]:
		b = fresh(size)
		b.hand = ["B06"]
		b.energy = 0
		check(b.can_play(0) == (size >= 16),"B06 free threshold %d" % size)
		if size < 16: b.energy = 1
		check(b.play(0) and b.energy == 0 and b.hand.size() == 2,"B06 cost and draw remain coherent at %d" % size)
	print("Card data rules: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
