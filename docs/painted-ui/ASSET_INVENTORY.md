# Interfaces en calques — 20 novembre 2026

## Source commune
Le thé avec Lian, validé par le joueur. Assemblage de textures séparées, cadres, illustrations, textes et contrôles Godot. Les textes, coûts, récompenses et choix restent dynamiques.

## Réemploi avant génération
- `assets/ui/tea/` : papier, branches, cadres de carte et de statut, coup de pinceau, jardin et duo au thé. Le cadre est recadré par AtlasTexture, sans duplication d’image.
- `assets/hub/portraits.png` : personnages détourés des dialogues, résultats, compagnons et événements narratifs.
- `assets/events/` : marchand et serment chibi conservés.
- `assets/study/` : animations existantes conservées ; scènes de travail et repos réemployées au bilan.
- Arène, jardin et pavillon existants conservés. Les fonds narratifs utilisent un fondu de bordure en shader.
- Illustrations de techniques conservées ; Fil de soie réutilise désormais l’illustration approuvée du thé partout.
- Icônes fonctionnelles de combat conservées (qi, poison, garde, intentions et cibles).

## Trois créations nécessaires
`assets/ui/activities/study-people.png`, `training-people.png`, `study-background.png` : deux illustrations de fin d’activité en haute définition et un pavillon sans personnage. Les petites planches d’animation ne supportaient pas un agrandissement plein écran. Sources intactes dans `art_sources/activities/`. Génération intégrée, sans appel à une API payante externe.

## Conventions réutilisables
`visual/shared/painted_theme.tres` centralise papier, boutons et couleurs. `page_decoration.tscn` porte les branches. `card_frame.tres` et `status_frame.tres` réutilisent les cadres peints. Rouge pinceau pour l’action principale, papier pour retour/annulation/options. Kaushan Script pour les titres ; police de lecture pour les données. Ne pas dupliquer ces ressources lors de l’ajout d’un écran.

## Couverture
Menu, commandes, hub, jardin, pavillon, dialogues, collection/deck, inspection de carte, activités, bilan, serment, marchand, compagnons, préparation du groupe, duels, combat en équipe, règles, récompense, résultat, étude, entraînement, thé, visiteuse, espionne, invitations, antidote, recrutement, retour du boss, aspirants, confirmation de recommencement.

## Validation
- 23 suites de régression réussies.
- Test du thé en calques réussi (récompenses réelles, une seule validation, mouvement réduit, aucune persistance de test).
- 30 captures Godot via `tests/test_painted_screens.gd`, profil isolé ; annuler le recommencement ne modifie pas l’état.
- Six fichiers de sauvegarde existants identiques par SHA-256 avant/après.
- Les mécaniques et contenus narratifs ne changent pas. Les captures présentent des situations de test, pas la sauvegarde du joueur.
