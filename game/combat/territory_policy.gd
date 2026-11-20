extends RefCounted
const CAPTAIN_DAMAGE = 12
const DAGGER_DAMAGE = 9
const SPEAR_DAMAGE = 8
const COAT_TURN = 1
const POISON_DOSE = 9
var coated = false
var pill_used = false
var pill_target = -1
func reset() -> void:
	coated = false
	pill_used = false
	pill_target = -1
func announce(combat) -> void:
	var friends: Array = combat.living(0)
	var foes: Array = combat.living(1)
	if friends.is_empty() or foes.is_empty(): return
	var offset: int = combat.allies.members.size()
	var t: int = combat.turn
	for i in foes:
		var role: int = i-offset
		var kind = "attack"
		var value = CAPTAIN_DAMAGE + mini(4,t/3)
		var target: int = friends[(t+role)%friends.size()]
		if role == 1:
			value = DAGGER_DAMAGE
			if coated: kind = "poison"; value = POISON_DOSE
			if not coated and t >= COAT_TURN: kind = "coat"; value = POISON_DOSE; target = i
		elif role == 2:
			if t%2 == 0: kind = "guard"; value = 8; target = foes[0]
			else: value = SPEAR_DAMAGE
		if kind in ["attack","poison"] and combat.units[i].enraged: value = int(ceil(value*1.5))
		combat.units[i].intent = {"source":i,"kind":kind,"value":value,"target":target,"poison":value if kind == "poison" else 0}
func check_special(combat) -> void:
	var foes: Array = combat.living(1)
	if pill_used or foes.size() != 1: return
	pill_used = true
	pill_target = foes[0]
	var survivor: Dictionary = combat.units[pill_target]
	survivor.hp = survivor.max_hp
	survivor.poison = 0
	survivor.enraged = true
	survivor.intent = {"source":pill_target,"kind":"recover","value":0,"target":pill_target,"poison":0}
	combat.queue = combat.queue.filter(func(action): return action.source != pill_target)
	combat.events.append({"kind":"pill","target":pill_target})
	combat.log_lines.append("Le chef lance une pilule à %s : PV restaurés, attaques +50 %% dès la prochaine manche." % survivor.name)
func resolve_special(combat, action: Dictionary) -> bool:
	if action.kind != "coat": return false
	coated = true
	combat.events.append({"kind":"coat","target":action.source})
	combat.log_lines.append("L'assaillante enduit ses dagues : ses prochains coups appliqueront 9 dégâts directs et 9 poison ; seule la partie directe est absorbée par la garde.")
	return true
func after_round(_combat) -> void: pass
