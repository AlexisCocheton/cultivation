extends RefCounted
# Encounter-specific enemy intentions; no card or turn-resolution rules live here.
var profile = "partenaire"
var phase = 0
var training_level = 0
var boss_pressure = 0
func reset() -> void: phase = 0
func intent(turn: int, tuning: Dictionary) -> Dictionary:
	var cycles = {
		"visiteuse":[Vector2i(5,4),Vector2i(0,8),Vector2i(11,0)],
		"partenaire":[Vector2i(6,0),Vector2i(0,5),Vector2i(9,0)],
		"offensif":[Vector2i(8,0),Vector2i(11,0),Vector2i(0,4)],
		"defensif":[Vector2i(0,10),Vector2i(7,0),Vector2i(10,0)],
		"inspecteur":[Vector2i(8,0),Vector2i(5,8),Vector2i(12,0)]}
	var cycle: Array = cycles[profile]
	if profile == "inspecteur" and phase == 1:
		cycle = [Vector2i(10,0),Vector2i(7,6),Vector2i(14,0)]
	var value: Vector2i = cycle[turn % 3]
	if profile == "partenaire":
		if value.x > 0: value.x += training_level
		if value.y > 0: value.y += training_level
	var extra = 0
	if profile == "inspecteur": extra = boss_pressure + int(tuning.get("pressure",0)) + int(turn / 3) * int(tuning.get("ramp",0))
	return {"damage":value.x+extra,"block":value.y}
func announce(combat) -> void:
	var friends: Array = combat.living(0)
	if friends.is_empty(): return
	var announced = intent(combat.turn,combat.allies.members[0].tuning)
	for i in combat.living(1):
		var target: int = friends[(combat.turn+i-combat.allies.members.size())%friends.size()]
		if announced.damage == 0 and announced.block > 0:
			combat.units[i].intent = {"source":i,"kind":"guard","value":announced.block,"target":i,"poison":0}
		else:
			combat.units[i].intent = {"source":i,"kind":"attack","value":announced.damage,"target":target,"poison":0,"secondary_guard":announced.block}
func after_round(combat) -> void:
	if profile == "inspecteur" and combat.enemies.members[0].state.hp*2 <= combat.enemies.members[0].state.max_hp: phase = 1
func check_special(_combat) -> void: pass
func resolve_special(_combat, _action: Dictionary) -> bool: return false
