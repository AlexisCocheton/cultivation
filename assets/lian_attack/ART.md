# Lian — attaque à six poses et lame unique

Design/poses : `tools/lian-attack-review/sheet-v2.png`, approuvé par le joueur. `weapon-source.png` en est une copie intacte. `body.png` : imagegen intégré, génération exec-baaab260-2356-432c-b52c-5057754248c1 ; retouche demandée : enlever seulement les six lames argentées, conserver les poignées/gardes/mains/poses/tenue et produire un fond transparent. Aucun appel API payant externe.

La lame est réutilisée depuis la deuxième pose du dessin approuvé, région AtlasTexture (723,256,141,18), sans génération ni redimensionnement par pose. `visual/team/lian_attack.tscn` sépare Body et Blade. Les six points de fixation sont documentés dans `lian_attack.gd` ; rotation et translation seulement. Le rendu de lame passe devant le corps pour ne pas être occulté par la manche dans la pose de garde.

Échelle commune 84/395, pied au y466 des cellules 512 × 512. Six durées : 120,140,70,120,120,130 ms. Impact à la quatrième pose. Le composant ne s’affiche que pendant l’attaque de Lian en équipe, y compris au jour 7 ; garde et repos existants conservés.

Validation : même texture et même longueur géométrique sur les six poses (58,4704 unités avec l’échelle de combat), un seul impact, toutes les poses parcourues, retour au repos et garde testés. Captures de raccord inspectées : tests/lian-attack-0.png et tests/lian-attack-3.png.


Correction après retour joueur : la composition Body + Blade est désormais rendue hors ligne par Godot dans six PNG complets (`frame-00.png` à `frame-05.png`). Le jeu charge uniquement ces images via `attack.tres`, sans lame séparée à afficher. Le montage source est conservé dans `visual/team/lian_attack_source.tscn` pour réédition ; export reproductible : `tools/lian-attack-review/bake.gd`. Tests de pixels opaques et argentés sur la lame à cinq distances et dans les six poses, et vérification de son affichage lors de la vraie attaque du deuxième tour.
