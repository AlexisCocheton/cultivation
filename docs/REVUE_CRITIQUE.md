# Revue critique — 20 novembre 2026

Agent : `/root/critique`. Première revue ciblée en lecture seule des derniers
cadres et interfaces. Verdict : **prêt avec réserves** dans ce périmètre ; aucun
défaut bloquant identifié. La direction artistique validée est conservée.

## Réserves ouvertes

1. **P2 — Carte agrandie** : la description répète nom, coût et voie ; le bloc
   centré laisse trop de vide sous le cartouche. Preuves :
   `docs/painted-ui/08-carte.png`, `visual/deck/menu.gd`, `game/cards.gd`,
   `visual/deck/detail.tscn`. Fournir les effets seuls au bloc de description et
   rapprocher ce bloc du titre, tout en gardant les champs séparés.
2. **P2 — Main de combat** : cartes extérieures trop basses avec leur inclinaison ;
   bordure coupée et dernière ligne proche du bord. Preuves :
   `docs/painted-ui/15-duel.png`, `visual/combat/hud.tscn`,
   `visual/team/hand.gd`. Ajuster la marge de repos et vérifier jusqu’à 12 cartes.
3. **P2 — Portée de la validation** : `tests/test_painted_screens.gd` produit des
   captures à une résolution, sans vérifier automatiquement les débordements ;
   son message PASS est trop large. Le détail de carte est rempli artificiellement.
   Faire passer la capture par la vraie action inspect, distinguer captures
   produites et tests réussis, et conserver la lecture des erreurs et la revue
   visuelle indépendante.

Ces réserves sont identifiées, pas encore corrigées dans la demande d’ajout de
l’agent. Elles devront faire l’objet d’une correction et d’une contre-revue.

## Procédure

Le critique a confirmé que `AGENTS.md` formalise la demande : revue indépendante
avant livraison, preuves concrètes, corrections importantes puis contre-vérification.
L’agent principal coordonne ; le critique n’édite ni le code ni les sauvegardes.

Contre-revue indépendante du hub après corrections : **prêt**. État désactivé contrôlé sur capture 960×624, interception des raccourcis du portail vérifiée dans le code et testée par injection d’événement. Six fichiers de sauvegarde comparés par SHA-256 : aucun changement.

Revue Activités : verdict final **prêt** après corrections des marges date/réserves, des lignes basses des cartes et du coin du footer. Captures 1280/960, bilan rempli et invitations inspectés. Tous les accès demandés conservés. Incident de fermeture du runner graphique corrigé par arrêt audio et libération explicite de la scène ; nouvelle exécution exit 0.

Contre-revue intégration maquette Activités : prêt pour cette modification. Captures 1280/960 comparées ; vignettes agrandies, cadres fins, textes sans débordement et pied uniquement composé des quatre boutons. Adaptations déclarées : badge Invitation rectangulaire, fontes éditables différentes du lettrage généré. La validation artistique finale reste celle du joueur.
