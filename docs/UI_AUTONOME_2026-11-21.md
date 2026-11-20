# Passe autonome des interfaces — 21 novembre 2026

## Protection et périmètre

Version initiale sauvegardée sur origin/master : `8e87ff2`. Travail suivant sur `codex/autonomous-ui`.
Autorisation du joueur : traiter les écrans restants sans validation à chaque étape, en réutilisant les assets avant génération. Le pourcentage de crédits hebdomadaires n’est pas accessible depuis les outils ; aucune API payante externe utilisée.

Les règles de combat, cartes et progression restent inchangées. Les tests utilisent des profils APPDATA isolés. Dix fichiers de sauvegarde personnels vérifiés par empreinte, inchangés.

## Registre des écrans

| Écran | Traitement de cette passe |
|---|---|
| Cour | Composition déjà validée conservée, capture de contrôle |
| Menu de la secte | Navigation hiérarchisée à gauche, reprise principale, reprise/reset séparés, icônes réutilisées |
| Commandes | Réaffectation active et conflits lisibles, annulation et restauration conservées |
| Jardin et pavillon | Cartouches de lieu, disponibilités, actions hors des personnages, icônes réutilisées |
| Dialogue Jun | Portrait manhua neutre/heureux cohérent avec fiche, réponses rapprochées, masque et défilement |
| Collection/deck | Recherche, tri, Base, quantités et modifications visibles, cadres fins, +/− et enregistrer/annuler conservés |
| Inspection | Carte agrandie, effets séparés de la voie, source et contexte du deck dans panneau complémentaire |
| Activités, bilan et serment J3 | Compositions approuvées conservées, composants de carte partagés vérifiés |
| Marchand | Portrait/scène de boutique, quatre cartes/prix, comparaison avec équipement porté ; acheter n’équipe pas automatiquement |
| Compagnons | Portrait large, cinq paliers, onglets actifs et portraits, deck regroupé avec quantités réelles |
| Préparation J7 | Recrue fixe et trois candidats visibles, deux compagnons sélectionnables, verrou réel, antidote |
| Duel et équipe | Composants partagés, Qi/commandes harmonisés, éventail entier au repos et survol avec 12 cartes |
| Technique acquise | Lian, grande carte, acquisition distincte de l’équipement, composer et retour au jardin |
| Résultat duel | Verdict, illustration et conséquence séparés, retour conservé |
| Étude/entraînement | Scènes animées existantes conservées, carte réelle sans mise à l’échelle du texte, gain encadré |
| Thé Lian | Composition déjà validée conservée |
| Visiteuse | Calques déjà validés conservés, contrôle des textes/actions |
| Espionne | Parchemin cohérent, scène encadrée, textes et navigation lisibles |
| Invitations | Deux illustrations et personnages indépendants côte à côte, disponibilité réelle, coût commun |
| Antidote/recrutement/retour | Scène encadrée, texte réel, conséquence/coût en cartouche, choix et retours conservés |
| Aspirants | Mei et Tao illustrés en calque, statut narratif explicite, choix d’accueil inchangé |
| Règles | Six rubriques consultables, exemples issus des vraies cartes, textes campagne/laboratoire distincts |
| Recommencer | Fenêtre dédiée, annuler préselectionné, action destructive rouge, aucune mutation avant confirmation |

## Calques et réutilisation

Réemploi du papier, des cadres fins, des branches, des icônes book/scroll/hourglass/settings, des illustrations de cartes et des scènes existantes. Nouveaux PNG : marchand, portraits Jun/Shen/recrue, expression heureuse Jun, deux aspirants. Sources conservées dans art_sources ; fichiers moteur dans assets/ui. Texte et valeurs dynamiques restent des contrôles Godot. Les variantes de personnages servent de références réutilisables, jamais de capture aplatie de menu.

## Vérifications reproductibles

- `tools/run_regressions.py` : 24 suites, dont parité combat et persistance.
- `tests/capture_deck_refine.gd`, `capture_resident_refine.gd`, `capture_combat_refine.gd` : captures 1280×832 / 960×624 et interactions.
- `tests/test_ui_refinement.gd` : marchand, compagnons et préparation.
- `tests/test_narrative_ui.gd` : 22 captures narratives/résultats.
- `tests/test_painted_screens.gd` : inventaire des 30 écrans.
- Lancer les captures avec rendu graphique et `--audio-driver Dummy`, jamais sur le profil joueur.

Captures : docs/painted-ui/refine-*.png. Références : docs/ui-audit-2026-11-20/manifest.json. Ce registre décrit l’intégration, pas une validation artistique du joueur ni une reproduction pixel pour pixel.

## Revue indépendante

Revue consolidée : prêt avec réserves sur les lots examinés ; contre-vérification finale des deux derniers défauts : prêt. Corrections déjà issues de la revue : portrait incohérent de la recrue, récompense trop proche de l’ancienne fenêtre, icônes manquantes, portrait Jun différent selon écran, distinction du bouton destructif, marge basse de l’éventail. Corrections finales vérifiées : fond sombre du portrait souriant de Jun supprimé, lavis clair derrière le texte des invitations. Aucun blocage restant identifié par cette contre-revue.

Réserves non bloquantes : les règles, actions jardin/pavillon et préparation restent plus simples que les maquettes (moins d’illustrations explicatives ; quatre candidats visibles au lieu de trois places illustrées). L’historique de dialogue proposé par une ancienne maquette n’est pas implémenté. La revue indépendante porte sur les captures effectivement examinées, et ne constitue pas une certification artistique exhaustive de 30 écrans.

Contrôle final moteur : 30 écrans capturés sans erreur ; 22 captures narratives et 16 captures/interactions résidents réussies après les corrections.
