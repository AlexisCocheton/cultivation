# Portraits détourés — 20 novembre 2026

Correction des planches de concept utilisées à tort comme portraits d’interface. Les scènes de rencontre de la visiteuse et d’arrivée de l’espionne utilisent désormais `assets/visitor/portrait-cutout.png` et `assets/spy/portrait-cutout.png`, en transparence réelle. Sources approuvées conservées intactes. Génération/édition par l’outil imagegen intégré, sans API externe payante. Vérification des deux compositions dans Godot via profil isolé ; captures actualisées dans `docs/painted-ui/`.

Règle : une planche de concept avec fond ou détails annexes n’est pas un asset de composition. Avant réemploi, vérifier son alpha ET le rendu sur le fond réel, y compris les mèches et les accessoires.

## Prompts

### visitor
Extract ONLY the LEFT normal non-orthodox woman from this character design sheet as a game-ready transparent full body character illustration. Preserve exactly her face, sly smile, long black hair, purple and cream layered embroidered robes, folded fan, jewelry, boots, proportions and pose. Remove ALL parchment, lettering, border, floor, cast shadow, purple smoke, demon figure and any other design sheet elements. Complete any left cropped robe edges naturally. One complete character centered, full hair and both boots visible with small transparent margins. No new design or glow. Fine manhua ink and watercolor rendering identical to reference. Real alpha transparency everywhere outside silhouette including gaps in hair and clothes.

Nettoyage : Edit this exact image: preserve the character unchanged, remove the entire blurry colored halo/glow/background around her. Precise clean alpha matte following ONLY the character silhouette. All pixels outside hair, ribbons, clothing, fan, jewelry and boots must be fully alpha zero including the broad brown purple red cloudy glow currently surrounding her. No glow, no aura, no shadows, no haze, no backdrop. Do not fade or make the character semi-transparent. Fully opaque character interior, only a 1-pixel antialiased contour. Transparent PNG game UI cutout.

### spy
Extract ONLY the LEFT full-body adult female spy from this reference design sheet into one complete game-ready transparent character. Preserve face, short dark brown bob with red tips, smile, folded fan near mouth, black brown and cream embroidered outfit, red sash, red pendant, boots, pose and proportions exactly. Remove ALL background: pillar, railing, ground, floor shadow, landscape, parchment texture, border, all extra face and detail studies. One full-body woman alone, no architecture. Naturally complete obscured clothing edges while keeping same pose. Full head to both boots, centered with small transparent margins. Fine manhua ink/watercolor identical to reference, actual alpha transparency outside silhouette.

Nettoyage : Edit this exact image: preserve the character unchanged, remove the entire blurry colored halo/glow/background around her. Precise clean alpha matte following ONLY the character silhouette. All pixels outside hair, ribbons, clothing, fan, jewelry and boots must be fully alpha zero including the broad brown purple red cloudy glow currently surrounding her. No glow, no aura, no shadows, no haze, no backdrop. Do not fade or make the character semi-transparent. Fully opaque character interior, only a 1-pixel antialiased contour. Transparent PNG game UI cutout.

