# Audit des données et responsabilités — 20 novembre 2026

Retour utilisateur vérifié sur la version réelle, plus récente que les numéros de lignes cités. Agent architecture : effets/catalogue ; agent tests : preuves avant/après et régressions ; agent principal : consommateurs, organisation, session, présentation, localisation, commandes, revue et intégration.

| Point | Constat et traitement |
|---|---|
| Effets codés par identifiant | Confirmé. Remplacés par des descriptions d’effets dans `data/cards.json` et un résolveur générique partagé. Dégâts, jeu de carte, coûts, tours persistants, bot et descriptions ne dispatchent plus par ID. |
| Règles de deck dupliquées | Confirmé, y compris dans le laboratoire. API commune pour copies, équipements et exclusions ; les consommateurs y délèguent. |
| Contrôleur principal trop chargé | Confirmé. Session/sauvegardes, dialogues et son extraits ; animations du duel dans un présentateur dédié. Les valeurs stage sont nommées et gardent leurs valeurs de sauvegarde. Le contrôleur reste un coordinateur de scènes ; il n’a pas été remplacé entièrement. |
| mode en texte et appels game.xxx | Ce ne sont pas seuls des bugs : les callbacks vers le coordinateur restent valides. Ils demeurent des points de couplage à réduire quand les écrans évolueront ; pas de promesse de découplage intégral ni d’architecture définitive pour 14 jours. |
| Runtime dans prototypes | Confirmé. Déplacé dans `game/`, chemins de scènes, tests et scripts adaptés. Ancien prototype et modèles propres isolés dans `legacy/prototype/`. |
| Textes dans le code | Confirmé. Cartes/noms et dialogues Lian/Shen/recrutement externalisés ; prose du coordinateur, de la visiteuse et des événements traduisible via clés. Chargement des langues et fallback FR opérationnels. D’autres libellés de menus, calendrier et ancienne scène restent à extraire : aucune traduction complète n’est annoncée. |
| Touches en dur | Confirmé. InputMap pour déplacement/interactions/deck, écran Commandes, persistance séparée et reset. Les indices de dialogue affichent la touche réelle. Échap reste réservé au retour/annulation. |
| Catalogue reparsé | Confirmé. Définitions chargées une fois, variantes mises en cache, résultats copiés profondément pour éviter les mutations partagées. |

## Preuves et corrections détectées pendant le travail

- Référence des effets capturée **avant** la refonte, distincte de l’ancienne référence de migration. Aucune référence historique écrasée pour obtenir un test vert.
- 126 scénarios / 3 890 états et 1 440 états d’effets identiques après changements.
- 22/22 suites du runner passent ; 121 contrôles cartes/règles, 332 contrôles moteur ; test commandes/localisation 84 contrôles en GUI après ajout des vérifications de flèches. Capture `tests/input-settings.png` générée et inspectée localement.
- Normalisation des entiers JSON pour ne pas transformer la garde en décimaux dans les états de référence.
- Cycle de dépendances session/sauvegarde cassé par le module `stages.gd` sans dépendance.
- Le cache statique retenait quatre scripts au shutdown Godot 4.4. Remplacé par un autoload propriétaire de données simples ; fermeture normale dans toutes les suites finales.
- Correction des codes des flèches détectée en inspection graphique, puis tests dédiés.
- 8 fichiers de progression contrôlés par SHA-256 : inchangés. Pas de réécriture des sauvegardes, ni de migration de format.

## Ajouter une carte

1. Ajouter une entrée avec ID stable dans `data/cards.json`, en copiant la structure d’une carte existante.
2. Choisir ses valeurs, son ciblage éventuel et ses effets parmi les types disponibles. Les champs `owner`, `mastery` et `copy_limit` sont explicites.
3. Ajouter `card.<ID>.name` dans les fichiers de langue ; attribuer une illustration et une source d’acquisition dans les données/scènes concernées.
4. Vérifier les règles de collection/exclusivité s’il s’agit d’un équipement ou choix unique et ajouter un test de la nouvelle combinaison.
5. Si l’effet lui-même est nouveau, étendre le résolveur générique et ses descriptions/tests. Ce cas diffère d’ajouter une carte utilisant une mécanique existante.

La composition initiale n’est pas changée dans cet audit ; la proposition 5 attaques / 5 gardes / Taille appuyée / Lecture du duel reste une modification de design séparée. B06 conserve la règle validée : pioche 2 ; coût 1, ou 0 si le deck initial compte au moins 16 cartes.
