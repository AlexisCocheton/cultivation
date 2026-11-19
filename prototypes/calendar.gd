extends RefCounted

const Cards = preload("res://prototypes/cards.gd")
const Balance = preload("res://prototypes/balance.gd")
const MAIN = {0:"M01",6:"M02",15:"M03",24:"M04",36:"M05",41:"M06"}
var slot = 0
var supplies = 6
var ranks = {"L":0,"J":0,"H":0}
var last_day = {"L":0,"J":0,"H":0}
var buildings = {"kitchen":0,"hall":0,"workshop":0}
var seen: Array = []
var collection: Array = ["B01","B02","B03","B04","B05","B06","B07","B08"]
var deck: Array = Cards.PRESETS["Départ"].duplicate()
var loadout = {"weapon":"","talisman":"","item":""}
var optional_wins = 0
var interest = false
var romance = false
var before_final: Dictionary = {}
var before_preparation: Dictionary = {}
var complete = false
var history: Array = []

func day() -> int:
	return int(slot / 3) + 1

func period() -> int:
	return slot % 3

func actions() -> Array:
	if complete:
		return []
	if MAIN.has(slot):
		return [MAIN[slot]]
	return ["work","rest","L","J","H","fight","trail","kitchen","hall","workshop","buy:Q01","buy:Q02","buy:Q03","buy:Q04","S01","S02","S03","S04","S05","S06"]

func reason(action: String) -> String:
	if complete or slot >= 42:
		return "Campagne terminée."
	if action in ["M01","M03","M04","M06","S02","S05","fight","trail"]:
		var error = validate_deck(deck,loadout)
		if error != "": return error
	if MAIN.has(slot):
		return "" if action == MAIN[slot] else "Événement principal prioritaire."
	if not actions().has(action):
		return "Activité inconnue ou hors période."
	if ranks.has(action):
		var rank: int = ranks[action]
		if rank >= 4: return "Lien déjà achevé."
		if day() < [1,3,6,10][rank]: return "Rang disponible à partir du jour %d." % [1,3,6,10][rank]
		if last_day[action] == day(): return "Une progression par résident et par jour."
		if action == "L" and rank == 3 and interest and period() != 2:
			return "La scène romantique se joue le soir (désactivez l'intérêt pour l'amitié)."
	if buildings.has(action):
		if buildings[action] >= 2: return "Bâtiment terminé."
		if supplies < (3 if buildings[action] == 0 else 4): return "Réserves insuffisantes."
	if action in ["fight","trail"] and period() == 2: return "Activité de jour uniquement."
	if action == "trail" and not seen.has("M03"): return "Sentier fermé avant M03."
	if action.begins_with("buy:"):
		if action.substr(4) not in ["Q01","Q02","Q03","Q04"]: return "Équipement inconnu."
		if collection.has(action.substr(4)): return "Équipement déjà possédé."
		if buildings.workshop == 0 and day() not in [4,8,12]: return "Atelier fermé et marchand absent."
		if supplies < equipment_cost(): return "Réserves insuffisantes."
	if action.begins_with("S"):
		if seen.has(action): return "Événement déjà résolu."
		match action:
			"S01":
				if day() not in [4,8,12]: return "Marchand présent J4, J8 et J12."
			"S02":
				if not seen.has("M03") or buildings.hall == 0: return "M03 et pavillon 1 requis."
			"S03":
				if day() < 3: return "Disponible au jour 3."
			"S04":
				if day() < 6 or repairs() == 0: return "Jour 6 et un chantier requis."
			"S05":
				if not seen.has("M03") or period() == 2: return "Sentier de jour après M03."
			"S06":
				if day() < 4: return "Disponible au jour 4."
	return ""

func repairs() -> int:
	return buildings.kitchen+buildings.hall+buildings.workshop

func event_count() -> int:
	return seen.size()+ranks.L+ranks.J+ranks.H

func grant(id: String) -> void:
	if not collection.has(id): collection.append(id)

func equipment_cost() -> int:
	return Balance.EQUIPMENT_DISCOUNT if buildings.workshop >= 2 else Balance.EQUIPMENT_COST

func validate_deck(candidate: Array, equipment: Dictionary) -> String:
	var error = Cards.validate(candidate)
	if error != "": return error
	var groups = {"weapon":["Q01","Q02"],"talisman":["Q03","Q04"],"item":["O01","O02"]}
	for id in candidate:
		if not collection.has(id): return "Carte non acquise : " + str(id)
	for slot_name in groups:
		var chosen = equipment.get(slot_name,"")
		if chosen != "" and (not groups[slot_name].has(chosen) or not collection.has(chosen)):
			return "Équipement non acquis ou emplacement incompatible."
		for id in groups[slot_name]:
			if candidate.has(id) != (chosen == id):
				return "Le deck doit contenir exactement les cartes équipées : " + slot_name
	return ""

func configure(candidate: Array, equipment: Dictionary) -> String:
	if complete: return "Campagne terminée."
	var error = validate_deck(candidate,equipment)
	if error != "": return error
	deck = candidate.duplicate()
	loadout = equipment.duplicate()
	return ""

static func equipment_slot(id: String) -> String:
	if id in ["Q01","Q02"]: return "weapon"
	if id in ["Q03","Q04"]: return "talisman"
	if id in ["O01","O02"]: return "item"
	return ""

func replacement_plan(index: int, id: String) -> Dictionary:
	var result = {"error":"Choisis d’abord une carte dans le deck.","index":index,"deck":deck.duplicate(),"loadout":loadout.duplicate()}
	if index < 0 or index >= deck.size(): return result
	if not collection.has(id):
		result.error = "Carte non acquise."
		return result
	var target_slot = equipment_slot(id)
	if target_slot != "":
		if loadout[target_slot] == id:
			result.error = "Cet équipement est déjà équipé."
			return result
		if loadout[target_slot] != "": index = deck.find(loadout[target_slot])
	var old_slot = equipment_slot(deck[index])
	if old_slot != "": result.loadout[old_slot] = ""
	if target_slot != "": result.loadout[target_slot] = id
	result.index = index
	result.deck[index] = id
	result.error = validate_deck(result.deck,result.loadout)
	return result

func merchant_reason(id: String) -> String:
	var error = reason("S01") if not seen.has("S01") else reason("buy:"+id)
	if error != "": return error
	if id == "" and not seen.has("S01"): return ""
	return reason("buy:"+id)

func suggested_deck(preferred: Array, equipment: Dictionary) -> Array:
	var result: Array = []
	for id in equipment.values():
		if id != "" and collection.has(id) and not result.has(id): result.append(id)
	var pool = preferred + Cards.PRESETS["Départ"] + collection + collection
	for id in pool:
		if result.size() >= 12: break
		if not collection.has(id) or id.begins_with("Q") or id.begins_with("O"): continue
		if id == "E01" and result.has("E02"): continue
		if id == "E02" and result.has("E01"): continue
		if result.count(id) < (2 if id.begins_with("B") else 1): result.append(id)
	return result

func suggested_loadout(preferred: Array) -> Dictionary:
	var result = {"weapon":"","talisman":"","item":""}
	for id in preferred:
		if not collection.has(id): continue
		if id in ["Q01","Q02"]: result.weapon = id
		if id in ["Q03","Q04"]: result.talisman = id
		if id in ["O01","O02"]: result.item = id
	return result

func act(action: String, won: bool = true, choice: String = "E01") -> String:
	var error = reason(action)
	if error != "": return error
	var purchase = choice if action == "S01" and choice in ["Q01","Q02","Q03","Q04"] else ""
	# E01/E02 are the legacy campaign-wide oath choice, not a merchant purchase.
	if action == "S01" and choice not in ["","E01","E02","Q01","Q02","Q03","Q04"]: return "Équipement inconnu."
	if purchase != "":
		error = merchant_reason(purchase)
		if error != "": return error
	if action == "M02" and choice not in ["E01","E02"]: return "Choix de serment invalide."
	if action == "M01" and not won: return "Tutoriel : recommencer sans coût."
	if action == "M05" and before_preparation.is_empty(): before_preparation = snapshot()
	if action == "M06" and before_final.is_empty(): before_final = snapshot()
	if action == "M06" and not won: return "Défaite finale : rechargez le point préalable."
	if action == "work": supplies += Balance.WORK_KITCHEN if buildings.kitchen >= 1 else Balance.WORK_BASE
	if ranks.has(action):
		ranks[action] += 1
		last_day[action] = day()
		if ranks[action] <= 3: grant("%s0%d" % [action,ranks[action]])
		if action == "L" and ranks.L == 4: romance = interest
	if buildings.has(action):
		supplies -= 3 if buildings[action] == 0 else 4
		buildings[action] += 1
	if action.begins_with("buy:"):
		supplies -= equipment_cost()
		grant(action.substr(4))
	if action in ["fight","trail"] and won:
		if optional_wins < Balance.OPTIONAL_REWARD_LIMIT: supplies += 1 if action == "fight" else 2
		optional_wins += 1
	match action:
		"M02":
			grant(choice)
			supplies += Balance.EVENT_RESERVES
		"M03":
			if won: supplies += Balance.EVENT_RESERVES
		"M04":
			if won: grant("E07")
		"M05": supplies += Balance.EVENT_RESERVES
		"M06": complete = true
		"S01":
			grant("E03")
			if purchase != "":
				supplies -= equipment_cost()
				grant(purchase)
		"S02":
			if won:
				grant("E04")
				supplies += Balance.EVENT_RESERVES
		"S03":
			grant("O01")
			supplies += Balance.EVENT_RESERVES
		"S04":
			grant("E05")
			supplies += Balance.EVENT_RESERVES
		"S05":
			if won:
				grant("E06")
				grant("O02")
		"S06": supplies += Balance.EVENT_RESERVES
	if action.begins_with("M") or action.begins_with("S"): seen.append(action)
	history.append({"slot":slot,"action":action,"supplies":supplies,"won":won})
	slot += 1
	return ""

func snapshot() -> Dictionary:
	return {"slot":slot,"supplies":supplies,"ranks":ranks.duplicate(),"last_day":last_day.duplicate(),"buildings":buildings.duplicate(),"seen":seen.duplicate(),"collection":collection.duplicate(),"deck":deck.duplicate(),"loadout":loadout.duplicate(),"optional_wins":optional_wins,"interest":interest,"romance":romance,"complete":complete,"history":history.duplicate(true)}

func restore(data: Dictionary) -> void:
	for key in data:
		if key in ["slot","supplies","ranks","last_day","buildings","seen","collection","deck","loadout","optional_wins","interest","romance","complete","history"]:
			set(key,normalize(data[key]))
	if not data.has("loadout"): loadout = {"weapon":"","talisman":"","item":""}
	if not data.has("deck"): deck = Cards.PRESETS["Départ"].duplicate()

func normalize(value: Variant) -> Variant:
	# JSON numbers are floats; state counters and nested history use integers.
	if value is float: return int(value)
	if value is Array:
		var result: Array = []
		for item in value: result.append(normalize(item))
		return result
	if value is Dictionary:
		var result = {}
		for key in value: result[key] = normalize(value[key])
		return result
	return value

func save_lab(path: String = "user://laboratoire_etape4_v2.json") -> bool:
	var file = FileAccess.open(path,FileAccess.WRITE)
	if file == null: return false
	file.store_string(JSON.stringify({"version":Balance.VERSION,"state":snapshot(),"final":before_final,"preparation":before_preparation}))
	return true
