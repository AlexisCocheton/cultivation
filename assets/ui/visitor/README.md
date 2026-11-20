# Rencontre de la visiteuse en calques

Composition validée comme proposition puis intégrée le 20 novembre 2026.

Ordre : papier partagé, décor de la porte (`gate.png`), duo chibi transparent (`people.png`), branches du thé réutilisées, pétales existants, titre/dialogue/boutons natifs Godot. Les deux personnages restent ensemble dans un calque pour garder le contact précis éventail/épée. Pas d’animation corporelle artificielle ; branches et pétales seuls bougent, désactivés en mouvement réduit.

Références : concept canonique `assets/visitor/approved-design.png` et illustration de scène approuvée. Ne pas utiliser la planche de concept directement comme fond d’interface. Les autres poses pourront être générées depuis ces références.

Sources : `art_sources/visitor/`, runtime : `assets/ui/visitor/`. Génération intégrée imagegen, aucun appel API externe payant. Papier, boutons et branches réutilisés.

Aperçu isolé : `--script visual/visitor/layer_preview.gd` ; ne lit ni écrit la sauvegarde. Option `-- --capture` : capture + vérification passage au duel et mouvement réduit. Six fichiers de sauvegarde identiques SHA-256. Mise en page dans encounter.tscn ; logique de rencontre préservée.

## Prompts

### gate
Make a clean BACKGROUND PLATE from this approved watercolor murim scene. Preserve the exact gate, tiled wooden architecture, bronze lantern, worn mossy paving, plum blossoms, courtyard stairs and distant mountains, same perspective, light, palette and 3:2 composition. REMOVE BOTH characters and all their belongings, weapons, fan, hair, clothing, ribbons and magical thread entirely, naturally paint in the architecture and paving behind them. Empty gate passage with clear foreground floor ready for separate character layers. No people, no shadows from absent characters, no text, no UI. Delicate watercolor/ink on ivory paper with organic painted edges, no hard rectangular border.

### people
Extract the TWO interacting chibi characters from the approved scene together as ONE transparent foreground layer. Exact same faces, poses, costumes, relative position, proportions, closed ivory fan meeting the wooden sword tip, hands, violet thread and ribbons. Woman on LEFT purple/cream with silver hairpin, recruit on RIGHT jade/cream high ponytail. Keep entire silhouettes, hair, clothes and both pairs of boots, preserve the empty space BETWEEN them as actual transparency. REMOVE ALL gateposts, architecture, floor, shadows on floor, lantern, mountains, branches, blossoms, paper, background and floating petals. True alpha background, no colored halos. Fully opaque character interiors. Match the same refined watercolor/manhua chibi illustration. Canvas landscape 3:2, both full characters together filling the canvas with small margins. Do not alter relative positions of fan and sword or add elements.

