# Scènes narratives réutilisables — 20 novembre 2026

## Principe retenu
Un écran narratif représente un moment dans un lieu, plutôt qu’un portrait de concept posé sur du papier. Réutiliser les références canoniques pour l’identité et les images existantes pertinentes avant toute génération. Ne pas substituer une illustration décorative à l’information nécessaire au joueur.

## Assemblage
`visual/shared/illustrated_scene.tscn` porte deux calques distincts : décor avec fondu dans le parchemin, et personnages/accessoires transparents. La logique de données choisit une composition dans `illustrated_scene.gd`. Chaque instance dispose de son matériau de bordure et se redimensionne sans étirer les personnages. Les textes, récompenses, choix et états restent des contrôles Godot indépendants.

## Application
- Espionne : accueil avec Shen au portail (nouveau duo, décor de la visiteuse réutilisé).
- Antidote : préparation des plantes avec Shen (nouveau duo/table, pavillon existant).
- Invitations et recrutements : thé au jardin, entraînement dans la cour, étude au pavillon selon le disciple.
- Retour du défi : groupe réuni au pavillon pour le bilan ; réemploi du groupe du serment.
- Aspirants : vue du portail en attendant des designs approuvés de Mei et Tao, sans leur inventer un visage.
- Marchand : marchand et coffre existants installés au portail.
- Résultat de duel : Jun et la recrue après l’entraînement.
- Fiches de compagnons, vignettes d’activité, serment et bilan : mêmes compositions réutilisées à petite échelle.
- Deck, combat et réglages : conservation de l’interface fonctionnelle et du kit papier/encre. Les vues du jardin/pavillon et les scènes de thé/étude/entraînement étaient déjà composées dans leurs lieux.

Deux nouveaux PNG seulement ; sources dans `art_sources/events`, fichiers moteur dans `assets/ui/events`. Génération par imagegen intégré ; aucune API externe payante.

## Vérification
30 écrans capturés sans erreur de script, galerie `docs/painted-ui/index.html`. Tests activités, espionne (38 contrôles), parcours narratif (26 contrôles) et marchand réussis. Six fichiers de sauvegarde identiques par SHA-256. Les tests de portraits pointent maintenant le calque personnages plutôt qu’une texture de concept.

## Prompts des nouveaux calques

### spy-welcome
Create a transparent foreground group for a murim game scene: the adult female spy from reference1 (LEFT full-body design ONLY) meeting elderly Master Shen from reference2 RIGHT. Both in refined 3-head-tall chibi watercolor/ink style of reference2, full body, clear friendly interaction. Spy LEFT makes a small respectful bow holding her folded fan at waist; elderly Shen RIGHT offers an open welcoming palm, kindly but observant. Preserve spy short dark brown bob with red tips, cream/brown embroidered travel outfit, red sash, red pendant, boots; preserve Shen white bun, long white beard, cream layered robe. No recruit, no book/table, no extra people. Transparent background, no architecture, no floor, no paper, no text, no aura. Entire two figures in one landscape4:3 group, feet same ground line, small empty margins. These will be placed at the existing sect gate.


### antidote
Create a new activity illustration foreground layer with EXACT SAME two characters and watercolor chibi style from reference: jade/cream recruit LEFT with brown high ponytail, elderly white-haired long-bearded Shen RIGHT in cream robes. They prepare herbal antidote TOGETHER at low wooden work table. Recruit crushes roots with stone mortar/pestle, Shen measures a small ceramic vial attentively; dried herbs, a small bowl and one closed medicine jar. Serious calm concentrated faces, no exaggerated smile. Full group, table and seated characters in frame, transparent background. No books, no text, no architecture, no paper backdrop, no glow, no UI. Precise clean alpha around silhouettes and props; preserve costume/identity. Landscape4:3.

