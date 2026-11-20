# Architecture du combat

État intégré le 20 novembre 2026. Le moteur de résolution est désormais commun aux duels et au tournoi. Ce document décrit le code présent, pas une architecture future.

## Responsabilités

```text
Campagne (calendrier, récompenses, sauvegarde)
  └─ Adaptateur de rencontre
     ├─ battle.gd : Jun / voyageuse / profils solo historiques
     └─ team_battle.gd : tournoi et laboratoire
          └─ Encounter : phases, cartes, cibles, dégâts, garde, statuts, KO
             ├─ TeamState alliée : 1 à 3 CharacterState
             ├─ TeamState adverse : 1 à 3 CharacterState
             ├─ Configuration : qi, pioche, conditions de défaite
             └─ Politique : intentions et événements particuliers

CharacterState
  ├─ état unique : PV, garde, poison, apparence, intention
  ├─ qi, bonus, Force, nombre de cartes jouées
  ├─ catalogue contextualisé par rangs / équilibrage
  └─ DeckState : main, pioche, défausse, épuisées, persistantes, RNG
```

`game/combat/encounter.gd` résout effectivement les cartes et les phases des deux formats. Les anciens fichiers ne contiennent plus deux versions de ces règles. `battle.gd` expose des accesseurs pour les anciens contrôleurs ; les façades `cores` du tournoi référencent **le même Encounter**. Le moteur ne référence pas ces façades : pas de dépendance circulaire.

Les personnages ennemis peuvent avoir un deck, mais les rencontres actuelles utilisent des intentions calculées par une politique. Leur imposer une main de joueur n’est pas nécessaire à l’unification.

## Construire une rencontre

1. Créer un `CharacterState` par participant avec son nom, ses PV et son apparence. Préparer le deck des participants contrôlés avec `prepare_deck(deck, seed, qi_initial, pioche_initiale, rangs)` et vérifier l’erreur renvoyée.
2. Ajouter les personnages à deux `TeamState` distincts. La configuration refuse les équipes vides, celles de plus de trois personnages et les objets CharacterState réutilisés dans plusieurs places.
3. Créer une politique par rencontre : `DuelPolicy` pour les cycles existants ou une nouvelle politique spécifique. Ne pas partager une instance mutable entre plusieurs combats.
4. Appeler `Encounter.configure(allies, enemies, config, policy)` et vérifier son résultat avant d’afficher le combat.

`prepare_deck` définit la main et le qi de départ ; `config.qi` et `config.draw` définissent la recharge aux manches suivantes. Le code d’ouverture d’une rencontre doit passer des valeurs cohérentes. Le tournoi conserve volontairement sa séquence de mélange historique pour maintenir exactement les tirages de ses graines existantes.

Exemple de création, avec ressources de départ et de recharge identiques :

```gdscript
const Character = preload("res://game/combat/character_state.gd")
const Team = preload("res://game/combat/team_state.gd")
const Combat = preload("res://game/combat/encounter.gd")
const DuelPolicy = preload("res://game/combat/duel_policy.gd")

func build_duel(deck: Array, seed_value: int):
    var hero = Character.new("Recrue",45,0)
    var error = hero.prepare_deck(deck,seed_value,3,5)
    if error != "": return null
    var allies = Team.new()
    var enemies = Team.new()
    allies.add(hero)
    enemies.add(Character.new("Jun",30,1))
    var policy = DuelPolicy.new()
    policy.profile = "partenaire"
    var combat = Combat.new()
    error = combat.configure(allies,enemies,{"qi":3,"draw":5},policy)
    return combat if error == "" else null
```

L’exemple expose l’API générique ; pour les duels de campagne existants, utiliser l’adaptateur `battle.gd`, qui ajoute les réglages historiques détaillés plus bas.

## Contrat entre moteur et interface

- `can_play(source,index)` : le personnage actif est vivant, sa phase est ouverte, la carte existe et son qi suffit.
- `target_kind(source,index)` / `valid_target(source,index,target)` : le moteur est la source de vérité du ciblage. J02 vise l’ennemi ; une garde pure peut viser un allié vivant ; attaque+garde vise l’ennemi et protège uniquement son lanceur.
- `play(source,index,target)` : valide avant toute dépense, puis applique les effets une seule fois.
- `select_actor` et `end_actor_turn` : contrôlent le passage entre alliés. Un compagnon KO par sa propre technique ne bloque pas le tour suivant.
- `begin_resolution` / `resolve_next` / `finish_round` : la vue peut animer les actions une par une ; les dégâts et changements de phase restent dans le moteur. Un second `finish_round` ne rejoue pas les effets.
- `events` : événements visuels à consommer par le contrôleur ; leur cible est un index de personnage, jamais une recherche par égalité des dictionnaires.

Les index d’unités sont les alliés d’abord, puis les ennemis. La frontière est `allies.members.size()`, pas une constante 3 dans le moteur. Les contrôleurs de présentation actuels restent conçus pour leurs scènes 1v1 et 3v3 ; le moteur 2v3 est testé mais n’ajoute pas automatiquement un nouvel écran de campagne.

La main partagée (`visual/team/hand.gd`) dépend de trois méthodes de son contrôleur : `hand_model()`, `can_play_card(index)`, `hand_blocked()`. Elle ne reconstitue plus de fausse structure de combat solo et ne recalcule plus elle-même les autorisations de jeu.

## Règles de rencontre conservées

| Paramètre | Duel historique | Tournoi |
| --- | --- | --- |
| Qi par personnage / tour | 3 | 2 |
| Pioche de base | 5 | 4 |
| Défaite si la recrue tombe | Oui | Oui |
| Politique | `duel_policy.gd` | `territory_policy.gd` |
| Tricheries | Aucune | Enduit au deuxième tour, ensuite 9 directs + 9 poison ; pilule du dernier survivant |

Les réglages `discard_before_enemy=true` et `consume_guard=false` préservent les états intermédiaires du duel historique : défausse avant l’adversaire, garde non décrémentée lors du coup puis remise à zéro au prochain tour survivant. Le tournoi consomme la garde à chaque coup et défausse à la fin de la manche. Ce sont des paramètres explicites du même résolveur, pas une seconde implémentation. Ne pas changer ces paramètres dans une refonte technique sans validation de gameplay.

La politique de tournoi porte les trois rôles adverses et l’intervention de pilule. Un nouvel ensemble d’ennemis se définit via sa politique/sa construction de rencontre ; ne pas ajouter une condition de scénario dans `Encounter.play`.

## Ajouter ou modifier une mécanique

- Une carte ou son ciblage : catalogue/règle commune `Cards.target_kind` et résolution unique dans Encounter ; vérifier la description et le rendu de carte.
- Un statut ou un changement de tour : moteur commun / CharacterState, avec tests en duel et en équipe.
- Une intention ou une intervention propre à un boss : politique, avec intention fidèle à l’action résolue.
- Un visuel : composants communs ou contrôleur ; aucune écriture directe de PV/qi pour produire une animation.
- Une récompense : contrôleur de campagne et transaction de sauvegarde, jamais le moteur de combat.

Les champs de compatibilité restent accessibles pour les tests et les anciens contrôleurs ; leur accessibilité n’est pas une invitation à modifier directement l’état depuis les futurs écrans.

## Vérification

`python tools/run_regressions.py` lance les suites dans un profil isolé et rejette un code de sortie non nul ou une erreur GDScript, même après un message PASS.

- `test_combat_parity.gd` : 126 scénarios / 3 890 états, capturés avant la migration. Ne pas régénérer `combat_parity_baseline.json` pour masquer une différence.
- `test_encounter_engine.gd` : 332 contrôles directs, formats 1v1/2v3/3v1/3v3, phases, cibles, KO, configuration invalide, relance et identité du poison.
- Suites campagne : progression, sauvegardes/migrations, recrutement, marchand, J7 et arrivée J8.
- Vérifications graphiques : HUD solo/voyageuse, main glissée, vie/garde/intentions du tournoi.

Résultat de cette intégration : première passe 18/18 ; seconde passe 17/18 à cause d’un crash natif intermittent de Godot à la fermeture de `test_audit_fixes`, après ses assertions réussies. Trois relances ciblées et un contrôle verbose séparé ont ensuite quitté normalement. Ce problème de fermeture avait déjà été observé avant la migration et reste non résolu ; il n’est pas effacé du rapport. Résultats dans `tests/regression_results.json` et `tests/audit_closure_rechecks.json`.


## Effets et données de cartes (audit complémentaire)

`data/cards.json` définit les valeurs de base, la voie, les limites, la maîtrise et les effets. `game/cards.gd` construit les variantes de maîtrise et retourne des copies profondes : un personnage, un test ou un réglage ne peut pas modifier le catalogue d’un autre personnage. `game/data_cache.gd`, autoload `DataCache`, possède les caches pendant la vie de l’application. Pas de cache statique GDScript persistant au shutdown.

`game/combat/card_effects.gd` résout les types d’effets (bonus, exposition, soin, perte de PV, coût conditionnel, dégâts de combo ou selon taille, pioche conditionnelle, persistants). `damage_for`, `play`, `begin_turn`, le bot et les descriptions délèguent à ces données. Une nouvelle carte combinant les effets disponibles nécessite une entrée JSON et ses ressources, pas une condition par ID dans le moteur. Un **nouveau type de mécanique** nécessite naturellement un gestionnaire et ses tests.

`Cards.copy_limit`, `Cards.equipment_slot`, `Cards.exclusive_conflict`, `EQUIPMENT_GROUPS` et `EXCLUSIVE_GROUPS` sont utilisés par la validation, les propositions de deck, le menu et le laboratoire. Les groupes exclusifs d’équipement réutilisent les groupes d’emplacements.

Les adaptateurs restent en place pour les écrans existants. La session de campagne et le stockage sont dans `game/campaign/` ; `stages.gd` porte les valeurs sérialisées sans dépendre du stockage. `visual/combat/presenter.gd` orchestre les animations du duel, sans décider des effets de carte.

Validation finale de cet audit : 22 suites sur 22 passent ; 126 scénarios / 3 890 états de combat et 1 440 états d’effets sans différence ; 121 contrôles de règles/données, 332 du moteur. L’écran des commandes a aussi passé 84 contrôles en mode graphique, flèches comprises. Les erreurs de ressources retenues introduites lors de cette refonte sont corrigées ; cela ne prétend pas supprimer tout crash natif intermittent de Godot déjà signalé historiquement.
