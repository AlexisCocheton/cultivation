extends RefCounted

const SAVE_PATH = "user://prunier_save.json"
const PERIODS = ["Matin", "Après-midi", "Soir"]
const CARDS = {
	"frappe": {"name": "Frappe droite", "cost": 1, "damage": 6, "block": 0, "text": "Inflige 6 dégâts."},
	"garde": {"name": "Garde du rocher", "cost": 1, "damage": 0, "block": 5, "text": "Gagne 5 points de garde."},
	"souffle": {"name": "Souffle tranquille", "cost": 0, "damage": 0, "block": 3, "text": "Gagne 3 points de garde."},
	"petales": {"name": "Pétales tranchants", "cost": 1, "damage": 10, "block": 0, "text": "Inflige 10 dégâts.\nEnseignement de Lian."},
	"contre": {"name": "Réplique du tigre", "cost": 1, "damage": 7, "block": 4, "text": "7 dégâts et 4 garde.\nTechnique de Jun."},
	"racines": {"name": "Racines profondes", "cost": 1, "damage": 0, "block": 10, "text": "Gagne 10 points de garde.\nEnseignement de Shen."},
	"lame": {"name": "Lame restaurée", "cost": 1, "damage": 9, "block": 0, "text": "Inflige 9 dégâts.\nConférée par votre épée."}
}

var day = 1
var period = 0
var hero_name = "Yun"
var robe = 0
var hair = 0
var skin = 0
var supplies = 3
var repairs = 0
var affinity = {"Lian": 0, "Jun": 0, "Shen": 0}
var romance = false
var deck = ["frappe", "frappe", "frappe", "garde", "garde", "souffle"]
var equipment = false
var inspection_done = false
var inspection_won = false
var journal = ["Une nouvelle recrue franchit les portes de la secte du Prunier." ]

func record(message: String) -> void:
	journal.push_front("J%d · %s — %s" % [day, PERIODS[period], message])
	if journal.size() > 30:
		journal.resize(30)

func advance() -> void:
	period += 1
	if period > 2:
		period = 0
		day += 1
	save_game()

func bond(person: String) -> String:
	affinity[person] += 1
	var learned = {"Lian": "petales", "Jun": "contre", "Shen": "racines"}[person]
	var result = "Lien avec %s : %d. " % [person, affinity[person]]
	if affinity[person] == 2:
		deck.append(learned)
		result += "Nouvelle carte : %s !" % CARDS[learned].name
	else:
		result += "Votre confiance grandit."
	record(result)
	advance()
	return result

func save_game(path: String = SAVE_PATH) -> void:
	var data = {}
	for key in ["day", "period", "hero_name", "robe", "hair", "skin", "supplies", "repairs", "affinity", "romance", "deck", "equipment", "inspection_done", "inspection_won", "journal"]:
		data[key] = get(key)
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))

func load_game(path: String = SAVE_PATH) -> bool:
	if not FileAccess.file_exists(path):
		return false
	var data = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not data is Dictionary:
		return false
	for key in ["day", "period", "hero_name", "robe", "hair", "skin", "supplies", "repairs", "affinity", "romance", "deck", "equipment", "inspection_done", "inspection_won", "journal"]:
		if data.has(key):
			set(key, data[key])
	day = maxi(1, int(day))
	period = clampi(int(period), 0, 2)
	return true
