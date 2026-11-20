# Cadres réutilisables

`art-window.png` : fenêtre jade/bronze, centre et extérieur transparents, générée via imagegen intégré. Source intacte dans `art_sources/frames/`. Aucune illustration ni texte intégrés au cadre.

Ordre : papier bordé → illustration remplaçable → cadre d’image → sceau/coût → cartouche de titre → textes. Les scènes `tile.tscn`, `collection_card.tscn`, `detail.tscn`, `deck_row.tscn` et `illustrated_scene.tscn` partagent cet asset. Les interactions restent sur les contrôles existants ; les cadres ignorent la souris.

Le thème partagé réutilise `card_frame.tres` pour les panneaux et `status_frame.tres` pour les panneaux bas/étroits (`WidePanel`) et les cartouches. Ne pas recréer des cadres par écran. Ne pas intégrer texte/coût/illustration à l’image de cadre.

Prompt : single reusable landscape 3:2 illustration-window FRAME ONLY; transparent center and exterior; murim manhua painted ink/watercolor; slim dark jade lacquer rim, aged brass bevel, ivory paper lip, tiny angular corner clasps and plum engravings; front orthographic rectangle with clipped corners; no text, no illustration, no dragons, skulls, gems or Hearthstone motifs. True alpha PNG.

Validation : galerie de 30 écrans Godot mise à jour, tests deck, main et activités réussis.
