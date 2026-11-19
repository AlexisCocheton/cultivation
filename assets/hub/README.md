# Assets du hub habité

Générés avec l’outil imagegen intégré le 19 novembre 2026, à partir de la maquette approuvée docs/ui-proposals/hub-vivant-concept.png et des portraits existants assets/portraits_manhua.png. Aucun service API payant externe utilisé.

- courtyard.png : fond 1536 × 1024, maquette approuvée nettoyée de tout personnage et interface ; géométrie du prunier, hall déchu, table, terrasse et mannequins conservée. Premier plan dégagé pour le déplacement.
- restored.png : édition alignée du fond ; réparer uniquement toit et façade du hall central, bannières et marches, sans enrichissement luxueux. Autres éléments, éclairage et caméra conservés. Le shader hub_courtyard applique les zones selon les niveaux de reconstruction.
- portraits.png : édition de l’atlas original 3 × 2 ; retirer le fond en préservant identités, positions, expressions et vêtements ; transparence alpha réelle vérifiée.
- activities.png : atlas transparent 2 × 1, Lian debout trois-quarts entretenant son sabre avec un chiffon, Shen debout lisant un livre ; référence des identités sur les portraits, corps entiers, marges transparentes. Mipmaps activés pour le rendu réduit. Poses fixes.
- contact-shadow.svg : ombre vectorielle douce, dessinée pour l’ancrage au sol.

Sources de génération conservées dans le dossier generated_images de Codex ; copies utilisées par le jeu dans ce dossier. Les anciens fonds et portraits restent disponibles. Scènes d’interface : visual/hub/. Aucun texte de dialogue nouveau ni choix narratif supplémentaire inventé pour l’intégration.
