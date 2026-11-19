# Étape 5 — première séquence visuelle

19 novembre 2026. Statut : direction en cours, à examiner en jeu. L'étape 4 reste techniquement testée mais non validée sur le plaisir et l'équilibrage humain ; les valeurs v0.2 restent provisoires.

## Référence et décision

À la demande du créateur, référence recherchée sur Internet : [Return of the Blossoming Blade / Mount Hua Sect, page officielle WEBTOON](https://www.webtoons.com/en/action/return-of-the-blossoming-blade/list?title_no=2849), consultée le 19 novembre 2026. Direction proposée : contours encrés nets, ombres en aplats, visages expressifs, tenues de disciples simples et effets de sabre contrastés. Les personnages et les images du jeu sont originaux ; aucune case de l'œuvre n'est intégrée au projet.

Le hub conserve son décor pixel art et les personnages proportionnés précédemment choisis. Les portraits et désormais les sprites adoptent un traitement manhua/manhwa plus net : robes simples, contours encrés et ombres en aplats. Cette combinaison reste à valider en situation.

## Lot témoin intégré

Lancer **SequenceVisuelle.cmd**, ou ouvrir **visual/preview.tscn** dans Godot et appuyer sur F6. Jouer.cmd et la scène principale historique restent disponibles ; Laboratoire.cmd conserve les simulations complètes.

Séquence courte et isolée, du jour 2 au début du jour 4 :

1. Explorer la cour avec ses pétales, son arbre animé et les marches de face, de dos et latérales existantes.
2. Parler à Lian : deux expressions et une courte scène originale. S'entraîner consomme le matin, augmente le lien au rang 1 et accorde L01 via le vrai modèle de calendrier.
3. Ouvrir le deck, sélectionner un emplacement, puis une carte possédée. Les douze cartes et leurs limites de copies sont validées par le modèle v0.2 ; une carte acquise n'est pas automatiquement équipée.
4. Défier Jun : personnages visibles, cinq cartes illustrées, coûts de qi, PV et jauges, intention ennemie, pioche/défausse, effets d'impact et sons courts.
5. Le premier duel terminé consomme une période de jour. Une victoire rapporte une réserve. Les duels suivants sont libres, sans récompense ni coût temporel. Abandonner un entraînement ne consomme rien.
6. Après la première technique, choisir ses activités : travail (+2 réserves), lien avec un résident (règles de jour/rang v0.2), repos ou pavillon (3 puis 4 réserves). Chaque activité consomme une période. Le niveau 1 répare les marches ; le niveau 2 restaure toiture et façade.
7. Le matin du jour 3, événement M02 obligatoire : choisir E01 ou E02, recevoir +1 réserve et avancer d'une période. À la fin du jour 3, afficher le bilan ; deck et duels libres restent consultables.

Shen propose un conseil avec portrait. Les commandes de son et d'effets doux sont accessibles en haut. Les infobulles donnent les textes complets des cartes ; « Épuisement » signifie retrait jusqu'au prochain combat.

## Spécifications et provenance

- Cible : fenêtre 1280 × 832, redimensionnée par le canvas Godot ; décor nearest, sprites manhua et portraits au filtrage linéaire.
- Portraits : assets/portraits_manhua.png, atlas 1536 × 1024, trois colonnes Lian/Jun/Shen, deux rangées neutre/sourire. Cellules de 512 × 512, filtrage linéaire pour l'affichage de dialogue.
- Illustrations : assets/card_illustrations.png, atlas 2 × 2, quatre familles partagées (attaque, pétales, garde, souffle). Ce sont quatre illustrations, pas trente illustrations uniques.
- Interface : encre bleu sombre, texte ivoire, accents or, jade et rose. Les informations restent écrites, pas uniquement codées par couleur.
- Audio : deux sons synthétiques courts créés dans visual/preview.gd (acquisition/souffle et impact). Sons provisoires, pas une bande-son finale ni une ambiance musicale.
- Images créées avec l'outil imagegen intégré, puis copiées dans assets. Aucun achat réalisé. Le nom exact du modèle derrière cet outil n'est pas exposé dans cette session.
- Les atlas sont découpés dans Godot ; l'attaque de la recrue utilise maintenant l'export local Sprite Forge validé, copié dans assets/forge_attack. Sa géométrie corrigée conserve le pied débordant, sans changer les quatre poses ni les règles.

## Prompt final des portraits

Référence d'identité : premier atlas original de portraits, lui-même dérivé des sprites existants. Outil intégré, mode édition.

> Style-transfer edit of attached original game portrait atlas. Keep EXACT 3 columns x 2 rows equally sized grid, same original identities and navy background, same waist-up framing, no gutters no text. Transform from ornate semi-realistic painterly fantasy into crisp contemporary Korean murim webtoon/manhua aesthetic evocative of Return of the Blossoming Blade: clean confident black ink contours, angular attractive expressive faces, large readable eyes, hard cel shading with 2-3 tones, flat clear colors, graphic hair shapes, no painterly texture and NO pixelation on portraits. Simplify clothing to practical worn disciple robes without brocade, jewelry, armor or elaborate crowns: Lian muted rose outer robe ivory collar dark sash and simple hairpin, Jun dark indigo robe ivory collar and high black ponytail simple cord, elderly Shen ivory robe taupe sash white topknot and beard. TOP ROW neutral attentive Lian, stern skeptical Jun, wise serious Shen. BOTTOM ROW warm confident smile Lian, competitive cocky toothy grin Jun, gentle amused Shen. All characters original, preserve identities but improve comic expression range. Exact six equal cells with heads fully inside and breathing room. Deep navy teal solid background. Production dialogue portraits, sharp line art, 1536x1024 landscape atlas.

## Prompt des illustrations de cartes

> Production illustration atlas for a murim martial arts pixel-art card game, square canvas EXACT 2x2 equal quadrants with no gaps and no borders, four illustrations no text no lettering. Each quadrant has its subject centered, fully visible, dark ink navy background, atmospheric painted pixel art with crisp pixel clusters and mature elegant aesthetic. Top left: a traditional Chinese straight sword flashing diagonally with silver slash arc and warm gold sparks, attack icon illustration. Top right: pink plum blossoms circling a thin sword blade with rose qi ribbons, elegant petal sword technique. Bottom left: jade green stone seal and concentric translucent protective circular shield with mountain motif, defense technique. Bottom right: warm golden glowing cultivation pearl floating above an open hand with swirling ivory-gold energy, breathing and qi technique. Detailed but strong readable silhouettes at small 140px card sizes. Cohesive lighting and palette, no cards frames, no UI, no logos, no words. This will be cropped into four separate rectangular art regions at runtime.

## Limites et prochain retour

Cette scène est un échantillon visuel jouable, pas encore la vertical slice de 20–30 minutes de l'étape 7. Une nouvelle partie commence au jour 2 ; les reprises chargent sequence_visuelle_v2.json. La reconstruction du pavillon est intégrée. Personnalisation, cuisine/atelier et campagne complète restent dans les prototypes précédents. Le décor conserve son traitement pixel art.

## Menu de deck et sauvegarde

À la demande du créateur, référence de présentation : grille de cartes fournie en capture. Le deck affiche les douze exemplaires sous forme de cartes illustrées et défilantes, avec coût, nom et effets. Onglet Collection séparé ; détails complets au survol, au focus clavier et au clic. Une sélection équipée choisit l'emplacement à remplacer ; le remplacement est ensuite confirmé dans la collection. Une composition invalide est refusée.

Sauvegarde v2 séparée : état du calendrier, relations, ressources, bâtiments, collection, deck, étape du tutoriel, son et effets doux. Écriture temporaire puis remplacement, copie .bak, lecture validée et recours à la copie en cas de JSON corrompu. Le combat lui-même n'est pas sérialisé : reprise du point précédent. Recommencer demande confirmation et réinitialise cette séquence uniquement.

Test tests/test_visual_day.gd PASS : passage du calendrier, blocage M02, choix exclusif de serment, coûts de chantier, restauration, borne de fin, sauvegarde/relecture/secours corrompu, navigation réelle des boutons de deck et duel libre sans gain. Captures inspectées : tests/sequence-deck.png, tests/deck-collection-preview.png, tests/activities-preview.png. Les tests de séquence et d'animations restent PASS. Un avertissement du cache OpenGL est apparu lors d'exécutions parallèles ; le test final séquentiel s'est terminé sans erreur.

À examiner : cohérence entre portraits et hub, taille des personnages, lecture des cartes, compréhension de l'intention et sensation des impacts. Après ce retour : affiner les animations et l'audio, puis reprendre les tests humains d'équilibrage. Ne pas produire les trente illustrations avant validation de ce lot.

## Mise à jour — sprites et combats manhua

Les quatre personnages utilisent maintenant les nouveaux sprites dans le hub historique et la séquence visuelle : profil, face et dos, quatre poses de marche par direction. Recrue et Jun disposent de quatre poses dessinées pour l'attaque et quatre pour la garde. La lame reste visible en position de combat. Les dégâts sont appliqués à la frappe, les cartes mixtes enchaînent attaque puis garde, et Jun joue aussi ses intentions avec les animations correspondantes. Une garde positive maintient la pose de parade ; les entrées sont verrouillées durant l'action. Retour à la cour : poses de combat réinitialisées.

Les animations de combat sont intégrées dans la séquence visual/preview.tscn ; le laboratoire textuel et l'ancien panneau de combat ne deviennent pas des scènes animées. Les règles v0.2 et les ressources sont inchangées.

[Fichiers et prompts des sprites](../assets/MANHUA_SPRITES.md). Tests effectués avec rendu Godot : test_combat_animation.gd PASS (transparence, synchronisation, verrouillage, garde, attaque ennemie, effets doux), test_sequence.gd PASS (parcours complet), test_visuals.gd PASS (marches directionnelles, restauration et vent). Captures d'attaque et de garde examinées dans tests/manhua-attack.png et tests/manhua-guard.png.

## Vérifications

tests/test_sequence.gd parcourt l'acquisition, le refus d'une carte non possédée, la composition, un vrai duel avec animations, le passage au soir, l'absence de récompense répétée et le redémarrage : PASS sous Godot 4.4.1 avec rendu OpenGL. Captures Godot dans tests/sequence-*.png examinées pour contrôler le dialogue et les cartes ; correction des débordements de portrait et de texte. La suite du laboratoire prototypes/run_tests.gd a également été relancée : 43 927 vérifications, zéro échec. Ces tests ne remplacent pas l'essai artistique et ludique du créateur.
