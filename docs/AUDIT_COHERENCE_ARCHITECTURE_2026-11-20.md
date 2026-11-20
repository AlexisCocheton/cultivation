# Audit de cohérence et d’architecture — 20 novembre 2026

Audit demandé par le joueur, sans refonte ni modification des règles de jeu. Les fichiers de production ne sont pas modifiés durant cet audit. Tests et preuves dans `tests/audit_architecture.gd`, `tests/audit_architecture_results.json` et `tests/audit_suite_results.json`. Profil d’exécution isolé : `tools/regression-user` ; aucune écriture dans les campagnes personnelles.

## Conclusion

L’intuition Combat → Équipes → Personnages → Decks est adaptée au projet. Le code actuel réutilise déjà une partie des règles, mais le moteur partagé est un duel complet, pas un personnage. Le 3 contre 3 enveloppe trois moteurs de duel et copie leurs états dans un tableau de six dictionnaires. Cela explique les divergences et rend coûteux l’ajout d’un nouvel ennemi ou statut. Une migration progressive est préférable à une réécriture générale.

L’harmonisation précédente a partagé les cartes animées, l’orbe de qi, les textures d’intention et les barres de PV. Elle n’a pas unifié les règles de ciblage, les contrôleurs, les transactions de campagne ni les personnages. Elle ne pouvait donc pas, à elle seule, garantir la cohérence future.

## Défauts confirmés et priorités

### P1 — Sauvegarde : des chemins de progression ignorent l’échec d’écriture

`visual/preview.gd:462` / `start_combat` ignore le résultat de `save_progress`. `finish_combat` (593) incrémente les duels, peut consommer une période et présente le résultat même si l’écriture échoue. `learn` (398) a la même faiblesse après apprentissage. À l’inverse, `start_territory`, `finish_territory`, le menu de deck et la voyageuse disposent déjà de contrôles/retours arrière.

Reproduction : chemin de sauvegarde placé dans un répertoire absent. Le duel commence ; une victoire forcée incrémente `completed_duels` et ouvre le dialogue de récompense malgré le refus d’écriture. Ce n’est pas une corruption systématique du fichier : c’est une progression annoncée au joueur qui n’est pas durable.

Correction : transaction de campagne commune, capture avant mutation, tentative d’écriture, restauration en cas d’échec et possibilité de réessayer. Ne pas reconstruire les contrôleurs avant d’avoir sécurisé ces points.

### P2 — Ciblage de Défi ouvert (J02) divergent

`visual/combat/hud.gd:44` décide de la cible uniquement avec `damage <= 0`. J02 ne fait pas de dégâts mais applique Exposé à l’ennemi ; l’interface solo impose donc un dépôt sur la recrue. `prototypes/team_battle.gd:114` traite explicitement J02 comme une carte ennemie.

Reproduction automatisée : le rectangle cible solo contient la recrue ; la règle équipe renvoie `enemy` pour la même carte. L’effet final reste ennemi, c’est le geste demandé au joueur qui est faux. Définir le type de cible dans la carte ou dans un résolveur partagé, jamais séparément dans chaque HUD.

### P2 — Validation incomplète des nouvelles sauvegardes narratives

`visual/progress.gd:83` vérifie les types principaux de `story`, pas les entrées de `battle_report.members`, les identifiants d’invitation ou les valeurs autorisées des choix. Une structure `{"members":[{"bad":"shape"}]}` est acceptée et enregistrée comme valide. `visual/story/panel.gd` attend pourtant `hp`, `name` et `guard_received` et peut échouer à l’ouverture du retour de tournoi.

Cela concerne des données mal formées, pas les sauvegardes normales produites par le parcours testé. Ajouter une validation récursive minimale du schéma, avec rejet/récupération de la copie de secours ; tester aussi les versions 2 à 6.

### P2 — Deux tests existants sont cassés par le changement d’interface

`tests/test_card_ways.gd:57` utilise encore `Scroll/Hand` ; `tests/test_reliability.gd:73` utilise `Enemy/Guard` et `Recruit/Guard`. Ces nœuds ont disparu. Les tests entrent en erreur et restent ouverts jusqu’à l’arrêt imposé par l’audit. Un message partiel ou l’absence de sortie ne vaut pas un test réussi.

Mettre ces tests à jour selon le comportement attendu, conserver leurs contrôles métier, puis ajouter un lanceur avec délai maximal, code de sortie et détection de SCRIPT ERROR. Vérifier aussi que la suite complète est lancée après chaque changement de composant partagé.

### P2 — Ancien rendu encore accessible dans la campagne

L’apprentissage initial de Lian dans `visual/preview.gd:398` construit encore un écran par code et instancie `visual/card.gd`, une carte bleu sombre de l’ancien style. La collection et le combat utilisent `visual/deck/tile.tscn` papier/encre. Le défaut n’est donc pas limité aux combats.

La voyageuse bénéficie du HUD commun mais son arène repose encore sur deux portraits et des pulsations (`visual/visitor/encounter.gd`), contre des personnages animés pour Jun et le tournoi. C’est une limite visuelle du prototype, pas une erreur de résolution des dégâts ; elle doit être explicitement suivie.

### P3 — Textes, information et interactions encore divergents

- Jardin : `visual/garden/ui.gd:15` annonce une fin au jour 4 ; le pavillon et la limite réelle sont au jour 7. README annonce aussi J2–J4.
- Le 3 contre 3 trace une ligne de ciblage et montre le personnage actif. Le duel ne montre qu’un marqueur au dépôt valide. Il manque une politique d’interaction commune, notamment pour la sélection au clavier et la confirmation de cible.
- L’orbe partagé connaît encore une recharge par défaut de 2, corrigée par les contrôleurs via une infobulle remplacée. Sa capacité visuelle est fixée à trois petites charges alors que certaines cartes permettent davantage de qi : la valeur chiffrée reste juste. La recharge/capacité doit être un paramètre explicite.
- `visual/team/hand_card.gd:16` contient une branche `damage > 0` imbriquée dans `damage == 0`, donc inaccessible. Ce texte évoque en outre une attaque choisie séparément, contraire à la règle validée attaque+garde sur soi. À supprimer, sans modifier la règle.
- Les descriptions, identifiants spéciaux, effets et formules sont répartis entre `cards.gd`, `battle.gd`, `team_battle.gd`, `tile.gd` et `hand_card.gd`. Une même carte demande plusieurs modifications coordonnées.

## Architecture actuelle : ce qui fonctionne et ce qui fragilise le projet

| Élément | État observé | Conséquence |
| --- | --- | --- |
| Catalogue de cartes | Source commune, rangs et valeurs d’équilibrage partagés | Base utile à conserver |
| Moteur solo | PV des deux camps, deck, statut Exposé, intentions et tours dans `battle.gd` | Responsabilités de duel et de personnage mélangées |
| Moteur équipe | Trois instances de Solo + `units` séparé ; synchronisation dans `play` | Deux représentations des PV/gardes ; un ennemi fictif par moteur de personnage |
| Fin de tour | Réécrite dans `team_battle.finish_round` | Ajouter un effet persistant exige de vérifier les deux chemins |
| Formation | Index 0–2 alliés, 3–5 ennemis, boucles et listes codées pour six unités | Impossible de simplement paramétrer un 1v1, 2v3 ou nouvel ennemi |
| Défi territorial | Poison, pilule, noms, PV et rôles dans le moteur | Le scénario du boss est confondu avec le moteur générique |
| Contrôleur de campagne | `preview.gd` dépasse 800 lignes : calendrier, scènes, son, combat, récompenses, sauvegardes | Trop de points d’entrée aux garanties différentes |
| Présentation | Main/qi/barres partagés ; deux HUD et plusieurs contrôleurs | Réutilisation réelle mais contrat implicite (`core`, `busy`, `selected`, chemins de nœuds) |
| Sauvegardes | Rotation validée, migrations conservées, plusieurs transactions correctes | À renforcer localement, pas à remplacer intégralement |

Les différences 3 qi/5 cartes en duel contre 2 qi/4 cartes par membre en équipe sont des règles d’équilibrage existantes. Elles peuvent devenir des paramètres de rencontre, sans être effacées sous prétexte d’unification. De même, la défaite lorsque la recrue tombe et la pilule du dernier rival sont des règles de scénario à conserver tant qu’un changement n’est pas validé.

## Modèle cible proposé

```text
Combat
├── configuration de rencontre (règles, graine, victoire/défaite)
├── équipe alliée : liste de 1 à 3 personnages
├── équipe adverse : liste de 1 à 3 personnages
├── phases / ordre des actions
└── résolution des cartes, statuts et événements

Personnage en combat
├── définition : identité, PV de base, techniques, apparence
├── état : PV, garde, poison, buffs, qi, KO
├── deck de combat : pioche, main, défausse, épuisées, persistantes
└── contrôle : joueur ou politique d’intentions ennemies
```

L’équipe contient jusqu’à trois personnages, pas obligatoirement trois : le duel est simplement un combat 1v1. Les ennemis peuvent employer une politique d’intentions plutôt qu’un deck de joueur ; leur imposer immédiatement pioche/main changerait le design sans nécessité.

Dans Godot, ces responsabilités peuvent être des classes de données GDScript, indépendantes de la scène graphique. Des définitions réutilisables en Resource, des états de partie en RefCounted et des scènes/Nodes pour l’affichage sont une direction possible, pas une obligation de convertir tout en héritage. Un personnage persistant de campagne et son état temporaire de combat doivent rester distincts.

La vue demande « puis-je jouer cette carte sur cette cible ? » au moteur ; elle ne redéfinit pas la règle. Le moteur valide puis émet les résultats d’action pour les animations. Sauvegarder la campagne et attribuer les récompenses restent à l’extérieur du moteur.

## Migration proposée, sans tout jeter

1. **Fiabilité immédiate** : sauvegardes de duel/apprentissage, ciblage J02, schéma narratif, remise en état des tests. Aucune modification d’équilibrage.
2. **Règles et composants communs** : type de cible des cartes, données de qi/pioche, statut/vie, interface publique du HUD. Migrer la récompense initiale de Lian vers la carte existante.
3. **État Personnage et Deck** : extraire depuis Solo ; une seule source de vérité des PV/garde/effets. Tests des dégâts, du soin, du KO, de la pioche et des persistantes avant branchement des vues.
4. **Combat et Équipe paramétrables** : porter Jun, puis voyageuse, puis 3 contre 3 ; comparer sur graines fixes l’ancien et le nouveau résultat. Tournois, entraînements et tutoriels deviennent des configurations. Poison/pilule restent des règles spécifiques composées avec ce moteur.
5. **Nettoyage contrôlé** : retirer l’adaptateur Solo et les anciennes scènes seulement après parité ; poursuivre les ajouts de contenu ensuite.

Critères de passage : mêmes cartes, cibles, dégâts, garde, pioche et consommation de qi sur scénarios de référence ; fidélité des intentions à l’action résolue ; aucun effet d’un dépôt invalide ; sauvegardes anciennes lisibles ; récompense une seule fois ; échec d’écriture sans progression annoncée ; vérification du tutoriel, Jun avancé, voyageuse, tournoi et laboratoire.

## Limites de l’audit

Inspection transversale des modèles de combat/cartes/calendrier, contrôleurs de campagne et de rencontres, sauvegardes et composants UI, plus exécution d’une sélection de suites existantes. Il ne s’agit ni d’une certification de toutes les branches narratives ni d’un audit de performance GPU/exports. Les scènes de démonstration et `main.tscn` historique sont distinguées des écrans actifs ; leur existence seule n’est pas un défaut. Aucun rééquilibrage, refactor de production ni relancement de la partie en cours pendant cette revue.

## Résultats des exécutions

14 suites lancées : **12 réussies, 2 interrompues après 18 secondes** sur erreur de nœud obsolète. Les deux interruptions ne sont pas comptabilisées comme succès.

- `test_reliability` : erreur / délai maximal atteint.
- `test_card_ways` : erreur / délai maximal atteint.
- `test_combat_ui` : réussite.
- `test_team_hand` : réussite.
- `test_team_guard_rules` : réussite.
- `test_team_tricks` : réussite.
- `test_recruitment` : réussite.
- `test_story_route` : réussite.
- `test_day7_territory` : réussite.
- `test_day4_merchant` : réussite.
- `test_spy_arrival` : réussite.
- `test_orthodox` : réussite.
- `test_deck_manhua` : réussite.
- `test_jun_progression` : réussite.

Le script de reproduction de l’audit confirme séparément les cinq observations enregistrées dans `tests/audit_architecture_results.json`. Il relève les défauts : ce n’est pas un test de correction réussi.

Note sur `test_reliability` : avant l’erreur de nœud, deux comparaisons « Preserve progression, deck and duels » échouent aussi. Le test compare l’état JSON historique brut à l’état migré, au lieu de comparer au modèle restauré/normalisé. Les suites de recrutement et J7 vérifient le parcours de migration séparément et passent. Mettre à jour cet oracle sans supprimer les assertions de conservation des cartes, du deck, des duels et de la progression ; ne pas présenter ces deux échecs comme une perte de sauvegarde démontrée.


## Suivi après autorisation de correction

Les défauts prioritaires de transactions, ciblage J02, validation narrative, tests obsolètes et première récompense ont été corrigés. Les états Personnage/Deck/Équipe sont maintenant extraits et réellement utilisés ; les copies de PV/garde entre deux états ont disparu. La résolution des tours reste répartie entre les adaptateurs solo et équipe ; la généralisation des rencontres n’est pas encore réalisée. Les observations ci-dessus décrivent l’état au moment de l’audit, pas des régressions encore toutes présentes. Voir la section de migration dans PLAN_DEVELOPPEMENT.md et `tests/regression_results.json` (16 suites réussies).


## Suivi de la migration du moteur commun

L’orchestration a depuis été réunie dans `prototypes/combat/encounter.gd`, avec politiques de rencontre et adaptateurs rétrocompatibles. La limite mentionnée dans la section précédente est donc levée pour la résolution : les écrans solo et tournoi passent par le même moteur. Voir [ARCHITECTURE_COMBAT.md](ARCHITECTURE_COMBAT.md) pour les responsabilités exactes, configurations conservées et résultats de validation (dont l’incident natif de fermeture non masqué).
