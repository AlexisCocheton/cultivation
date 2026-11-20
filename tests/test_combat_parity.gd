extends SceneTree
# Frozen behavioural traces captured before the encounter-engine migration.
# Never refresh this fixture as a shortcut for fixing a regression.
const Solo = preload("res://game/battle.gd")
const Team = preload("res://game/team_battle.gd")
const Cards = preload("res://game/cards.gd")
const FIXTURE = "res://tests/combat_parity_baseline.json"
var traces: Dictionary = {}
var steps = 0
var key = ""
func _initialize() -> void: call_deferred("run")
func core_state(b) -> Dictionary:
	return {"hp":b.hp,"max_hp":b.max_hp,"guard":b.block,"energy":b.energy,"bonus":b.bonus,"played":b.played,"strength":b.strength,"turn":b.turn,"hand":b.hand.duplicate(),"pile":b.pile.duplicate(),"discard":b.discard.duplicate(),"removed":b.removed.duplicate(),"active":b.active.duplicate(),"limit":b.hand_limit,"initial_size":b.initial_deck_size}
func record(action: String, state: Dictionary) -> void:
	traces[key].append([action,JSON.stringify(state).sha256_text()])
	steps += 1
func record_solo(action: String, b) -> void:
	var state = core_state(b)
	state.merge({"enemy_hp":b.enemy_hp,"enemy_max":b.enemy_max,"enemy_guard":b.enemy_block,"exposed":b.exposed,"outcome":b.outcome,"intent":b.intent(),"phase":b.phase})
	record(action,state)
func record_team(action: String, b) -> void:
	var cores: Array = []
	for member in b.cores: cores.append(core_state(member))
	record(action,{"units":b.units.duplicate(true),"cores":cores,"actor":b.actor,"finished":b.finished.duplicate(),"queue":b.queue.duplicate(true),"outcome":b.outcome,"coated":b.coated,"pill_used":b.pill_used,"pill_target":b.pill_target,"resolving":b.resolving,"antidotes":b.antidotes,"events":b.events.duplicate(true),"guard_received":b.guard_received.duplicate()})
func run() -> void:
	for rank in [0,5]:
		for seed_value in [1,7,42]:
			for profile in ["partenaire","visiteuse","offensif","defensif","inspecteur"]:
				for deck_name in ["Jun · offensif","Shen · défensif","Lian · enchaînements"]:
					key = "solo/%s/%s/%d/%d" % [profile,deck_name,seed_value,rank]
					traces[key] = []
					var b = Solo.new()
					b.relation_ranks = {"J":rank,"L":rank,"H":rank}
					assert(b.start(Cards.PRESETS[deck_name],profile,seed_value,2,true,2) == "")
					record_solo("start",b)
					for turn_index in range(20):
						if b.outcome != "": break
						for play_index in range(30):
							if b.outcome != "": break
							var chosen = b.bot_index()
							if chosen < 0: break
							var card: String = b.hand[chosen]
							assert(b.play(chosen))
							record_solo("play:"+card,b)
						if b.outcome == "": b.end_turn(); record_solo("end",b)
	for rank in [0,5]:
		for seed_value in [1,7,42]:
			for party in [["J","L"],["H","J"],["L","H"]]:
				for showcase in [false,true]:
					key = "team/%s/%d/%d/%s" % ["".join(party),seed_value,rank,str(showcase)]
					traces[key] = []
					var b = Team.new()
					b.party = party.duplicate()
					b.relation_ranks = {"J":rank,"L":rank,"H":rank}
					b.antidotes_initial = 1
					assert(b.start(seed_value,Team.DECK,showcase) == "")
					record_team("start",b)
					for turn_index in range(20):
						if b.outcome != "": break
						while not b.resolving and b.outcome == "":
							for friend in b.living(0):
								if b.units[friend].poison > 0 and b.use_antidote(friend): record_team("antidote:%d" % friend,b)
							for play_index in range(30):
								if b.outcome != "": break
								var chosen = -1
								var target = b.actor
								var best = -1.0
								for i in range(b.core.hand.size()):
									var c: Dictionary = b.core.cards[b.core.hand[i]]
									if c.cost > b.core.energy: continue
									var candidate = b.actor
									if b.target_kind(i) == "enemy":
										candidate = b.living(1)[0]
										for foe in b.living(1):
											if b.units[foe].hp < b.units[candidate].hp: candidate = foe
									elif b.target_kind(i) == "ally": candidate = b.living(0)[(b.actor+1)%b.living(0).size()]
									var score: float = (c.damage+c.draw*3+c.block*0.6)/maxf(1,c.cost)
									if score > best: best = score; chosen = i; target = candidate
								if chosen < 0: break
								var card: String = b.core.hand[chosen]
								assert(b.play(chosen,target))
								record_team("play:%s:%d" % [card,target],b)
							if b.outcome == "": b.end_actor_turn(); record_team("end_actor",b)
						while not b.queue.is_empty() and b.outcome == "":
							b.resolve_next()
							record_team("resolve",b)
						b.finish_round()
						record_team("round",b)
	if OS.get_cmdline_user_args().has("--capture-baseline"):
		if FileAccess.file_exists(FIXTURE): push_error("Fixture already exists; refusing overwrite"); quit(1); return
		var file = FileAccess.open(FIXTURE,FileAccess.WRITE)
		file.store_string(JSON.stringify({"cases":traces.size(),"steps":steps,"traces":traces},"  "))
		file.close()
		print("Captured immutable parity fixture: %d cases / %d states" % [traces.size(),steps])
		quit(); return
	var baseline = JSON.parse_string(FileAccess.get_file_as_string(FIXTURE))
	var failures = 0
	if traces.size() != int(baseline.cases):
		failures += 1
		push_error("Parity scenario count changed")
	for case_name in traces:
		var expected: Array = baseline.traces.get(case_name,[])
		var actual: Array = traces[case_name]
		if expected != actual:
			failures += 1
			var first = 0
			while first < mini(expected.size(),actual.size()) and expected[first] == actual[first]: first += 1
			push_error("Parity drift %s step %d: expected %s, actual %s" % [case_name,first,str(expected[first] if first < expected.size() else "end"),str(actual[first] if first < actual.size() else "end")])
	print("Combat parity: %d cases, %d state transitions, %d failures" % [traces.size(),steps,failures])
	quit(1 if failures else 0)
