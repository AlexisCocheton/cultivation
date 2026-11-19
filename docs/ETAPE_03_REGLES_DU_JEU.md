# Règles du jeu et conception des systèmes

Version 0.2 du 19 novembre 2026, ajustée après les tests de l’étape 4 à la demande du créateur. Périmètre et règles validés par le créateur. Ce document définit la référence de conception ; il ne décrit pas intégralement le hub actuel. Les valeurs numériques sont des valeurs de départ à tester, pas un équilibrage final. Les résultats actuels et les différences avec v0.1 sont consignés dans [le bilan v0.2](ETAPE_04_EQUILIBRAGE_V2.md).

## Objectif et limites

Une recrue rejoint une secte déchue et dispose de quatorze jours pour se préparer à l'inspection finale. Elle développe ses relations, construit un deck, participe à la vie collective et restaure les lieux. La victoire au duel final conclut l'histoire ; les liens et les chantiers déterminent les textes d'épilogue et les avantages de préparation.

Le jeu reste dans le périmètre accepté : une recrue, trois résidents, deux visiteurs, trente cartes distinctes, cinq lieux dans trois scènes, vingt-quatre événements écrits, trois chantiers à deux niveaux et une romance facultative. Il n'y a ni expérience à accumuler, ni faim, ni durabilité, ni génération procédurale de campagne. La progression repose sur les cartes, les liens, l'équipement et les bâtiments.

## Calendrier et temps

### Périodes

Une journée comporte matin, après-midi et soir. Le calendrier contient exactement 42 périodes, indexées de 1 à 42. L'arrivée occupe la première ; l'inspection occupe la dernière. Le temps ne passe jamais en temps réel.

Marcher, lire une réplique d'ambiance, consulter le journal, sélectionner un deck, changer d'équipement ou sauvegarder ne consomme aucune période. Une activité engagée consomme une période, combat et dialogue associé compris. Le soir terminé conduit au matin suivant. Il n'existe pas de jour 15 jouable dans cette campagne.

Avant confirmation, l'interface affiche coût en temps, coût matériel, récompense connue et prochaine échéance. Annuler avant de commencer ne coûte rien. Après engagement, l'activité est résolue avant la transition de période ; une fermeture du jeu permet de reprendre depuis la sauvegarde préalable.

### Événements principaux réservés

| ID | Période | Événement | Fonction et récompense |
|---|---|---|---|
| M01 | J1 matin, 1 | Arrivée | Création de la recrue, initiation et duel tutoriel sans pénalité. Deck de départ remis avant le duel. |
| M02 | J3 matin, 7 | L'annonce de l'inspection | Échéance exposée ; choix entre E01 et E02 ; +1 réserve. |
| M03 | J6 matin, 16 | Incident sur le sentier | Premier affrontement extérieur ; ouverture du sentier libre ; victoire : +1 réserve. |
| M04 | J9 matin, 25 | Défi intermédiaire | Combat contre Jun avec le profil partenaire avancé ; victoire : carte E07. Une défaite ne bloque pas la suite. |
| M05 | J13 matin, 37 | Veillée de préparation | Bilan des liens, chantiers et cartes ; avertissement avant le final ; +1 réserve. Sauvegarde de préparation distincte. |
| M06 | J14 soir, 42 | Inspection et conclusion | Sauvegarde préalable, préparation du deck, duel final et épilogue en cas de victoire. |

Ces six séquences sont prioritaires lorsqu'on entre dans leur période. Aucune activité facultative n'est alors lancée. Les 36 autres périodes restent disponibles. La conclusion appartient à M06 et ne compte pas comme un vingt-cinquième événement.

## Déplacement, lieux et disponibilités

Le joueur utilise ZQSD/WASD, les flèches ou le clic. L'interaction nécessite d'être à proximité ; cliquer un personnage commande d'abord une approche. Les bâtiments et obstacles bloquent le passage. Les horaires changent à la transition de période, pas pendant une activité engagée. Une interaction en cours ne peut pas être invalidée par le départ du PNJ.

| Personnage | Matin | Après-midi | Soir |
|---|---|---|---|
| Lian | Prunier, dans la cour | Cour d'entraînement | Cuisine/résidence |
| Jun | Cour d'entraînement | Atelier | Cour d'entraînement |
| Shen | Entrée du pavillon | Prunier | Pavillon |

Tant que le pavillon n'est pas restauré, Shen reste accessible à sa porte. Aucun chantier ne supprime l'accès à un résident ni à la préparation gratuite du deck. Le journal indique le lieu prévu ; le déplacement du PNJ jusqu'à ce lieu est animé et le joueur peut l'approcher en chemin.

Le marchand visite la cour J4, J8 et J12, toute la journée hors événement prioritaire. L'inspecteur apparaît uniquement dans M06. Le sentier devient explorable après M03 et reste accessible matin et après-midi ; la nuit, les activités de la secte restent disponibles.

## Activités et ressources

### Ressource commune

Les réserves représentent nourriture, matériaux et entraide, sans monnaie séparée. Départ : 6 réserves. Solde entier, toujours positif ou nul. Les conditions et coûts sont vérifiés avant engagement ; récompenses et dépenses sont appliquées une seule fois à la résolution de l'activité.

| Activité | Disponibilité | Coût | Résultat |
|---|---|---|---|
| Aider la secte | Cuisine, toute période libre | 1 période | +2 réserves. Activité répétable, toujours accessible. |
| Scène de lien | Résident disponible, conditions remplies | 1 période | +1 rang de lien, scène et récompense du rang. |
| Duel d'entraînement | Jun, matin/après-midi libres | 1 période | +1 réserve en cas de victoire ; aucune perte matérielle en cas de défaite. |
| Sortie sur le sentier | Après M03, matin/après-midi libres | 1 période | Une rencontre ; +2 réserves si victoire. Aucun coût matériel d'entrée. |
| Chantier | Lieu concerné, période libre | 1 période et coût du niveau | Niveau permanent, changement visible et fonction débloquée. |
| Acquérir un équipement | Atelier ouvert ou marchand présent | 1 période et 3 réserves | Choix d'un équipement non possédé, acquisition permanente. |
| Événement secondaire | Déclencheur indiqué dans le journal | 1 période, coût particulier annoncé | Choix et récompense spécifiques. |
| Repos | Toute période libre | 1 période | Passage du temps, sans bonus de combat cumulable. Jamais imposé pour récupérer des PV. |

Une acquisition auprès du marchand intégrée à S01 ne coûte pas une seconde période. Un achat ordinaire ultérieur constitue une activité. Rééquiper un objet déjà possédé est gratuit. Le marchand et l'atelier ne permettent pas d'acheter plusieurs fois le même équipement.

Les récompenses de réserves des combats facultatifs diminuent à zéro après trois victoires facultatives cumulées sur la campagne ; leurs règles restent visibles et on peut continuer à s'entraîner. Les récompenses des événements uniques ne sont pas concernées. Cette limite empêche de transformer le hub en répétition d'un duel lucratif ; l'aide à la cuisine reste une solution fiable.

## Relations, rivalité et romance

Chaque résident possède quatre rangs, de 0 à 4, correspondant exactement à quatre scènes écrites. Aucun compteur d'affection caché ni cadeau répétable n'est nécessaire. Une scène réussie augmente le rang d'un point. On ne peut faire progresser un même résident qu'une fois par jour.

| Rang atteint | Conditions | Récompense |
|---|---|---|
| 1 | Après l'arrivée, dès J1 après-midi | Première technique du résident. |
| 2 | Rang 1 et J3 ou plus | Deuxième technique. |
| 3 | Rang 2 et J6 ou plus | Troisième technique. |
| 4 | Rang 3 et J10 ou plus | Résolution de l'arc, variation d'épilogue ; aucune carte exclusive supplémentaire. |

Chaque scène propose un choix de posture. Pour Jun : rivalité franche ou camaraderie. Pour Shen : discipline ou recherche personnelle. Pour Lian : confiance amicale ou intérêt amoureux. Ces choix modifient quelques répliques et l'épilogue, pas le coût de progression ni les trois cartes obtenues. Ils ne créent pas de nouvelles scènes à produire en dehors des douze prévues.

La romance avec Lian se décide explicitement au rang 4, le soir, si le joueur a exprimé son intérêt au rang 3. Un refus laisse la relation amicale intacte. La version amicale du rang 4 est toujours accessible. Tous les personnages sont adultes. Aucun bonus de combat n'est réservé à la romance.

Les liens ne diminuent pas avec le temps. Les scènes non jouées restent disponibles jusqu'au final. Il n'est pas nécessaire de terminer les trois arcs ; trois styles de deck restent possibles avec des investissements différents.

## Reconstruction

Chaque bâtiment commence au niveau 0. Son niveau 1 coûte 3 réserves et une période ; le niveau 2 coûte 4 réserves et une période, avec le niveau 1 déjà acquis. Six améliorations coûtent donc 21 réserves et six périodes.

| Chantier | Niveau 1 | Niveau 2 |
|---|---|---|
| Pavillon | Escalier et couverture réparés ; intérieur accessible, sélection conseillée de deck disponible. | Boiseries et bannières restaurées ; aperçu du cycle complet du boss final dans le journal. |
| Atelier | Poste de travail remis en service ; acquisition d'équipement sans attendre le marchand. | Établi amélioré ; acquisitions à l'atelier à 2 réserves au lieu de 3. Pas de remboursement rétroactif. |
| Cuisine/résidence | Foyer réparé ; aide à la secte rapporte 3 réserves au lieu de 2. | Lieu remis en état ; repas de préparation gratuit avant le final, portant les PV maximaux de ce combat de 45 à 50. |

Le repas est appliqué une seule fois par tentative et n'ajoute pas une activité. L'interface indique les avantages des niveaux avant de payer. Les changements graphiques ne doivent pas empêcher la navigation.

Chaque amélioration achevée retire 3 PV au maximum du boss final : 84 PV sans restauration, jusqu'à 66 PV avec les six améliorations. C'est l'effet de la préparation collective, expliqué avant l'épreuve. Aucun niveau n'est obligatoire pour accéder au final. Tous les chantiers au niveau 1 ou plus donnent un épilogue de secte remise en service ; les autres résultats décrivent les travaux encore nécessaires.

## Collection, équipement et composition du deck

### Règles de collection

Le jeu possède exactement trente définitions de cartes. Acquérir une technique la rend disponible pour toute la campagne ; elle n'est pas détruite par une défaite. Les huit techniques de base sont connues dès le tutoriel. Chaque technique de base autorise deux exemplaires dans le deck ; chaque autre carte, un seul.

Le deck contient exactement douze cartes. Les cartes d'équipement et d'objet sont comprises dans ces douze. Le joueur choisit librement ses techniques entre les activités ; aucun changement en combat. Une interface de validation explique une carte manquante, interdite ou en trop.

Deux emplacements d'équipement : une arme, un talisman. Chaque équipement ajoute obligatoirement sa carte au deck tant qu'il est équipé, en remplaçant une technique choisie par le joueur. Une sacoche accepte un seul des deux objets réutilisables. Ils fournissent une carte utilisable une fois par combat et disponible de nouveau au combat suivant. Ils ne demandent pas une économie de consommables supplémentaire.

Lorsqu'un équipement est retiré, l'interface demande une carte de remplacement. Le joueur ne peut pas engager une activité de combat avec un deck invalide. Un bouton de composition automatique utilise les cartes disponibles et garantit un deck légal ; il n'est pas une garantie de victoire.

### Deck de départ

Deux Frappe droite, deux Garde du rocher, deux Taille appuyée, deux Posture ferme, un Souffle tranquille, un Pas léger, une Lecture du duel, un Souffle offensif : douze cartes, coût moyen faible, attaque et défense disponibles.

### Catalogue initial des trente cartes

Les coûts sont en qi. Une attaque inflige un seul impact sauf indication contraire. La pioche d'une carte prend effet immédiatement. « Retirée » signifie hors circulation pour le reste de ce combat, puis récupérée après le combat.

| ID | Carte | Coût | Effet initial | Acquisition |
|---|---|---|---|---|
| B01 | Frappe droite | 1 | 6 dégâts. | Base |
| B02 | Garde du rocher | 1 | 5 garde. | Base |
| B03 | Souffle tranquille | 0 | 3 garde, retirée. | Base |
| B04 | Taille appuyée | 2 | 11 dégâts. | Base |
| B05 | Pas léger | 1 | 3 garde, pioche 1. | Base |
| B06 | Lecture du duel | 1 | Pioche 2. | Base |
| B07 | Posture ferme | 2 | 11 garde. | Base |
| B08 | Souffle offensif | 0 | Prochaine attaque de ce tour : +2 dégâts ; retirée. | Base |
| L01 | Pétales tranchants | 1 | 7 dégâts ; 12 si au moins 2 autres cartes ont déjà été jouées ce tour. | Lian 1 |
| L02 | Fil de soie | 1 | 4 garde, pioche 1. | Lian 2 |
| L03 | Prunier dansant | 2 | 12 dégâts ; 18 dégâts et pioche 1 si au moins 2 autres cartes ont déjà été jouées ce tour. | Lian 3 |
| J01 | Réplique du tigre | 1 | 6 dégâts et 3 garde. | Jun 1 |
| J02 | Défi ouvert | 1 | Applique Exposé à la cible pour ce tour, pioche 1. | Jun 2 |
| J03 | Fendre la montagne | 2 | 14 dégâts ; perd 2 PV, sans être réduit par la garde. | Jun 3 |
| H01 | Racines profondes | 1 | 8 garde. | Shen 1 |
| H02 | Patience du maître | 1 | 4 garde ; prochaine attaque de ce tour : +3 dégâts. | Shen 2 |
| H03 | Mur de jade | 2 | 10 garde et 5 dégâts. | Shen 3 |
| Q01 | Lame restaurée | 1 | 8 dégâts. | Arme : épée ancienne |
| Q02 | Estoc du bambou | 1 | 5 dégâts, pioche 1. | Arme : épée de bambou |
| Q03 | Sceau protecteur | 1 | 7 garde. | Talisman : sceau de pierre |
| Q04 | Nœud du souffle | 0 | +1 qi, retirée. | Talisman : nœud de jade |
| O01 | Baume médicinal | 0 | Soigne 6 PV sans dépasser le maximum, retirée. | Objet réutilisable : S03 |
| O02 | Encens de veille | 0 | Pioche 2, retirée. | Objet réutilisable : S05 |
| E01 | Serment de l'aube | 1 | 7 dégâts et 2 garde. | Choix offensif M02 |
| E02 | Serment du foyer | 1 | 7 garde et 2 dégâts. | Choix protecteur M02 |
| E03 | Main du voyageur | 1 | Pioche 2 et 2 garde. | S01 |
| E04 | Écho des anciens | 2 | 10 dégâts et 6 garde. | S02 |
| E05 | Travail commun | 1 | 6 garde, pioche 1. | S04 |
| E06 | Horizon dégagé | 1 | 8 dégâts ; si la cible est Exposée, pioche 1. | S05 |
| E07 | Dignité retrouvée | 2 | 12 dégâts et 4 garde. | Victoire M04 |

E01 et E02 sont exclusives dans une partie : la collection complète n'est pas exigée et n'est pas atteignable en une seule campagne. Pas de carte supplémentaire cachée dans les branches de dialogue. Les sept cartes actuelles du prototype seront remappées vers ce catalogue ; leur équilibrage pourra changer.

## Combat au tour par tour

### Mise en place

Le héros commence chaque rencontre à 45 PV, sauf bonus de repas final, sans blessure persistante. Il combat un adversaire à la fois dans cette première version. Le deck légal est mélangé ; pioche, main, défausse et cartes retirées sont quatre zones distinctes. Les intentions et PV ennemis sont visibles avant la première action.

Début du tour du joueur : supprimer sa garde restante, fixer le qi à 3, réinitialiser le compteur de cartes jouées et les bonus d'attaque, piocher jusqu'à cinq nouvelles cartes. La main est limitée à dix cartes ; au-delà, la pioche demandée s'arrête sans déplacer de carte. Le qi est limité à 5 et ne se conserve pas entre les tours.

Si la pioche est vide, mélanger la défausse pour la reformer. Si les deux sont vides, la pioche s'arrête. Une carte en cours de résolution n'est jamais dans la défausse avant la fin de ses effets ; elle ne peut donc pas se repiocher elle-même immédiatement.

### Jouer une carte

1. Vérifier la cible, le coût et que le combat est actif.
2. Payer le qi et retirer la carte de la main.
3. Évaluer les conditions à partir du nombre de cartes jouées avant celle-ci.
4. Appliquer les effets dans l'ordre écrit. Une attaque reçoit le bonus accumulé de prochaine attaque, qui est ensuite consommé.
5. Augmenter le compteur de cartes jouées, puis envoyer la carte en défausse ou dans les cartes retirées.
6. Vérifier fin de combat avant toute nouvelle action.

Exposé augmente de 50 % les dégâts d'attaque reçus par l'ennemi, arrondis à l'entier inférieur, après ajout des bonus et avant sa garde. Cet état ne se cumule pas et expire à la fin du tour du joueur. Il ne concerne pas les pertes directes de PV. Les bonus de prochaine attaque s'additionnent et expirent eux aussi à la fin du tour s'ils ne sont pas utilisés.

La garde absorbe les dégâts à raison d'un point pour un point ; seul l'excédent réduit les PV. Les dégâts et la garde ne deviennent jamais négatifs. Si une carte tue l'ennemi puis fait tomber le héros à zéro PV par son coût de santé, le résultat est une défaite : avoir un adversaire à zéro ne neutralise pas les effets restants de la carte.

### Fin du tour

Le joueur termine son tour explicitement. Les cartes restantes en main partent en défausse ; Exposé et les bonus de prochaine attaque expirent. Au début du tour ennemi, sa garde précédente est supprimée. Il exécute son intention affichée, puis prépare la suivante. La garde qu'il vient d'obtenir subsiste pendant le prochain tour du joueur. Si le héros survit, le tour suivant commence.

Les cartes retirées restent hors du deck jusqu'à la fin du combat. Aucun bouton de pause, changement de fenêtre ou rechargement d'interface ne doit réexécuter une récompense ou une intention.

### Quatre profils adverses

| Profil | PV initiaux | Cycle d'intentions, répétitif |
|---|---|---|
| Partenaire | 30 | Attaque 6 ; garde 5 ; attaque 9. |
| Offensif | 38 | Attaque 8 ; attaque 11 ; garde 4. |
| Défensif | 44 | Garde 10 ; attaque 7 ; attaque 10. |
| Inspecteur | 84 moins bonus des chantiers | Attaque 8 ; garde 8 et attaque 5 ; attaque 12, avant pression décrite ci-dessous. |

Le tutoriel emploie le partenaire à 18 PV, avec consignes et reprise gratuite. M04 emploie Jun à 40 PV avec le même cycle partenaire. L'inspecteur passe à son cycle final à partir du tour suivant celui où il atteint la moitié de ses PV initiaux : attaque 10 ; garde 6 et attaque 7 ; attaque 14. Le changement est annoncé avant la décision suivante, jamais substitué à une intention déjà affichée.

En v0.2, ajouter à chaque attaque de l’inspecteur `2 + 2 × floor((numéro_du_tour − 1) / 3)` dégâts : +2 aux tours 1–3, +4 aux tours 4–6, etc. Le numéro de tour commence à 1 et ne repart pas à zéro au changement de phase. Cette pression est comprise dans les intentions affichées, ne modifie pas la garde et ne concerne pas les autres profils.

Ces chiffres devront être testés avec au moins les decks offensif, défensif et d'enchaînement. Une défaite sur le final malgré plusieurs tentatives ne prouve pas à elle seule que le joueur a mal préparé : vérifier d'abord l'équilibrage.

## Les six événements secondaires

| ID | Conditions | Choix et résultat |
|---|---|---|
| S01 Marchand de passage | J4, J8 ou J12 ; non joué | Échange de nouvelles : E03 ; peut aussi acheter un équipement pour 3 réserves dans la même période. Achat facultatif. |
| S02 Objet des anciens | Après M03 ; pavillon niveau 1 ; non joué | Court duel défensif ; victoire : E04 et +1 réserve. Défaite : scène clôturée sans récompense, annoncée avant engagement. |
| S03 Intendance en difficulté | À partir de J3 ; cuisine ; non joué | Aider au tri : O01 et +1 réserve ; pas de coût matériel supplémentaire. |
| S04 Réparation collective | À partir de J6 ; au moins un niveau de chantier acquis | Coordination ou effort personnel : variantes de dialogue, E05 et +1 réserve. N'accorde pas gratuitement un niveau de bâtiment. |
| S05 Découverte du sentier | Après M03 ; matin/après-midi ; non joué | Rencontre offensive ; victoire : E06 et O02 ; défaite : retour sans récompense. |
| S06 Choix d'entraînement | À partir de J4 ; Jun ou Shen ; non joué | Exercice offensif ou défensif sans duel supplémentaire : aperçu guidé de deck et +1 réserve. Variante, pas nouvelle carte. |

Les événements secondaires sont uniques et restent disponibles tant que leurs conditions sont remplies, jusqu'au final. En cas de défaite à S02/S05, la partie continue ; le joueur peut recharger la sauvegarde préalable s'il veut retenter. Aucun événement perdu ne contient une carte indispensable à la victoire.

Les activités de combat libres proposent les profils débloqués, sans nouvelles scènes narratives. Cible de rythme : tutoriel, M03, M04, M06, S02, S05 et quatre à six combats libres, soit dix à douze rencontres. Cette cible n'impose pas de quota au joueur.

## Échec, sauvegardes et conclusion

### Sauvegardes

Conserver une sauvegarde automatique courante, une sauvegarde avant activité conservée jusqu'à l'engagement de la suivante, un point de préparation avant M05 et un point avant M06. Le joueur dispose également de trois emplacements manuels hors activité et hors combat. Chaque fichier indique version de format, jour, période et événement en attente.

Le point avant M06 est créé une seule fois lors de l'entrée dans la dernière période et n'est jamais écrasé par une tentative échouée. Il conserve le deck, la collection, l'équipement, les réserves, les liens, les chantiers, les drapeaux narratifs et l'état du générateur aléatoire. Le rechargement relance le final en mode préparation, pas une autre activité du jour 14. Changer le deck y reste possible.

La sauvegarde doit être écrite de manière atomique avec une copie précédente récupérable. Restaurer un fichier ne doit pas attribuer une deuxième fois une récompense. La version cible devra explicitement migrer ou refuser avec explication les anciennes sauvegardes du prototype ; ne pas convertir silencieusement son unique compteur de réparations en trois chantiers.

### Défaites ordinaires

Une défaite ou un abandon consomme la période engagée, n'attribue pas de récompense de victoire et renvoie au hub, PV rétablis pour la rencontre suivante. Aucun objet permanent n'est perdu. Le joueur peut poursuivre ou recharger la sauvegarde préalable. Le tutoriel fait exception et permet de recommencer gratuitement dans M01.

### Défaite finale

Afficher « Reprendre avant l'épreuve » et « Charger une autre sauvegarde ». Aucune progression vers l'épilogue, aucun sursis automatique. La reprise conserve tous les acquis antérieurs au final et permet de refaire la préparation du deck. Le point M05 sert à rejouer les dernières journées si le joueur préfère modifier sa préparation générale.

### Victoire finale

La victoire au duel est la seule condition indispensable. Présenter une conclusion principale puis de courts paragraphes selon les bâtiments remis en service, les rangs 4 et le lien romantique éventuel. Marquer la campagne terminée ; conserver les points de reprise. Aucun mode post-campagne supplémentaire n'est prévu dans ce périmètre.

## Vérification de cohérence sur papier

### Deux parcours possibles

Les six périodes narratives sont réservées aux mêmes dates dans les deux parcours. Les activités libres sont placées ensuite selon les horaires et les seuils de rang.

| Utilisation des périodes | Parcours reconstruction et liens | Parcours combat et équipement |
|---|---|---|
| Événements principaux | 6 | 6 |
| Scènes de liens | 9 : Lian 4, Jun 3, Shen 2 | 9 : Jun 4, Shen 3, Lian 2 |
| Événements secondaires | 6 | 6 |
| Chantiers | 6 | 3, un niveau par lieu |
| Combats facultatifs | 6 | 6 |
| Aide à la secte | 5 | 6 |
| Acquisition d'équipement séparée | 0 | 2 |
| Repos ou activités libres sans gain nécessaire | 4 | 4 |
| **Total** | **42** | **42** |

Premier parcours : 21 événements vus, 12 combats en comptant les deux secondaires, tous les chantiers terminés, mais tous les rangs 4 ne sont pas atteints. Second parcours : même nombre de scènes et combats, équipement choisi, moins de restauration. Les quatre périodes de marge peuvent être utilisées autrement ; aucun repos obligatoire n'est ajouté pour gonfler la durée.

Budget v0.2 sans revenus de combat : parcours reconstruction, 6 de départ + 14 issus de cinq aides (une à 2 puis quatre à 3) + 5 récompenses fixes − 21 de travaux = 4 réserves restantes. Parcours équipement : 6 + 17 issus de six aides + 5 récompenses fixes − 9 de travaux − 6 pour deux équipements = 13. Les coûts peuvent être financés sans gagner les combats intermédiaires ; l’ordre des dépenses reste à respecter.

### Calendriers témoins vérifiés

L, J et H désignent les rangs de Lian, Jun et Shen. M et S renvoient aux événements définis ci-dessus. Chaque cellule contient trois activités dans l'ordre matin, après-midi, soir.

| Jour | Reconstruction matin / après-midi / soir | Combat matin / après-midi / soir |
|---|---|---|
| 1 | M01 / L1 / J1 | M01 / J1 / H1 |
| 2 | H1 / Aide / Cuisine 1 | L1 / Aide / Cuisine 1 |
| 3 | M02 / L2 / J2 | M02 / J2 / H2 |
| 4 | H2 / S01 / Aide | L2 / S01 / Aide |
| 5 | Duel libre / Pavillon 1 / Atelier 1 | Duel libre / Pavillon 1 / Atelier 1 |
| 6 | M03 / L3 / J3 | M03 / J3 / H3 |
| 7 | S02 / S03 / S04 | S02 / S03 / S04 |
| 8 | S05 / Duel libre / S06 | S05 / Duel libre / S06 |
| 9 | M04 / Duel libre / Aide | M04 / Duel libre / Aide |
| 10 | Duel libre / Atelier 2 / L4 | Duel libre / Équipement / J4 |
| 11 | Aide / Pavillon 2 / Aide | Aide / Équipement / Aide |
| 12 | Duel libre / Duel libre / Cuisine 2 | Duel libre / Duel libre / Aide |
| 13 | M05 / Libre / Libre | M05 / Libre / Libre |
| 14 | Libre / Libre / M06 | Libre / Libre / M06 |

Vérification arithmétique réalisée sur ces deux séquences : 42 périodes chacune, dates principales respectées, rangs acquis dans l'ordre et aux bons jours, visite marchande disponible, duels libres uniquement matin/après-midi, restauration avant les activités qui l'exigent. En ignorant tous les gains de combat, mais en comptant les aides et les récompenses fixes de M02/M05/S03/S04/S06, les réserves ne passent jamais sous zéro. Solde final v0.2 sans revenus de combat : 4 pour reconstruction, 13 pour combat/équipement ; respectivement 9 et 18 avec les victoires prévues. Les deux séquences conservent quatre périodes libres. Ces résultats montrent l'absence de blocage économique dans ces parcours, pas leur équilibrage ni leur intérêt ; le surplus de ressources devra être observé en test.

### Exemple de tour

Avec 3 qi : jouer Défi ouvert (1 qi) applique Exposé ; jouer Souffle offensif (0) prépare +2 ; jouer Frappe droite (1) inflige floor((6+2)×1,5) = 12 dégâts avant garde ; jouer Garde du rocher (1) donne 5 garde. Une intention ennemie de 8 dégâts inflige alors 3 PV de dégâts au héros. Le prochain tour recommence avec 3 qi et sans la garde précédente.

## Critères à tester à l'étape 4

- Les deux budgets de périodes sont plaçables sur les horaires sans conflit bloquant ; les 24 événements sont accessibles sur l'ensemble des parcours.
- Une activité paie et récompense exactement une fois, même après une reprise de sauvegarde.
- Les huit techniques de base permettent toujours de composer un deck légal de douze cartes.
- Chaque carte du catalogue a une source atteignable ; les deux serments restent exclusifs.
- L'équipement ajoute sa carte et la retire correctement ; les objets réutilisables reviennent au combat suivant.
- La pioche vide, la main pleine, les cartes retirées, Exposé, le changement de phase et les effets de perte de PV respectent l'ordre défini.
- Aucune romance, carte secondaire ou amélioration de bâtiment n'est strictement nécessaire pour atteindre et tenter le final.
- Trois styles de deck gagnent contre le boss à équipement comparable après équilibrage, sans combinaison infinie ni carte manifestement obligatoire.
- Les sauvegardes avant activité, préparation et final ne sont pas écrasées par une défaite ou par l'épilogue.
- Les testeurs comprennent les coûts et l'échéance ; la durée de 3 à 5 heures est mesurée sur une première partie, sans inclure les reprises.

## Conséquences pour le prototype

Ces systèmes sont maintenant expérimentés dans le laboratoire, dont la composition manuelle depuis la collection et les trois emplacements d’équipement. La migration vers le hub, les dialogues finalisés et la sauvegarde de production complète restent à réaliser. Les fonctionnalités effectivement testées et les limites figurent dans le bilan v0.2.

Réutiliser la cour, les contrôles, les animations, la direction visuelle, les effets d'ambiance et les bases du combat. Le prototype actuel reste jouable avec ses anciennes règles tant que cette migration n'est pas réalisée. Ne pas afficher une fonctionnalité de ce document comme disponible dans le jeu avant son intégration et son test.
