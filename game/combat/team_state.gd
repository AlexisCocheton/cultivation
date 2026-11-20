extends RefCounted
var members: Array = []
func add(character) -> bool:
	if members.size() >= 3 or members.has(character): return false
	members.append(character)
	return true
func living() -> Array:
	return members.filter(func(member): return member.state.hp > 0)
