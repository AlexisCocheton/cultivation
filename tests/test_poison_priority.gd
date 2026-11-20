extends SceneTree
const Team = preload("res://game/team_battle.gd")
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var decks = {"laboratoire":Team.DECK}
	var saved = preload("res://game/campaign/progress.gd").read_progress("res://tools/play-user/Godot/app_userdata/Les Cendres du Prunier/sequence_visuelle_v2.json")
	if not saved.is_empty(): decks["sauvegarde_actuelle"] = saved.state.deck
	var results: Array = []
	for deck_name in decks:
		for order in [[4,3,5],[3,5,4]]:
			var wins = 0
			var casualties = 0
			var rounds = 0
			var poison_hits = 0
			for seed_value in range(100):
				var b = Team.new()
				b.start(seed_value,decks[deck_name],false)
				for turn in range(40):
					if b.outcome != "": break
					for member in b.living(0):
						if b.outcome != "": break
						b.select_actor(member)
						for action in range(30):
							if b.outcome != "": break
							var enemy = -1
							for id in order:
								if b.units[id].hp > 0: enemy = id; break
							var best = -1.0
							var chosen = -1
							var target = member
							for index in range(b.core.hand.size()):
								var id: String = b.core.hand[index]
								var card: Dictionary = b.core.cards[id]
								if card.cost > b.core.energy: continue
								var candidate = member
								if b.target_kind(index) == "enemy": candidate = enemy
								var score = float(card.damage+card.draw*3+card.block*0.6)/maxf(1,card.cost)
								if id == "J02": score += 3 if b.core.energy > 1 else 0
								if score > best: best = score; chosen = index; target = candidate
							if chosen < 0: break
							assert(b.play(chosen,target))
						if b.outcome == "": b.end_actor_turn()
					while not b.queue.is_empty() and b.outcome == "":
						var resolved: Dictionary = b.resolve_next()
						if resolved.kind == "poison" and not resolved.cancelled: poison_hits += 1
					b.finish_round()
				assert(b.outcome != "")
				wins += int(b.outcome == "victory")
				casualties += int(b.living(0).size() < 3)
				rounds += b.core.turn+1
			results.append({"deck":deck_name,"ordre":order,"victoires_sur_100":wins,"combats_avec_allie_KO":casualties,"coups_poison":poison_hits,"manches_moyennes":rounds/100.0})
	print(JSON.stringify(results))
	var file = FileAccess.open("res://tests/poison-priority-results.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(results,"  "))
	quit()
