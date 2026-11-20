# Thé avec Lian — composition en calques

Écran de référence isolé, 20 novembre 2026. Maquette fournie par l’utilisateur ; assets recréés avec imagegen intégré, sans API payante externe. Skill `Fater666/mockup-to-game-ui` installé et utilisé avec les conventions Godot `.tscn`.

## Assets

- `paper.png` : parchemin opaque plein écran.
- `garden.png` : décor aquarelle à bords transparents.
- `people.png` : recrue, Lian, table et thé ; vapeur retirée de l’image pour animation indépendante.
- `branches.png` : décor transparent réutilisé au premier plan et en haut.
- `status.png` : cadre horizontal vide des périodes et relations.
- `frame.png` : cadre de carte vide.
- `brush.png` : fond de bouton, soulignement et bandeau ; teinte jade du bandeau dans un matériau séparé.
- `silk.png` : proposition d’illustration pour Fil de soie, affectée uniquement à cet écran avant validation.

Sources originales conservées dans `art_sources/tea/`. Pas de texte ou de valeur incorporés dans les images. Les cadres sont recadrés non destructivement avec AtlasTexture dans la scène. Ne pas réutiliser les captures finales comme arrière-plan du jeu.

## Godot

`visual/study/tea.tscn` contient la composition éditable. Texte, coût et récompense utilisent le calendrier/catalogue. Branchements limités à l’activité Lian ; Jun et Shen gardent leur présentation actuelle. Branches doucement oscillantes, vapeur procédurale indépendante, pétales ; option de réduction des effets respectée. Le bouton Continuer ne consomme pas de période et ne redonne pas de carte.

`ApercuTheLian.cmd` ouvre un exemple autonome Lian 3 → 4 / Fil de soie. Il ne lit ni n’écrit de sauvegarde ; Continuer ferme cet aperçu. La scène est également raccordée à la véritable activité de Lian.

Tests : `test_tea_layers.gd`, `test_activities_menu.gd` passés ; capture réelle inspectée dans `docs/ui-activities-2026-11-20/the-lian-godot.png`. Typographie Kaushan conservée : la création d’une nouvelle police n’est pas incluse dans cet essai.
