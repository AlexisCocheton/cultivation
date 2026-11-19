# Prototypes et premiers résultats de l'étape 4

19 novembre 2026. Rapport historique de la première passe v0.1. Les règles de l'étape 3 ont été validées par le créateur. Cette première passe les met à l'épreuve dans un laboratoire Godot distinct du hub. La version active est désormais décrite dans [le bilan v0.2](ETAPE_04_EQUILIBRAGE_V2.md), avec équilibrage révisé et composition du deck acquise. Les observations ci-dessous restent celles de v0.1.

## Prototypes livrés

Lancer `Laboratoire.cmd` à la racine du projet, ou ouvrir `prototypes/lab.tscn` dans Godot et lancer cette scène. Le hub reste accessible avec `Jouer.cmd`.

| Prototype | Fonctionnement |
|---|---|
| Calendrier | 42 périodes, six séquences prioritaires, activités, dépenses, chantiers et récompenses. Actions indisponibles désactivées, raison en infobulle. |
| Relations | Rangs 0 à 4, une progression par résident et par jour, seuils J3/J6/J10, cartes acquises, intérêt amoureux et scène finale de Lian le soir. |
| Combat | Les trente cartes exécutables, decks légaux de douze cartes, pioche/défausse/retrait, garde, qi, Exposé, combos, soins, perte de PV, intentions et changement de phase. |
| Comparaison | Quatre decks de référence, quatre profils adverses, graine de mélange réglable et variantes expérimentales du boss à +2 ou +4 dégâts par intention. |
| Reprise | Sauvegarde propre au laboratoire ; points de reprise avant préparation J13 et avant final. Défaite finale sans progression vers l'épilogue. |

Le laboratoire est une interface fonctionnelle, pas une nouvelle direction artistique. Les scènes relationnelles et narratives sont représentées par leurs règles et récompenses, sans dialogues finalisés. Les horaires de déplacement restent dans le hub ; les restrictions jour/soir et dates des activités sont éprouvées ici.

Les decks de référence sont volontairement disponibles même si le calendrier n'a pas encore débloqué leurs cartes. Cette séparation permet de tester le combat rapidement, mais ne valide pas encore le parcours complet « acquisition → composition manuelle → combat ». Pas encore d'éditeur de deck libre ni d'équipement interactif à emplacements. L'achat facultatif intégré à S01 n'est pas représenté dans cette première interface : les achats séparés le sont.

## Protocole reproductible

Moteur utilisé : Godot 4.4.1, règles v0.1. Résultats bruts archivés : [prototypes/results-v1.json](../prototypes/results-v1.json). La commande ci-dessous utilise maintenant les tests actifs v0.2 ; le rapport archivé conserve les mesures originales.

Depuis PowerShell à la racine :

```powershell
$env:APPDATA = Join-Path (Get-Location) 'tools/test-user'
& './tools/godot/Godot_v4.4.1-stable_win64_console.exe' --headless --path . --script res://prototypes/run_tests.gd
```

- Deux calendriers témoins complets, chacun exécuté avec victoires puis avec défaites aux combats intermédiaires. Tutoriel et final sont résolus en victoire pour vérifier la clôture des parcours ; les mécanismes d'échec final sont testés séparément.
- 1 200 combats contre l'inspecteur selon les règles validées : quatre decks, trois niveaux de préparation (0, 3 ou 6 améliorations), cent graines par combinaison.
- 600 combats ordinaires : quatre decks, trois profils, cinquante graines par combinaison.
- 800 expériences supplémentaires : quatre decks, trois améliorations, cent graines et deux variantes d'attaque du boss.
- Total : **2 600 combats simulés**, sans repas de bonus de PV. Les mêmes graines sont réutilisées entre variantes pour comparer les résultats.

L'agent choisit une carte avec une heuristique fixe : dégâts, garde utile contre l'intention, pioche et effets particuliers. Il regarde la main et l'état visibles, sans examiner la pioche ni chercher plusieurs tours à l'avance. Un plafond de cinquante tours et cinquante actions par tour détecte les boucles. Cette méthode ne représente ni un débutant ni tous les joueurs experts.

## Résultats techniques

**23 839 vérifications exécutées, zéro échec après correction.** Ce total comprend les vérifications répétées pendant les simulations, pas 23 839 scénarios indépendants. Aucun combat n'atteint la limite de cinquante tours.

Contrôles exercés : restrictions de calendrier, dépenses refusées sans mutation d'état, rangs, choix de serment exclusif, événement unique, plafond des récompenses répétables, sauvegarde/rechargement, protection du point final, légalité des decks de référence, exécution des trente cartes, conservation des douze cartes entre zones, limites de main, retrait temporaire, coût en qi, combos, ordre des dégâts, guérison, mort simultanée et phase du boss.

Un défaut a été détecté puis corrigé : les nombres relus depuis JSON ne conservaient pas leur type entier dans les structures imbriquées du calendrier. La restauration normalise maintenant les compteurs avant de les réutiliser. Le test aller-retour passe après correction.

L'interface a été lancée et inspectée sur des captures du calendrier et du combat. Cela ne constitue pas un test utilisateur de toute la campagne. La sauvegarde du laboratoire est indépendante de celle du hub ; l'écriture atomique avec récupération après interruption prévue pour la production n'est pas encore implémentée dans ce laboratoire.

## Calendrier et relations

| Parcours | Résultat des combats intermédiaires | Périodes | Événements vus | Améliorations | Réserves finales |
|---|---|---|---|---|---|
| Reconstruction et liens | Défaites | 42 | 21 | 6 | 14 |
| Reconstruction et liens | Victoires | 42 | 21 | 6 | 30 |
| Combat et équipement | Défaites | 42 | 21 | 3 | 26 |
| Combat et équipement | Victoires | 42 | 21 | 3 | 42 |

Le premier parcours atteint Lian 4, Jun 3, Shen 2, et peut conclure la romance. Le second atteint Lian 2, Jun 4, Shen 3. Aucun ne nécessite de terminer les trois relations. Le point final reste disponible après défaite et permet une nouvelle tentative.

**Conclusion limitée :** les deux chemins spécifiés sont réalisables sans dépendre des revenus de combat. Cela ne démontre pas que toutes les décisions possibles évitent une mauvaise préparation, ni que les choix sont intéressants.

**Problème à examiner :** le surplus de 30 à 42 réserves après un parcours gagnant est élevé. La cuisine améliorée et les récompenses additionnées diminuent le poids des arbitrages économiques. Avant de réduire les gains, essayer une partie humaine : le surplus peut aussi amortir les erreurs. Aucun coût validé n'a été modifié automatiquement.

## Combat selon les règles validées

Inspecteur sans amélioration de bâtiment, sans repas, cent graines par deck :

| Deck | Victoires | Tours moyens jusqu'à la fin | PV moyens restants |
|---|---|---|---|
| Départ | 100/100 | 11,51 | 18,84 |
| Jun offensif | 100/100 | 6,79 | 23,64 |
| Shen défensif | 100/100 | 13,28 | 39,09 |
| Lian enchaînements | 100/100 | 8,32 | 21,26 |

Les trois styles produisent des comportements différents : Jun termine rapidement, Shen absorbe presque tout mais reste longtemps en combat, Lian se situe entre les deux. Les trois profils ordinaires sont également vaincus dans toutes les graines simulées avec cette heuristique.

**Problème prioritaire :** la préparation n'est pas nécessaire pour gagner contre ce boss avec cet agent, même avec le deck initial. Le résultat signale un risque de défi insuffisant ; il ne prouve pas qu'un joueur découvrant le jeu gagnera toujours. La durée cible de 3 à 5 heures n'est pas validée par ces nombres de tours.

## Expériences de difficulté

Inspecteur avec trois améliorations de bâtiment, sans repas, cent graines par ligne. Le bonus s'ajoute à chaque intention d'attaque du boss et ne modifie pas sa garde. Il est uniquement activable dans le laboratoire ; les règles approuvées restent à bonus zéro.

| Deck | Référence | Bonus de 2 dégâts | Bonus de 4 dégâts |
|---|---|---|---|
| Départ | 100 % | 97 % | 61 % |
| Jun offensif | 100 % | 100 % | 97 % |
| Shen défensif | 100 % | 100 % | 100 % |
| Lian enchaînements | 100 % | 100 % | 62 % |

**Interprétation :** augmenter globalement les attaques ne résout pas seul le problème. À +4, Lian reste proche du deck de départ alors que Shen et Jun demeurent très fiables pour cet agent. Shen gagne avec peu de risque mais des combats longs ; cette sécurité peut devenir la stratégie dominante pour un joueur prudent.

Pistes à prototyper ensuite, une à la fois : intentions demandant une préparation différente, fenêtres où attaquer est préférable à défendre, meilleure récompense des enchaînements de Lian, et réduction d'une défense trop efficace. Ne pas augmenter simultanément dégâts, PV du boss et coûts des cartes : on perdrait la cause des différences observées.

## Décisions de cette passe

| Sujet | Décision |
|---|---|
| Calendrier de 14 jours | Conservé pour les essais humains ; les deux parcours de référence passent. |
| Quatre rangs de relation | Conservés ; seuils et restrictions fonctionnent. Les choix narratifs restent à écrire et tester. |
| Deck de douze cartes | Conservé ; les decks de référence sont légaux et les cartes ne disparaissent pas pendant les simulations. |
| Économie | Alerte sur l'abondance des réserves ; aucune modification des coûts avant observation d'une partie. |
| Boss | Équilibrage non validé. Variantes +2/+4 disponibles pour comparaison, sans remplacer la référence. |
| Migration du hub | Différée jusqu'à validation des comportements clés ; pas de modification de la partie existante. |
| Passage à l'étape suivante | Pas encore de clôture de l'étape 4 : tests humains et intégration acquisition/deck nécessaires. |

## Essai humain proposé

1. Ouvrir le laboratoire et jouer un duel avec le deck de départ contre le partenaire, graine 42, règles validées. Vérifier si les coûts, intentions et cartes retirées sont compris.
2. Jouer Jun, Shen puis Lian contre l'inspecteur, avec les règles validées et une même graine. Noter difficulté ressentie, temps réel et décisions intéressantes. Relancer le laboratoire pour repartir sans bonus de bâtiment si nécessaire.
3. Essayer le bonus expérimental +2, puis éventuellement +4. Noter les moments où la défaite semble évitable ou injuste ; ne pas conclure à partir du seul pourcentage du simulateur.
4. Parcourir quelques journées : tenter une deuxième progression avec un même résident, attendre un nouveau rang, choisir entre chantier et relation. Vérifier la compréhension des indisponibilités.
5. Après une défaite finale, charger le point préalable et modifier le deck de référence. Vérifier qu'aucun jour n'est perdu et qu'aucune récompense ne se duplique.

À consigner : version, deck, profil, graine, niveau de reconstruction, bonus expérimental, résultat, nombre de tours, durée réelle, confusion rencontrée et choix jugé intéressant. Aucun retour humain n'est encore enregistré dans ce rapport.

## Prochain lot de l'étape 4

1. Recueillir ces premiers retours, puis tester un changement d'équilibrage à la fois.
2. Relier la collection du calendrier à un éditeur de deck et aux emplacements d'équipement ; tester une campagne sans cartes offertes par le mode laboratoire.
3. Écrire une scène de lien représentative avec un choix, puis observer si son effet est compris.
4. Mesurer le temps réel de fabrication et de jeu du lot avant de confirmer les objectifs de durée et le calendrier de production.
