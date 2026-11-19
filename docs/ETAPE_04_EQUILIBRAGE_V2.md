# Équilibrage et composition du deck depuis la collection

19 novembre 2026. Deuxième passe de l'étape 4, autorisée par le créateur après les premiers résultats. Version active du laboratoire : **v0.2**. Le hub visuel lancé par `Jouer.cmd` conserve ses règles précédentes ; les changements décrits ici sont jouables avec `Laboratoire.cmd`.

## Changements retenus

### Combats

Le boss ajoute maintenant 2 dégâts à ses intentions dès le départ, puis 2 dégâts supplémentaires tous les trois tours : +2 aux tours 1 à 3, +4 aux tours 4 à 6, +6 aux tours 7 à 9, etc. L'intention affichée inclut le total ; elle n'est jamais modifiée après que le joueur a commencé son tour. Cette pression s'ajoute au changement de phase existant et ne concerne pas les autres adversaires.

Les PV du boss et l'avantage des bâtiments restent identiques : 84 PV moins 3 par amélioration, jusqu'à 66 PV. Le repas de cuisine niveau 2 porte toujours les PV du héros à 50 au final.

| Carte | Avant | Maintenant | But |
|---|---|---|---|
| Pétales tranchants, L01 | 10 dégâts en combo | 12 dégâts en combo | Récompenser les deux cartes préparatoires. |
| Prunier dansant, L03 | 12 dégâts, avec pioche conditionnelle | 18 dégâts et pioche 1 en combo ; 12 dégâts sinon | Donner à Lian un vrai tour offensif après préparation. |
| Racines profondes, H01 | 9 garde | 8 garde | Réduire légèrement la sécurité de Shen. |
| Mur de jade, H03 | 12 garde et 5 dégâts | 10 garde et 5 dégâts | Garder son identité défensive sans neutraliser trop facilement les intentions. |

Les coûts en qi, le nombre de cartes, les règles de combo et les autres cartes ne changent pas. La configuration active est centralisée dans `prototypes/balance.gd`. Les bonus expérimentaux +2/+4 restent dans le bac à essais hors calendrier uniquement ; les combats de campagne utilisent v0.2 sans ce supplément.

### Ressources

| Source ou dépense | v0.1 | v0.2 |
|---|---|---|
| Réserves initiales | 6 | 6 |
| Aide à la secte | +3 | +2 |
| Aide avec cuisine niveau 1 | +4 | +3 |
| Récompense matérielle de M02/M03/M05/S02/S03/S04/S06 | +2 | +1, avec les mêmes conditions de victoire |
| Duel libre gagné | +2 | +1 |
| Sentier libre gagné | +3 | +2 |
| Nombre de victoires libres rémunérées | 6 | 3, compteur partagé duel/sentier |
| Équipement | 2 | 3 |
| Équipement avec atelier niveau 2 | 1 | 2 |
| Chantiers | 3 puis 4 | Inchangé |

Les événements qui ne donnaient pas de réserves n'en donnent toujours pas. Les cartes et les objets restent acquis définitivement. L'aide à la secte est toujours disponible, y compris après plusieurs défaites.

Le calendrier témoin de reconstruction déplace l'aide du J12 soir au J11 soir, et la cuisine niveau 2 au J12 soir. Ce changement respecte les 42 périodes et évite une dépense prématurée lorsque tous les combats intermédiaires sont perdus. Il ne nécessite pas de période supplémentaire.

## Éditeur de deck jouable

Dans le laboratoire, ouvrir **Composer mon deck**. Le panneau présente les douze cartes sélectionnées, les cartes réellement acquises, ainsi que les emplacements arme, talisman et sacoche.

- Cliquer une technique sélectionnée pour la retirer, puis une carte de la collection pour l'ajouter.
- Deux exemplaires maximum par technique de base, un seul pour les autres.
- Les cartes non acquises ne sont pas proposées et sont rejetées également par le modèle de règles, même si l'interface est contournée.
- Équiper un objet ajoute sa carte au deck. Si cela donne treize cartes, le joueur doit retirer une technique ; la validation reste bloquée jusqu'à douze.
- Retirer une carte d'équipement se fait par son emplacement, ce qui évite un équipement actif sans sa carte.
- Les suggestions Jun/Shen/Lian utilisent uniquement la collection possédée. Les techniques manquantes sont remplacées par des cartes accessibles, sans débloquer artificiellement leur source.
- **Compléter les places libres** conserve en priorité le contenu choisi et les équipements, puis ajoute des techniques disponibles jusqu'à douze.
- Enregistrer valide le deck et l'équipement ensemble, sans coût en temps ou en réserves. Annuler conserve la composition précédente.

Tous les combats du calendrier utilisent désormais ce deck. Le choix de deck de référence ne s'applique qu'au bouton **Duel hors calendrier**, clairement séparé. La collection, le deck et les trois emplacements sont sauvegardés et restaurés avec les points de reprise.

La sauvegarde v0.2 est distincte : `laboratoire_etape4_v2.json`, dans le dossier utilisateur du laboratoire. Les anciennes sauvegardes ne sont ni supprimées ni écrasées. Le modèle sait rétablir un deck initial légal lorsqu'un ancien état ne contient pas encore de deck ; l'interface ouvre et charge la nouvelle sauvegarde v0.2 uniquement.

## Comparaison des variantes de combat

Neuf configurations ont été comparées, référence comprise, avec quatre decks, trois niveaux de restauration et cent graines par combinaison : **10 800 combats de calibration**. Même agent glouton que lors de la première passe, sans nouvelle anticipation cachée. Données et configurations : [balance_results.json](../prototypes/balance_results.json). Le script `prototypes/calibrate.gd` permet de reproduire cette comparaison.

Le choix retenu augmente progressivement le danger des combats trop longs et renforce les combos de Lian. Une hausse générale de dégâts seule avait déjà montré son insuffisance. La configuration v0.2 n'est pas une promesse d'équilibre définitif : il s'agit du meilleur compromis de cette comparaison limitée.

### Résultats des decks de référence

Inspecteur, trois améliorations, sans repas, cent graines par deck ; aucun supplément expérimental :

| Deck | Victoires v0.1 | Victoires v0.2 | Tours moyens v0.2 | PV moyens v0.2, défaites incluses |
|---|---|---|---|---|
| Départ | 100 % | 14 % | 11,62 | 0,70 |
| Jun offensif | 100 % | 100 % | 5,95 | 15,02 |
| Shen défensif | 100 % | 93 % | 14,58 | 16,41 |
| Lian enchaînements | 100 % | 90 % | 7,14 | 7,68 |

Sans reconstruction, v0.2 donne 1 %, 93 %, 71 % et 51 % respectivement. Avec six améliorations, sans repas, les résultats passent à 33 %, 100 %, 100 % et 99 %. La préparation a donc un effet mesurable pour cet agent ; un deck initial inchangé est désormais un choix risqué au final.

Jun conserve un avantage de vitesse et une très grande fiabilité. Shen reste lent. Lian demande de mieux préparer les tours. Ces écarts doivent être examinés par des joueurs avant de déclarer les trois styles équilibrés ; on ne cherche pas à forcer artificiellement des taux égaux pour une seule heuristique.

## Économie des parcours témoins

| Parcours | Combats intermédiaires | Réserves finales v0.1 | Réserves finales v0.2 |
|---|---|---|---|
| Reconstruction, six améliorations | Tous perdus | 14 | 4 |
| Reconstruction, six améliorations | Tous gagnés | 30 | 9 |
| Équipement, trois améliorations et deux acquisitions | Tous perdus | 26 | 13 |
| Équipement, trois améliorations et deux acquisitions | Tous gagnés | 42 | 18 |

Les deux parcours conservent quatre périodes libres et aucun solde négatif. Le second garde davantage de réserves parce qu'il réalise trois améliorations de moins : l'argent restant constitue une possibilité de reconstruire davantage, pas une récompense supplémentaire cachée. Les ressources sont moins abondantes sans imposer de victoire pour financer les six améliorations.

## Campagnes avec acquisitions réelles

Deux parcours et trois préférences de deck ont été simulés sur cinquante graines chacun : **300 campagnes, 3 600 combats**. Les relations débloquent leurs cartes au cours du calendrier ; les événements perdus ne donnent pas leurs récompenses ; l'équipement doit être acheté avant d'être sélectionné. Avant chaque combat, la suggestion de deck filtre la collection effectivement acquise. Le baume est équipé après son acquisition. Le repas s'applique seulement au parcours avec cuisine niveau 2.

| Parcours | Préférence de deck | Final gagné | Rencontres intermédiaires gagnées |
|---|---|---|---|
| Reconstruction | Jun | 50/50 | 550/550 |
| Reconstruction | Shen | 50/50 | 550/550 |
| Reconstruction | Lian | 50/50 | 550/550 |
| Équipement | Jun | 50/50 | 550/550 |
| Équipement | Shen | 49/50 | 550/550 |
| Équipement | Lian | 44/50 | 550/550 |

Une préférence ne signifie pas que le deck de référence complet est disponible : le parcours équipement ne termine que deux rangs chez Lian, et le parcours reconstruction n'acquiert pas ses armes. Les cartes manquantes sont remplacées, sans fraude à la collection. Ces tests valident cette chaîne d'acquisition pour les deux itinéraires, pas toutes les compositions possibles.

Toutes les rencontres intermédiaires restent gagnées par l'agent. Elles servent actuellement d'apprentissage et de préparation ; leur intérêt et leur difficulté devront être observés en partie réelle. Le plafond de trois récompenses de combat réduit l'incitation à les répéter pour leurs ressources.

## Vérifications et limites

La suite active exécute **43 927 vérifications répétées, sans échec**. Elle inclut les 2 600 duels de référence et expérimentaux, les 3 600 combats de campagne, les parcours économiques avec défaites, ainsi que les tests de propriété, légalité, sauvegarde et interface. Les 10 800 combats de calibration sont enregistrés séparément : total de cette passe finale, **17 000 combats simulés**, avec réutilisation volontaire de graines entre configurations. Ce ne sont pas 17 000 observations de joueurs indépendants.

Tests supplémentaires : rejet atomique d'une carte non possédée ; refus d'un deck de onze cartes ; cohérence carte/équipement ; suggestion limitée à la collection ; restauration du deck depuis disque et checkpoint ; récupération d'un ancien état ; blocage d'un deck illégal au final ; interface de sélection ; insertion d'équipement à treize cartes ; indépendance des presets de bac à essais et du deck de campagne.

L'éditeur a été lancé et inspecté visuellement. Les tests utilisent les fonctions réellement appelées par ses boutons. Aucune durée de jeu humaine ni appréciation du plaisir n'a encore été mesurée. L'écriture atomique des sauvegardes et les dialogues finalisés restent des travaux de production distincts.

## État du plan

- Équilibrage v0.2 appliqué au laboratoire et documenté dans les règles.
- Composition du deck à partir des acquisitions implémentée et utilisée dans les combats de campagne.
- Ancien rapport conservé dans [ETAPE_04_RESULTATS.md](ETAPE_04_RESULTATS.md) ; résultats bruts v0.1 dans [results-v1.json](../prototypes/results-v1.json).
- Résultats actifs dans [results.json](../prototypes/results.json), copie de cette passe dans [results-v2.json](../prototypes/results-v2.json).
- Étape 4 toujours ouverte : jouer plusieurs compositions manuelles, observer les choix de calendrier et écrire/tester une scène relationnelle représentative avant la migration vers le hub.

## Essai conseillé maintenant

Démarrer une nouvelle simulation v0.2. Faire le tutoriel, rencontrer un résident, ouvrir l'éditeur et remplacer une technique de base par sa carte nouvellement apprise. Acheter puis équiper une arme lorsque l'atelier ou le marchand est disponible. Vérifier en duel que cette carte apparaît réellement. Au final, retenter avec une autre composition après défaite, en conservant la collection acquise.
