extends RefCounted



# Paths describe a technique's tradition, independently of its damage or equipment slot.
const WAY_NAMES = {"orthodox":"Orthodoxe", "unorthodox":"Non orthodoxe", "demonic":"Démoniaque"}

static func way_name(id: String) -> String:
	return WAY_NAMES[catalog()[id].way]

const MIN_DECK = 12
const MAX_DECK = 20

const PRESETS = {
	"Départ": ["B01","B01","B02","B02","B04","B04","B07","B07","B03","B05","B06","B08"],
	"Jun · offensif": ["B01","B01","B02","B02","B03","B08","J01","J02","J03","Q01","E01","B05"],
	"Shen · défensif": ["B01","B01","B02","B03","B04","B08","H01","H02","H03","Q03","E02","B06"],
	"Lian · enchaînements": ["B01","B02","B03","B05","B05","B08","L01","L02","L03","Q02","E01","B06"]
}

const EQUIPMENT_GROUPS = {"weapon":["Q01","Q02"],"talisman":["Q03","Q04"],"item":["O01","O02"]}
const EXCLUSIVE_GROUPS = [EQUIPMENT_GROUPS.weapon,EQUIPMENT_GROUPS.talisman,EQUIPMENT_GROUPS.item,["E01","E02"]]
const Effects = preload("res://game/combat/card_effects.gd")
const Balance = preload("res://game/balance.gd")
# Cache only eight mastery variants. Never expose cached dictionaries or nested arrays.

static func mastery_key(ranks: Dictionary) -> int:
	var key = 0
	for i in range(3):
		if int(ranks.get(["L","J","H"][i],0)) >= 5: key |= 1 << i
	return key

static func _build_catalog(key: int) -> Dictionary:
	var result = {}
	if _cache().definitions.is_empty():
		_cache().definitions = normalize_data(JSON.parse_string(FileAccess.get_file_as_string("res://data/cards.json")))
	for id in _cache().definitions:
		var c: Dictionary = _cache().definitions[id].duplicate(true)
		var owner: String = c.owner
		c.equipment_slot = equipment_slot(id)
		for field in Balance.COMBAT.get("cards",{}).get(id,{}): c[field] = Balance.COMBAT.cards[id][field]
		if c.mastery and (key & (1 << ["L","J","H"].find(owner))) != 0:
			c.upgraded = true
			if c.damage > 0: c.damage += 3
			if c.block > 0: c.block += 3
			if c.damage == 0 and c.block == 0: c.draw += 1
		_resolve_effect_values(c,Balance.COMBAT)
		result[id] = c
	return result

static func _resolve_effect_values(card: Dictionary, tuning: Dictionary) -> void:
	for effect in card.effects:
		if effect.has("tuning_key"):
			effect.amount = int(tuning.get(effect.tuning_key,effect.get("fallback",card.damage))) + (int(effect.get("mastery_amount",0)) if card.upgraded else 0)

static func catalog(ranks: Dictionary = {}, tuning: Dictionary = {}) -> Dictionary:
	var key = mastery_key(ranks)
	if not _cache().catalogs.has(key): _cache().catalogs[key] = _build_catalog(key)
	var result: Dictionary = _cache().catalogs[key].duplicate(true)
	if not tuning.is_empty():
		if not _cache().catalogs.has(0): _cache().catalogs[0] = _build_catalog(0)
		for id in tuning.get("cards",{}):
			for field in tuning.cards[id]: result[id][field] = tuning.cards[id][field] + result[id][field] - _cache().catalogs[0][id][field]
		for card in result.values(): _resolve_effect_values(card,tuning)
	for id in result:
		var card: Dictionary = result[id]
		var name_key = "card.%s.name" % id
		var translated = String(TranslationServer.translate(name_key))
		card.name = (String(card.name) if translated == name_key else translated) + (" +" if card.upgraded else "")
	return result

static func copy_limit(id: String) -> int:
	if not _cache().catalogs.has(0): _cache().catalogs[0] = _build_catalog(0)
	return int(_cache().catalogs[0].get(id,{}).get("copy_limit",0))

static func equipment_slot(id: String) -> String:
	for slot in EQUIPMENT_GROUPS:
		if EQUIPMENT_GROUPS[slot].has(id): return slot
	return ""

static func exclusive_conflict(deck: Array, id: String) -> String:
	for group in EXCLUSIVE_GROUPS:
		if group.has(id):
			for other in group:
				if other != id and deck.has(other): return other
	return ""

static func validate(deck: Array) -> String:
	if deck.size() < MIN_DECK or deck.size() > MAX_DECK: return "Le deck doit contenir de 12 à 20 cartes."
	var counts = {}
	var data = catalog()
	for id in deck:
		if not data.has(id): return "Carte inconnue : " + str(id)
		counts[id] = counts.get(id,0) + 1
		if counts[id] > copy_limit(id): return "Trop d'exemplaires : " + id
		if exclusive_conflict(deck,id) != "": return "Emplacements ou choix exclusifs incompatibles."
	return ""

static func description(id: String, ranks: Dictionary = {}) -> String:
	return describe_data(catalog(ranks)[id])

static func describe_data(card: Dictionary) -> String:
	return "%s · %d qi\n%s\n%s : %s" % [card.name,card.cost,Effects.describe(card),String(TranslationServer.translate("Voie")),String(TranslationServer.translate(WAY_NAMES[card.way]))]

static func target_kind(_id: String, data: Dictionary) -> String:
	if data.get("target","") != "": return data.target
	if data.damage > 0: return "enemy"
	if data.block > 0: return "ally"
	return "self"

# JSON represents whole numbers as floats; runtime state and save hashes use integers.
static func normalize_data(value: Variant) -> Variant:
	if value is float and value == floor(value): return int(value)
	if value is Array:
		for i in range(value.size()): value[i] = normalize_data(value[i])
	elif value is Dictionary:
		for key in value: value[key] = normalize_data(value[key])
	return value

static func _cache():
	return Engine.get_main_loop().root.get_node("DataCache")
