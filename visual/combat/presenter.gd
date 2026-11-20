extends RefCounted
# Animation/presentation only; all card decisions remain in the encounter engine.
var game: Node
func _init(controller: Node) -> void: game = controller

func play_card(index: int) -> void:
	if game.busy or game.mode != "combat": return
	if not game.battle.can_play(index): return
	var id: String = game.battle.hand[index]
	var card: Dictionary = game.battle.cards[id]
	var old_hp = game.battle.enemy_hp
	game.busy = true
	game.combat_ui()
	var strike = game.battle.damage_for(id) > 0
	var contact = func():
		game.battle.play(index)
		game.combat_ui()
		if strike:
			impact(game.actors[2],old_hp-game.battle.enemy_hp,"BLOQUÉ")
		else:
			impact(game.player,0,"+%d GARDE" % card.block if card.block > 0 else "SOUFFLE")
	if strike:
		await attack_motion(game.player,game.actors[2],contact)
	else:
		await game.player.perform_action("guard",contact,game.reduced_motion)
	if strike and card.block > 0:
		await game.player.perform_action("guard",Callable(),game.reduced_motion)
	game.player.guarding = game.battle.block > 0
	game.actors[2].guarding = game.battle.enemy_block > 0
	game.player._process(0)
	game.actors[2]._process(0)
	game.busy = false
	if game.battle.outcome != "": game.finish_combat()
	else: game.combat_ui()


func end_turn() -> void:
	if game.busy or game.mode != "combat": return
	game.busy = true
	var old_hp = game.battle.hp
	var intent = game.battle.intent()
	game.combat_ui()
	var contact = func():
		game.battle.end_turn()
		game.combat_ui()
		if intent.damage > 0: impact(game.player,old_hp-game.battle.hp,"PARADE")
		else: impact(game.actors[2],0,"+%d GARDE" % intent.block)
	if intent.damage > 0:
		await attack_motion(game.actors[2],game.player,contact)
	else:
		await game.actors[2].perform_action("guard",contact,game.reduced_motion)
	if intent.damage > 0 and intent.block > 0:
		await game.actors[2].perform_action("guard",Callable(),game.reduced_motion)
	game.player.guarding = game.battle.block > 0
	game.actors[2].guarding = game.battle.enemy_block > 0
	game.player._process(0)
	game.actors[2]._process(0)
	game.busy = false
	if game.battle.outcome != "": game.finish_combat()
	else: game.combat_ui()


func attack_motion(attacker: Node2D, defender: Node2D, contact: Callable) -> void:
	var origin = attacker.position
	if not game.reduced_motion:
		var approach = game.create_tween()
		approach.tween_property(attacker,"position:x",defender.position.x-attacker.facing*115,0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		await approach.finished
	await attacker.perform_action("attack",contact,game.reduced_motion)
	if not game.reduced_motion:
		var retreat = game.create_tween()
		retreat.tween_property(attacker,"position",origin,0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await retreat.finished


func impact(actor: Node2D, damage: int, message: String = "GARDE") -> void:
	game.tone(180 if damage > 0 else 440)
	var floating = game.label("−%d" % damage if damage > 0 else message,actor.position+Vector2(-100,-210),Vector2(260,50),28,Color("ffbbb5") if damage > 0 else Color("abe7d4"))
	var tween = game.create_tween()
	if not game.reduced_motion:
		var stroke = Line2D.new()
		if damage > 0:
			stroke.points = PackedVector2Array([Vector2(-60,0),Vector2(50,-140),Vector2(-20,-50)])
		else:
			for i in range(19):
				var angle = -PI/2 + i*PI/18
				stroke.add_point(Vector2(cos(angle)*60*actor.facing,sin(angle)*85-85))
		stroke.width = 7
		stroke.default_color = Color("ffe6c7") if damage > 0 else Color("9ae3d7")
		stroke.position = actor.position
		game.add_child(stroke)
		tween.parallel().tween_property(stroke,"modulate:a",0.0,0.24)
		tween.parallel().tween_property(floating,"position:y",floating.position.y-35,0.24)
		if damage > 0:
			actor.sprite.modulate = Color("ffadad")
			tween.parallel().tween_property(actor.sprite,"modulate",Color.WHITE,0.2)
		tween.tween_callback(stroke.queue_free)
	else: tween.tween_interval(0.12)
	await tween.finished
	if is_instance_valid(floating): floating.queue_free()

