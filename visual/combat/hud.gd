extends Control

const Tile = preload("res://visual/deck/tile.tscn")
const Cards = preload("res://prototypes/cards.gd")
var game

func setup(controller) -> void:
	game = controller
	var battle = game.battle
	$Title.text = "Jun · Tutoriel" if battle.training_level == 0 else "Jun · Entraînement %d / 4" % battle.training_level
	$Turn.text = "Tour %d" % (battle.turn + 1)
	$Recruit/Name.text = "Recrue   %d / %d PV" % [battle.hp,battle.max_hp]
	$Enemy/Name.text = "Jun   %d / %d PV" % [battle.enemy_hp,battle.enemy_max]
	$Recruit/HP.max_value = battle.max_hp
	$Recruit/HP.value = battle.hp
	$Enemy/HP.max_value = battle.enemy_max
	$Enemy/HP.value = battle.enemy_hp
	$Recruit/Guard.text = "Garde %d" % battle.block
	$Enemy/Guard.text = "Garde %d" % battle.enemy_block
	if battle.exposed: $Enemy/Guard.text += " · Exposé +50 %"
	var intent = battle.intent()
	$Intent.setup(game.actors[2],intent)
	$Qi.text = "%d Qi" % battle.energy
	$Counts.text = "Pioche %d\nDéfausse %d · Retirées %d" % [battle.pile.size(),battle.discard.size(),battle.removed.size()]
	$Sound.text = "Son : " + ("non" if game.muted else "oui")
	$Motion.text = "Effets : " + ("doux" if game.reduced_motion else "oui")
	$Sound.pressed.connect(func(): game.muted = not game.muted; game.save_progress(); $Sound.text = "Son : " + ("non" if game.muted else "oui"))
	$Motion.pressed.connect(func(): game.reduced_motion = not game.reduced_motion; game.save_progress(); $Motion.text = "Effets : " + ("doux" if game.reduced_motion else "oui"))
	$EndTurn.disabled = game.busy
	$Leave.disabled = game.busy
	$EndTurn.pressed.connect(game.end_turn)
	$Leave.pressed.connect(game.leave_combat)
	for child in $Scroll/Hand.get_children():
		$Scroll/Hand.remove_child(child)
		child.queue_free()
	for i in range(battle.hand.size()):
		var index = i
		var id: String = battle.hand[i]
		var tile = Tile.instantiate()
		tile.card_id = id
		tile.disabled = game.busy or battle.cards[id].cost > battle.energy
		$Scroll/Hand.add_child(tile)
		if tile.disabled:
			tile.get_node("Art").modulate = Color(0.55,0.55,0.55)
			tile.get_node("Cost").text = "%d×" % battle.cards[id].cost
			tile.tooltip_text += "\n" + ("Action en cours" if game.busy else "Qi insuffisant")
		tile.mouse_entered.connect(func(): preview_card(id))
		tile.focus_entered.connect(func(): preview_card(id))
		tile.mouse_exited.connect(reset_preview)
		tile.pressed.connect(func(): game.play_card(index))
	$Empty.visible = battle.hand.is_empty()
	$ScrollHint.text = "Fais défiler la main pour voir les autres cartes →" if battle.hand.size() > 5 else ""
	$Powers.text = "Force +%d · Main %d/%d · Persistantes %d · Pioche/tour %d" % [battle.strength,battle.hand.size(),battle.hand_limit,battle.active.size(),5+battle.active.count("B07")]
	var names: Array[String] = []
	for id in battle.active: names.append(Cards.catalog()[id].name)
	$Powers.tooltip_text = "Actives : " + ", ".join(names)
	reset_preview()

func reset_preview() -> void:
	$Preview.text = "Action en cours…" if game.busy else "Joue une technique · %d carte(s) jouée(s) ce tour" % game.battle.played
	if game.battle.bonus > 0: $Preview.text += " · Prochaine attaque +%d" % game.battle.bonus

func preview_card(id: String) -> void:
	if game.busy: return
	var battle = game.battle
	var description: String = Cards.description(id).split("\n")[1].replace("retirée après usage jusqu'au prochain combat", "Épuisement : retirée jusqu'au prochain duel")
	var damage: int = battle.damage_for(id)
	if damage > 0:
		description += " · Maintenant : %d dégâts (%d après garde)" % [damage,maxi(0,damage-battle.enemy_block)]
	$Preview.text = battle.cards[id].name + " · " + Cards.way_name(id) + " — " + description
	if battle.cards[id].cost > battle.energy: $Preview.text = "Qi insuffisant · " + $Preview.text
