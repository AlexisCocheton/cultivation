# Jun — attaque validée à six poses

Source : outil imagegen intégré, aucun appel API externe payant. Référence approuvée : `tools/jun-attack-review/v2/sheet.png`, dérivée de Jun dans `assets/manhua_combat.png`.

Passe de détourage : exec-6d413105-10c9-4a49-af26-e3c4a83ea918.png. Prompt : suppression seule du fond noir/gris et des halos, conservation des six personnages, poses, armes, échelle et placement ; transparence alpha réelle, vêtements opaques, sans ombre portée. Original conservé dans le dossier des générations ; copie de production `sheet.png`.

Grille 3 × 2, cellules 512 × 512. `attack.tres` contient les six régions sans redimensionnement individuel. Durées : 120, 140, 70, 120, 120, 130 ms. Impact à l’entrée de la quatrième pose. Dans avatar.gd : échelle commune 84/395 et pied au y480 de chaque cellule. Animation retournée horizontalement pour le duel. Les autres membres du combat d’équipe conservent leurs quatre poses et leur instant d’impact.

Contrôles : points de fond transparents sur chaque cellule ; inspection en moteur sur le décor du combat, aucune plaque sombre visible ; six poses parcourues et un seul rappel d’impact. Capture : `tests/jun-attack-clean.png`. Les limites demeurent celles d’une animation dessinée à six poses, sans interpolation vidéo.
