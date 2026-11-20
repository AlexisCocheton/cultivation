extends RefCounted

const ARRIVAL_SLOT = 21 # J8 matin, après sept jours complets.
const ARRIVED = "spy_arrived"
const LINES = [
	["Une voyageuse à la porte", "Une jeune femme attend près du portail, un éventail fermé entre les doigts. Ses bottes portent la poussière du chemin. Son regard s'attarde un instant sur les accès de la cour."],
	["La voyageuse", "« On raconte que votre secte reprend vie. Je sais reconnaître une piste, porter un message… et me défendre. Vous auriez une place pour quelqu'un qui préfère se rendre utile ? »"],
	["Maître Shen", "« Tu peux rester à l'essai. Ici, chacun participe aux travaux et respecte les autres disciples. Nous jugerons tes actes. »\n\nElle incline la tête, avec un sourire tranquille."],
	["Une nouvelle recrue", "« Alors je ferai en sorte que vous ne regrettiez pas votre accueil. »\n\nElle range son éventail. Un papier disparaît dans sa manche avant que tu puisses en distinguer les signes."]
]

static func pending(calendar) -> bool:
	return calendar.slot >= ARRIVAL_SLOT and not calendar.complete and not calendar.seen.has(ARRIVED)

# Transaction : aucun coût ni progression de temps ; restauration si écriture impossible.
static func welcome(calendar, persist: Callable) -> bool:
	if not pending(calendar): return false
	var previous = calendar.seen.duplicate(true)
	calendar.seen.append(ARRIVED)
	if not persist.call():
		calendar.seen = previous
		return false
	return true
