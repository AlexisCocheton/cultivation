# Agent Sprite Forge — installation et essai sans frais

19 novembre 2026. Budget autorisé pour cet essai : **0 €**. Aucun appel API ni génération vidéo effectué. Les dessins existants ont été réutilisés ; art_source = existing.

## Installation

Les cinq skills sont installés ensemble dans C:/Users/Lenovo/.codex/skills : generate2dsprite, generate2dmap, video2dsprite, codeart2d, generate2dmedia. Installation avec le helper officiel skill-installer de Codex, depuis 0x0funky/agent-sprite-forge, révision 25203d03900b46b444bdd72a75768c33d1895ad6 (outils déclarant la version 0.6.0). Disponibles pour les prochains tours Codex.

Inspection ciblée : instructions des trois skills utilisés, diagnostic, commandes de traitement/export et opérations de publication/nettoyage. Ce n'est pas un audit de sécurité exhaustif de tous les scripts.

Python 3.13.3, NumPy 2.2.2, Pillow 12.1.1, SciPy 1.17.1 et FFmpeg 8.0.1 sont déjà installés ; aucun paquet supplémentaire nécessaire. Le diagnostic signale plusieurs Python sur PATH : les commandes de cet essai utilisent celui identifié ci-dessus. resvg-py manque mais n'intervient pas dans ce test. Aucun fournisseur API configuré ni Grok CLI disponible ; aucune route de génération vidéo. Le générateur d'images intégré ne fournit pas de vidéo.

## Ce qui a réellement été testé

Lancer ComparatifSpriteForge.cmd. Deux vues synchronisées, pause, pose suivante et zoom ×2 :

- A : découpage actuel de la première rangée de assets/manhua_combat.png.
- B : même dessin, après nettoyage d'alpha, découpage par appartenance des composants à un personnage, puis export SpriteFrames par Sprite Forge.

Il ne s'agit **pas d'une nouvelle animation générée à partir d'une image**. Les deux versions conservent les mêmes quatre poses, durées de 150/100/160/150 ms, total 560 ms et contact à 250 ms. La scène de comparaison ajoute une pause après l'attaque pour faciliter la lecture ; l'export lui-même n'est pas bouclé.

Étapes locales :

1. tests/spriteforge/prepare_attack.py extrait la première rangée sans redessiner ; hash source enregistré.
2. sheet_qc.py spill contrôle la planche.
3. generate2dsprite.py process produit le nettoyage d'alpha ; le découpage régulier initial reste un essai diagnostique, non retenu.
4. assemble_frames.py --slice ownership découpe la planche nettoyée en conservant les composants complets, sur un canevas commun de 321 × 314.
5. build_animation_clips.py reprend le timing exact et l'événement hit.
6. export_engine.py --target godot-spriteframes produit un atlas, un .tres, une .tscn et les métadonnées d'événements.
7. tests/test_spriteforge.gd charge la ressource ET la scène exportées dans Godot 4.4.1, vérifie quatre poses, 560 ms, contact à 250 ms et les pixels récupérés : PASS.

Les aperçus WebP animés sont des fichiers de revue, pas des textures Godot : leurs dossiers sont exclus de l'import par .gdignore. Seul le dossier export/godot est destiné au moteur.

## Résultat

Le contrôle de Sprite Forge détecte un débordement réel : le pied arrière de la pose 3 empiète sur la cellule 2. Le découpage régulier le coupe et affiche son fragment dans la pose précédente. Le découpage ownership réattribue **91 pixels** à la pose 3 (dont le contrôle compte 85 pixels solides débordants). Un padding partagé de 7 pixels à gauche permet de conserver le pied sans déplacer individuellement les poses.

Le nettoyage d'alpha a aussi traité le voile de pixels presque invisibles. Les poses, la forme courte de la lame sur la frappe et le nombre de dessins restent ceux de la source : pas d'amélioration démontrée de la fluidité ou de l'anatomie. La différence visuelle est surtout technique et discrète à la taille du jeu.

Export : vérification interne PASS, erreur de durée 0 ms ; import réel et test Godot PASS. Planches sur fond clair, sombre et damier et capture de comparaison examinées. Les rapports de construction indiquent needs-visual-review : ils ne certifient pas la qualité artistique.

La version de production n'a pas été remplacée. Le comparatif permet de décider de l'adoption avant de modifier scripts/avatar.gd.

## Alertes exactes des rapports publiés

Le premier test n'a pas tout passé. Alertes conservées, sans masquer les défauts initiaux :

| Fichier | ID | Statut | Valeur | Seuil |
|---|---|---|---|---|
| tests/spriteforge/source-qc/sheet-qc.json | cross_cell_components | fail | 1 | 0 |
| tests/spriteforge/source-qc/sheet-qc.json | cross_cell_visible | fail | 1 | 0 |
| tests/spriteforge/source-qc/sheet-qc.json | boundary_band | warn | 199 | 0 |
| tests/spriteforge/source-qc/sheet-qc.json | safe_frame | warn | 4 | 0 |
| tests/spriteforge/source-qc/sheet-qc.json | faint_specks | warn | {"floor_px":41788,"detached_components":6} | 0 |
| tests/spriteforge/processed/pipeline-meta.json | source_edge_touch_frames | warn | [[0,1],[0,2]] | [] |

Le parcours ownership traite le débordement au lieu d'accepter un découpage coupé. Les quatre alertes de marge/bruit sur la source ne constituent pas une validation artistique de la sortie.

## Limite de l'essai et décision

Installation terminée et traitement/export d'une attaque existante testé gratuitement. Le test de génération d'un mouvement inédit reste **non réalisé**, faute de route vidéo disponible sans accès supplémentaire.

Retenir les outils de contrôle/découpage/export comme candidats utiles. Pour tester ultérieurement une animation réellement nouvelle, utiliser un clip fourni ou vérifier un accès vidéo explicitement autorisé ; ne pas activer d'API payante avec le budget actuel. Le brief préparé est dans tests/spriteforge/attack-motion-brief.txt. Aucun appel ne part automatiquement.

Origine des outils : https://github.com/0x0funky/agent-sprite-forge
