extends SceneTree
# Direct behavioural contract of the parameterized engine, independent of any HUD.
const Cards = preload("res://game/cards.gd")
var Character
var Team
var Encounter
var failures = 0
var checks = 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok: failures += 1; push_error(label)
func formation(count: int, prefix: String, seed_base: int = 41):
	var team = Team.new()
	for i in range(count):
		var member = Character.new(prefix+str(i),50,i)
		check(member.prepare_deck(Cards.PRESETS["Départ"],seed_base+i,3,5) == "","Prepare deck")
		check(team.add(member),"Add distinct character")
	return team
func encounter(allied_count: int, enemy_count: int, config: Dictionary = {}):
	var e = Encounter.new()
	check(e.configure(formation(allied_count,"A"),formation(enemy_count,"E",90),config) == "","Configure %dv%d" % [allied_count,enemy_count])
	return e
func snapshot(e) -> String:
	var players: Array = []
	for c in e.allies.members:
		players.append({"state":c.state.duplicate(true),"hand":c.deck.hand.duplicate(),"pile":c.deck.pile.duplicate(),"discard":c.deck.discard.duplicate(),"removed":c.deck.removed.duplicate(),"active":c.deck.active.duplicate(),"energy":c.energy,"bonus":c.bonus,"strength":c.strength,"played":c.played})
	return JSON.stringify({"units":e.units,"players":players,"actor":e.actor,"turn":e.turn,"finished":e.finished,"queue":e.queue,"outcome":e.outcome})
func resolve_round(e) -> void:
	for attempt in range(4):
		if e.resolving or e.outcome != "": break
		e.end_actor_turn()
	check(e.resolving or e.outcome != "","All living actors complete their turns")
	for attempt in range(20):
		if e.queue.is_empty() or e.outcome != "": break
		e.resolve_next()
	e.finish_round()
func run() -> void:
	Character = load("res://game/combat/character_state.gd")
	Team = load("res://game/combat/team_state.gd")
	Encounter = load("res://game/combat/encounter.gd")
	if Encounter == null: quit(1); return
	for dimensions in [[1,1],[2,3],[3,1],[3,3]]:
		var e = encounter(dimensions[0],dimensions[1])
		check(e.units.size() == dimensions[0]+dimensions[1],"No fixed six-character array")
		check(e.living(0).size() == dimensions[0] and e.living(1).size() == dimensions[1],"Dynamic team boundaries")
		var c = e.allies.members[0]
		c.deck.hand = ["B01","B02"]
		c.energy = 3
		var before = snapshot(e)
		check(not e.play(0,0,0) and snapshot(e) == before,"Attack cannot target own team; no mutation")
		check(not e.play(0,1,dimensions[0]) and snapshot(e) == before,"Guard cannot target enemy; no mutation")
		check(not e.play(-1,0,dimensions[0]) and snapshot(e) == before,"Negative actor rejected")
		check(not e.play(99,0,dimensions[0]) and snapshot(e) == before,"Out-of-range actor rejected")
		check(not e.play(0,0,-1) and snapshot(e) == before,"Negative target rejected")
		check(not e.play(0,0,99) and snapshot(e) == before,"Out-of-range target rejected")
		check(e.play(0,0,dimensions[0]) and e.units[dimensions[0]].hp == 44,"Attack uses dynamic enemy boundary")
		check(e.play(0,0,0) and e.units[0].guard == 5,"Self guard valid in every formation")
		resolve_round(e)
		check(e.turn == 1 and c.energy == 3 and c.deck.hand.size() == 5,"One round refills configured qi and hand")
		check(e.units[0].guard == 0,"Ally guard expires after enemy phase")
		before = snapshot(e)
		e.finish_round()
		check(snapshot(e) == before,"Second finish_round is a no-op")
	# Explicit targeting and status expiry share the same path as generic cards.
	var e = encounter(2,3)
	var c = e.allies.members[0]
	c.deck.hand = ["J02","B01"]
	c.energy = 3
	check(e.target_kind(0,0) == "enemy","J02 exposes an enemy, not the caster")
	check(e.play(0,0,2) and e.units[2].exposed,"J02 applied to selected target")
	check(e.play(0,0,2) and e.units[2].hp == 41,"Exposed multiplies subsequent damage")
	resolve_round(e)
	check(not e.units[2].exposed,"Exposed expires at next round")
	# A persistent guard can protect someone else, while the persistent effect stays on caster.
	e = encounter(2,3)
	c = e.allies.members[0]
	c.deck.hand = ["B07"]
	c.energy = 3
	check(e.play(0,0,1),"Persistent guard targets another living ally")
	check(e.units[1].guard == 11 and e.units[0].guard == 0,"Guard goes to selected ally only")
	check(c.deck.active == ["B07"] and e.allies.members[1].deck.active.is_empty(),"Persistent effect stays on caster")
	resolve_round(e)
	check(c.deck.hand.size() == 6 and e.allies.members[1].deck.hand.size() == 5,"Persistent draw benefits caster only")
	e = encounter(2,3)
	c = e.allies.members[0]
	c.deck.hand = ["J01"]
	check(e.target_kind(0,0) == "enemy" and e.play(0,0,2),"Mixed attack/guard targets enemy")
	check(e.units[0].guard == 3 and e.units[1].guard == 0,"Mixed attack guards caster only")
	# Team sizes and identities are validated before a battle can run.
	var invalid = Encounter.new()
	check(invalid.configure(Team.new(),formation(1,"E")) != "","Empty allies rejected")
	check(invalid.configure(formation(1,"A"),Team.new()) != "","Empty enemies rejected")
	var oversized = formation(3,"A")
	oversized.members.append(Character.new("Extra"))
	check(invalid.configure(oversized,formation(1,"E")) != "","Overfilled team rejected")
	var shared = formation(1,"A")
	var enemies = Team.new()
	enemies.add(shared.members[0])
	check(invalid.configure(shared,enemies) != "","Same character cannot be on both teams")
	var duplicate = formation(1,"A")
	duplicate.members.append(duplicate.members[0])
	check(invalid.configure(duplicate,formation(1,"E")) != "","Same character cannot occupy two slots")
	# Invalid cost and locked phases cannot consume a card or its resources.
	e = encounter(2,3)
	c = e.allies.members[0]
	c.deck.hand = ["B01"]
	c.energy = 0
	var unchanged = snapshot(e)
	check(not e.can_play(0,0) and not e.play(0,0,2) and snapshot(e) == unchanged,"Insufficient qi is transactional")
	c.energy = 3
	e.end_actor_turn()
	unchanged = snapshot(e)
	check(not e.play(0,0,2) and snapshot(e) == unchanged,"Finished actor cannot play again")
	e.end_actor_turn()
	unchanged = snapshot(e)
	check(not e.play(1,0,2) and snapshot(e) == unchanged,"No card during enemy phase")
	# A companion's self-damage KO must not strand the turn on a dead actor.
	e = encounter(3,1)
	e.end_actor_turn()
	check(e.actor == 1,"Second companion can take their turn")
	c = e.allies.members[1]
	c.state.hp = 2
	c.deck.hand = ["J03"]
	c.energy = 3
	check(e.play(1,0,3) and c.state.hp == 0 and e.outcome == "","J03 companion KO does not defeat living leader")
	e.end_actor_turn()
	check(e.actor == 2 and not e.resolving,"KO actor can finish so next living ally plays")
	# Defeat and victory are configured independently of formation size.
	e = encounter(2,3,{"defeat_on_leader":false})
	e.units[0].hp = 0
	e.check_outcome()
	check(e.outcome == "","Leader KO alone does not lose a non-leader encounter")
	e.end_actor_turn()
	check(e.actor == 1 and e.can_select_actor(1),"Remaining living member can continue")
	e.units[1].hp = 0
	e.check_outcome()
	check(e.outcome == "defeat","No living allies loses even without leader rule")
	e = encounter(2,3)
	e.units[0].hp = 0
	e.check_outcome()
	check(e.outcome == "defeat","Leader defeat is preserved by default")
	e = encounter(2,3)
	for foe in e.enemies.members: foe.state.hp = 0
	e.check_outcome()
	check(e.outcome == "victory","All enemies KO wins")
	unchanged = snapshot(e)
	check(not e.play(0,0,2) and not e.begin_resolution() and snapshot(e) == unchanged,"Victory freezes further actions")
	# Rejected reconfiguration cannot overwrite an active encounter.
	e = encounter(2,3)
	unchanged = snapshot(e)
	check(e.configure(formation(1,"A"),formation(1,"E"),{"qi":-1}) != "" and snapshot(e) == unchanged,"Negative qi rejected atomically")
	check(e.configure(formation(1,"A"),formation(1,"E"),{"draw":-1}) != "" and snapshot(e) == unchanged,"Negative draw rejected atomically")
	check(e.configure(formation(1,"A"),formation(1,"E"),{"defeat_on_leader":"yes"}) != "" and snapshot(e) == unchanged,"Invalid boolean rejected atomically")
	check(e.configure(formation(1,"A"),formation(1,"E"),{},RefCounted.new()) != "" and snapshot(e) == unchanged,"Incomplete policy rejected atomically")
	# Configurable resource values do not silently fall back to duel values.
	e = encounter(2,3,{"qi":2,"draw":4})
	resolve_round(e)
	check(e.allies.members[0].energy == 2 and e.allies.members[0].deck.hand.size() == 4,"Team configuration controls refill")
	# Identical dictionaries are still distinct combatants for emitted events.
	e = encounter(2,1)
	e.units[1].name = e.units[0].name
	e.units[1].appearance = e.units[0].appearance
	for i in [0,1]: e.units[i].poison = 2
	e.resolving = true
	e.queue.clear()
	e.finish_round()
	var poison_targets: Array = []
	for event in e.events:
		if event.kind == "poison": poison_targets.append(event.target)
	check(poison_targets == [0,1],"Poison events preserve identity even when unit values match")
	# Restart must reset actor before preparing the tutorial hand, not afterwards.
	var Territory = load("res://game/team_battle.gd")
	for seed_value in [1,7,42]:
		for old_actor in [1,2]:
			var fresh = Territory.new()
			var reused = Territory.new()
			fresh.start(seed_value,Territory.DECK,true)
			reused.start(123,Territory.DECK,true)
			check(reused.select_actor(old_actor),"Select old actor before restart")
			reused.start(seed_value,Territory.DECK,true)
			check(reused.actor == 0,"Restart returns control to recruit")
			for i in range(3):
				check(reused.cores[i].hand == fresh.cores[i].hand and reused.cores[i].pile == fresh.cores[i].pile,"Restart opening piles match fresh battle for member %d" % i)
	var first = encounter(2,3)
	var second = encounter(2,3)
	check(snapshot(first) == snapshot(second),"Same seed and configuration reproduce opening state")
	print("Encounter engine: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
