# Propositions d’interface — 20 novembre 2026

30 maquettes générées couvrant les écrans et variantes actuels. Aucun changement de code ou de sauvegarde. Ouvrir [la galerie](index.html) pour parcourir les images.

## Priorités

1. Activités et bilan : rendre les choix de temps et leurs conséquences visibles.
2. Marchand, compagnons et préparation : comparer avant de décider.
3. Dialogues, récompenses et confirmations : composants communs cohérents.
4. Combat : conserver la cohérence duel/équipe et clarifier les états sans supprimer d’informations utiles.

P1 : amélioration prioritaire de lisibilité/décision. P2 : finition ou variante.

## Écrans actuels et propositions

### 1. Cour centrale — P1

Rassembler jour, période et échéance du défi ; placer les accès près des lieux ; garder la cour visible.

Source : `visual/hub/hud.tscn`.

![Cour centrale](01-cour.png)

### 2. Menu de la secte — P1

Hiérarchiser reprise, techniques et compagnons ; isoler Recommencer des actions courantes.

Source : `visual/hub/menu.tscn`.

![Menu de la secte](02-menu.png)

### 3. Commandes — P2

Rendre visibles la touche en cours de modification, les conflits et le retour aux valeurs par défaut.

Source : `visual/settings/controls.tscn`.

![Commandes](03-commandes.png)

### 4. Jardin de Lian — P1

Distinguer conversation gratuite et activité payante en temps, sans couvrir le personnage.

Source : `visual/garden/ui.tscn`.

![Jardin de Lian](04-jardin.png)

### 5. Pavillon de Shen — P1

Rendre la disponibilité d’étude et son coût lisibles ; conserver le livre et le visage dégagés.

Source : `visual/pavilion/ui.tscn`.

![Pavillon de Shen](05-pavillon.png)

### 6. Dialogue avec Jun — P1

Réduire la hauteur vide, rapprocher les réponses du texte et préparer historique/masquage du dialogue.

Source : `visual/hub/dialogue.tscn`.

![Dialogue avec Jun](06-dialogue.png)

### 7. Composition du deck — P1

Ajouter Base, tri/recherche, quantités nettes et modifications non enregistrées ; conserver +/− et Enregistrer/Annuler.

Source : `visual/deck/menu.tscn`.

![Composition du deck](07-deck.png)

### 8. Inspection d’une carte — P1

Afficher une vraie carte agrandie, sa source et ses mots-clés ; retour discret sans masquer l’illustration.

Source : `visual/deck/detail.tscn`.

![Inspection d’une carte](08-carte-detail.png)

### 9. Choix des activités — P1

Montrer la période consommée, les disponibilités et les occasions concurrentes avant de confirmer.

Source : `visual/activities/menu.tscn`.

![Choix des activités](09-activites.png)

### 10. Bilan de journée — P1

Montrer les gains du jour plutôt que seulement l’état total ; rendre le passage au lendemain explicite.

Source : `visual/activities/menu.tscn populate_summary`.

![Bilan de journée](10-bilan.png)

### 11. Choix du serment — P1

Présenter les deux techniques en cartes complètes, avec un choix exclusif explicite et une confirmation.

Source : `visual/activities/menu.tscn populate_event`.

![Choix du serment](11-serment.png)

### 12. Marchand et équipements — P1

Comparer l’équipement choisi à celui porté et distinguer acquisition, équipement et coût en période.

Source : `visual/merchant/menu.tscn`.

![Marchand et équipements](12-marchand.png)

### 13. Fiche d’un compagnon — P1

Remplacer le bloc de texte par une progression de lien visuelle et un deck regroupé par quantités.

Source : `visual/team/companions.tscn`.

![Fiche d’un compagnon](13-compagnons.png)

### 14. Préparation du tournoi — P1

Montrer la recrue fixe et deux places de compagnons, leurs rôles et la raison d’un verrouillage.

Source : `visual/team/encounter.tscn`.

![Préparation du tournoi](14-equipe.png)

### 15. Duel — P1

Garder exactement les mêmes composants de carte, Qi, garde et intention que le combat en équipe.

Source : `visual/combat/hud.tscn`.

![Duel](15-duel.png)

### 16. Combat en équipe — P1

Clarifier personnage actif, tours terminés, cibles et statuts ; laisser la main et le Qi dominer les commandes.

Source : `visual/team/lab.tscn`.

![Combat en équipe](16-combat-equipe.png)

### 17. Technique acquise — P1

Montrer la carte entière et proposer une action claire pour l’ajouter au deck, sans laisser croire qu’elle est équipée.

Source : `visual/combat/reward.tscn`.

![Technique acquise](17-recompense.png)

### 18. Résultat du duel — P2

Séparer résultat, conséquence et action suivante ; éviter les longs paragraphes après chaque entraînement.

Source : `visual/combat/result.tscn`.

![Résultat du duel](18-resultat.png)

### 19. Étude chibi — P2

Faire de l’animation une courte transition, avec coût et résultat clairement séparés et possibilité d’abréger.

Source : `visual/study/overlay.tscn Shen`.

![Étude chibi](19-chibi-etude.png)

### 20. Entraînement chibi — P2

Garder les mêmes repères que l’étude ; mettre les poses et les armes au centre, sans texte répétitif.

Source : `visual/study/overlay.tscn Jun`.

![Entraînement chibi](20-chibi-jun.png)

### 21. Thé chibi avec Lian — P2

Donner sa personnalité à l’activité tout en réutilisant le même écran de résultat.

Source : `visual/study/overlay.tscn Lian`.

![Thé chibi avec Lian](21-chibi-lian.png)

### 22. Rencontre de la visiteuse — P1

Présenter clairement défi, départ et récompense connue, sans révéler ses intentions cachées.

Source : `visual/visitor/encounter.tscn`.

![Rencontre de la visiteuse](22-visiteuse.png)

### 23. Arrivée de l’espionne — P2

Utiliser la présentation narrative commune ; suggérer le mystère visuellement sans spoiler sa nature.

Source : `visual/spy/arrival.tscn`.

![Arrivée de l’espionne](23-espionne.png)

### 24. Invitations concurrentes — P1

Mettre côte à côte les deux invitations, leur coût commun et le retour possible de l’occasion écartée.

Source : `visual/story/panel.tscn invite`.

![Invitations concurrentes](24-invitations.png)

### 25. Préparation de l’antidote — P1

Rendre le compromis temps/préparation visible et rappeler précisément l’effet de l’objet.

Source : `visual/story/panel.tscn prepare`.

![Préparation de l’antidote](25-antidote.png)

### 26. Recrutement d’un disciple — P1

Distinguer les réponses de dialogue du résultat de recrutement, avec portrait et rôle du compagnon.

Source : `visual/story/panel.tscn recruit`.

![Recrutement d’un disciple](26-recrutement.png)

### 27. Retour après le tournoi — P2

Résumer l’état réel des compagnons et les conséquences du combat, sans afficher une victoire générique.

Source : `visual/story/panel.tscn return`.

![Retour après le tournoi](27-retour-tournoi.png)

### 28. Accueil des aspirants — P2

Montrer le statut d’accueil et ses limites actuelles, sans suggérer des compagnons déjà jouables.

Source : `visual/story/panel.tscn candidates`.

![Accueil des aspirants](28-aspirants.png)

### 29. Règles de combat — P2

Remplacer la longue notice par des rubriques consultables, des icônes et de courts exemples.

Source : `visual/team/lab.tscn HelpPaper`.

![Règles de combat](29-regles.png)

### 30. Confirmation de recommencement — P1

Créer une confirmation dédiée, séparée des dialogues ; préciser exactement quelle progression sera remplacée.

Source : `visual/preview.gd confirm_restart via dialogue`.

![Confirmation de recommencement](30-confirmation.png)

## Écrans dédiés manquants à envisager

- Un véritable écran titre : Continuer avec aperçu de la sauvegarde, Nouvelle partie et Options.
- Un calendrier hebdomadaire : disponibilités des disciples et échéances importantes.
- Un aperçu de restauration : coût, prérequis et comparaison visuelle avant/après.
- Une vue d’équipement hors marchand : objets portés et comparaison avec la collection.
- Un journal : événements connus, objectifs et souvenirs de liens, sans révéler les secrets.
- Des options de confort : taille du texte et volumes séparés, en complément des commandes.

## Limites et mise en œuvre

Ces images servent à choisir la composition et la hiérarchie visuelle. Réutiliser les portraits validés à l’intégration ; afficher les valeurs, noms et textes depuis les données du jeu, pas depuis les images. Les contrôles représentés (recherche, historique, comparaisons, etc.) sont des propositions, pas des fonctions déjà ajoutées.

Le filtre Base et le deck 5 attaques, 5 gardes, Taille appuyée et Lecture du duel reprennent la demande précédente ; leur représentation ne signifie pas que ce changement a été implémenté ici.

Construire des composants communs : panneau papier, boutons, fiche carte, dialogue, résultat d’activité et HUD de combat. Les variantes narratives et chibi partagent ces composants pour rester dans les moyens du projet. Pas de changement des règles ou de multiplication des systèmes pour reproduire chaque image.

