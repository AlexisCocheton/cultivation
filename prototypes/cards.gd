extends RefCounted

const ROWS = """B01|Frappe droite|1|6|0|0
B02|Garde du rocher|1|0|5|0
B03|Souffle tranquille|0|0|3|0
B04|Taille appuyée|2|11|0|0
B05|Pas léger|1|0|3|1
B06|Lecture du duel|1|0|0|2
B07|Posture ferme|2|0|11|0
B08|Souffle offensif|0|0|0|0
L01|Pétales tranchants|1|7|0|0
L02|Fil de soie|1|0|4|1
L03|Prunier dansant|2|12|0|0
J01|Réplique du tigre|1|6|3|0
J02|Défi ouvert|1|0|0|1
J03|Fendre la montagne|2|14|0|0
H01|Racines profondes|1|0|9|0
H02|Patience du maître|1|0|4|0
H03|Mur de jade|2|5|12|0
Q01|Lame restaurée|1|8|0|0
Q02|Estoc du bambou|1|5|0|1
Q03|Sceau protecteur|1|0|7|0
Q04|Nœud du souffle|0|0|0|0
O01|Baume médicinal|0|0|0|0
O02|Encens de veille|0|0|0|2
E01|Serment de l'aube|1|7|2|0
E02|Serment du foyer|1|2|7|0
E03|Main du voyageur|1|0|2|2
E04|Écho des anciens|2|10|6|0
E05|Travail commun|1|0|6|1
E06|Horizon dégagé|1|8|0|0
E07|Dignité retrouvée|2|12|4|0"""

const PRESETS = {
	"Départ": ["B01","B01","B02","B02","B04","B04","B07","B07","B03","B05","B06","B08"],
	"Jun · offensif": ["B01","B01","B02","B02","B03","B08","J01","J02","J03","Q01","E01","B05"],
	"Shen · défensif": ["B01","B01","B02","B03","B04","B08","H01","H02","H03","Q03","E02","B06"],
	"Lian · enchaînements": ["B01","B02","B03","B05","B05","B08","L01","L02","L03","Q02","E01","B06"]
}

static func catalog() -> Dictionary:
	var result = {}
	for row in ROWS.split("\n"):
		var v = row.split("|")
		result[v[0]] = {"name":v[1],"cost":int(v[2]),"damage":int(v[3]),"block":int(v[4]),"draw":int(v[5]),"exhaust":v[0] in ["B03","B08","Q04","O01","O02"]}
	return result

static func validate(deck: Array) -> String:
	if deck.size() != 12:
		return "Le deck doit contenir 12 cartes."
	var counts = {}
	var data = catalog()
	for id in deck:
		if not data.has(id):
			return "Carte inconnue : " + str(id)
		counts[id] = counts.get(id,0) + 1
		if counts[id] > (2 if id.begins_with("B") else 1):
			return "Trop d'exemplaires : " + id
	for group in [["Q01","Q02"],["Q03","Q04"],["O01","O02"],["E01","E02"]]:
		var present = 0
		for id in group:
			present += int(deck.has(id))
		if present > 1:
			return "Emplacements ou choix exclusifs incompatibles."
	return ""

static func description(id: String) -> String:
	var c: Dictionary = catalog()[id].duplicate()
	var tuning = preload("res://prototypes/balance.gd").COMBAT
	for field in tuning.get("cards",{}).get(id,{}): c[field] = tuning.cards[id][field]
	var parts: Array[String] = []
	if c.damage: parts.append("%d dégâts" % c.damage)
	if c.block: parts.append("%d garde" % c.block)
	if c.draw: parts.append("pioche %d" % c.draw)
	match id:
		"B08": parts.append("prochaine attaque +2")
		"H02": parts.append("prochaine attaque +3")
		"J02": parts.append("Ennemi Exposé : il reçoit +50 % de dégâts ce tour")
		"J03": parts.append("perd 2 PV")
		"L01": parts.append("combo 2 cartes : %d dégâts" % tuning.get("lian_combo",10))
		"L03": parts.append("combo : %d dégâts et pioche 1" % tuning.get("lian_finisher",12))
		"Q04": parts.append("+1 qi")
		"O01": parts.append("soigne 6 PV")
		"E06": parts.append("pioche 1 si cible Exposée")
	if c.exhaust: parts.append("retirée après usage jusqu'au prochain combat")
	return "%s · %d qi\n%s" % [c.name,c.cost," · ".join(parts)]
