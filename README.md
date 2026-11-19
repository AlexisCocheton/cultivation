# Les Cendres du Prunier

**Essai Sprite Forge :** lancer ComparatifSpriteForge.cmd pour comparer l'attaque actuelle à son traitement local par Sprite Forge. Même animation en quatre poses, découpage et transparence retravaillés, export Godot testé. Aucun frais engagé ; génération vidéo non disponible. [Bilan et limites](docs/ESSAI_SPRITE_FORGE.md).

## Nouvelle séquence visuelle — étape 5

Lancer **SequenceVisuelle.cmd** : portraits au style manhua, dialogue avec Lian, acquisition de Pétales tranchants, composition du deck et duel illustré avec Jun selon les règles v0.2. ZQSD/WASD/flèches ou clic pour marcher ; cliquer sur les boutons des disciples pour parler. Choisir un emplacement du deck puis une carte de la collection pour la remplacer.

La séquence couvre maintenant les jours 2 et 3 : activités sociales, travail, restauration visible du pavillon et serment du jour 3. Sauvegarde automatique après une activité, une composition de deck et avant/après un duel ; reprise avant le combat s'il a été interrompu. Fichier séparé sequence_visuelle_v2.json, avec copie de secours .bak. Les sauvegardes du hub et du laboratoire restent indépendantes. [Direction artistique, prompts et limites](docs/ETAPE_05_DIRECTION_ARTISTIQUE.md). Ouvrir visual/preview.tscn puis F6 pour la lancer depuis Godot.

Le menu du deck montre les cartes illustrées en grille défilante, avec coûts et effets. Survol ou sélection : texte complet à droite. Cliquer sur une carte équipée, choisir « Choisir un remplacement », puis une technique dans la collection et confirmer son équipement. Les limites de copies et les acquisitions sont vérifiées avant remplacement.

Sprites manhua harmonisés avec les portraits pour les quatre personnages, avec marches de face, de dos et de profil. Dans cette séquence, la recrue et Jun attaquent et parent avec des poses dessinées distinctes ; les dégâts se résolvent au contact. Le bouton « Effets : doux » réduit les mouvements rapides. [Assets et prompts](assets/MANHUA_SPRITES.md).

## Laboratoire des nouvelles règles

Lancer `Laboratoire.cmd` pour tester le calendrier de 14 jours, les relations et les trente cartes avec l'équilibrage v0.2. Le bouton « Composer mon deck » utilise uniquement vos acquisitions ; les activités de campagne utilisent cette composition. Retirer une technique puis en ajouter une de la collection, choisir les équipements, puis enregistrer douze cartes. Les suggestions respectent également les cartes possédées. La sauvegarde du hub n'est pas modifiée.

[Bilan v0.2 et protocole d'essai](docs/ETAPE_04_EQUILIBRAGE_V2.md) : neuf configurations comparées, économie révisée et 300 campagnes testées avec acquisitions réelles. Quatre decks de référence débloqués restent accessibles uniquement dans le duel hors calendrier. Les variantes +2/+4 y ajoutent des dégâts au nouvel équilibrage. L'étape 4 reste en cours : tests humains et narration représentative encore nécessaires. `Jouer.cmd` lance toujours le prototype visuel existant, avec ses anciennes règles.

La sauvegarde du laboratoire v0.2 utilise `laboratoire_etape4_v2.json` ; celle de v0.1 reste conservée. Le deck et l'équipement sont inclus dans les points de reprise.

Prototype Godot 4.4 : une secte murim déchue, une recrue personnalisable et six journées pour préparer l'inspection du septième matin.

## Jouer

Double-cliquer sur `Jouer.cmd`. Le moteur Godot officiel portable est inclus localement dans `tools/godot` (ignoré par Git).
Ou importer `project.godot` dans Godot 4.4+, puis F5.

- ZQSD, WASD ou flèches : déplacement.
- Clic sur la cour : déplacement ; clic sur un disciple : approche puis interaction.
- E : interagir à proximité ; Tab : techniques ; Échap : fermer un panneau hors combat.
- Boutons en haut : techniques, journal, repos et personnalisation.

Trois périodes par jour. Marcher, consulter les techniques et lire les dialogues ne coûte rien. Une activité, un duel ou un repos consomme une période. Les disciples se déplacent selon leur emploi du temps lors des changements de période.

Lian, Jun et Shen enseignent chacun une carte au niveau de lien 2. Lian propose un premier événement romantique le soir à partir du niveau 3 ; tous les personnages sont adultes. La cuisine rapporte des réserves, l'atelier permet d'équiper une épée conférant une carte, le pavillon peut être restauré trois fois. Avant J7, visez la restauration 3/3 et plusieurs techniques supplémentaires. Lors de l'inspection, la restauration complète ET la victoire au duel sont nécessaires.

Combat : 3 qi par tour, main de 5 cartes, intention ennemie visible, pioche et défausse recyclées. La garde absorbe les dégâts puis disparaît au début du tour suivant. Chaque duel commence à 40 PV. Le duel d'entraînement rapporte 2 réserves en cas de victoire. Une défaite consomme seulement la période.

## Sauvegarde

Automatique après une activité et la personnalisation. Avec Jouer.cmd, la sauvegarde est dans `tools/play-user/Godot/app_userdata/Les Cendres du Prunier/prunier_save.json`. Avec l'éditeur, Godot utilise son dossier utilisateur standard. Pour recommencer, renommer cette sauvegarde avant de relancer.

## État de cette première version

Fonctionnel : hub en perspective fixe, marche et interactions, personnalisation des couleurs et du nom, horaires, liens, premier événement amoureux, acquisition de cartes par relations et équipement, activités et calendrier, restauration chiffrée, duel et inspection, sauvegarde.

Base artistique : décor généré en perspective fixe, personnages animés sur planche de sprites (voir la mise à jour visuelle ci-dessous). Le rendu est une vue trois-quarts peinte en pixel art, pas encore une carte isométrique découpée en tuiles. La zone de marche est limitée à la cour ; les bâtiments ne sont pas visitables. La restauration du pavillon est visible en trois étapes. Pas encore de choix de composition de deck, de portraits détaillés, de musique, de véritable navigation avec obstacles ni de branches narratives longues. Les romances et rivalités sont les premiers jalons d'un système à développer.

## Structure

- `scripts/main.gd` : hub, interface, activités et orchestration.
- `scripts/state.gd` : progression, cartes, sauvegarde.
- `scripts/fighter.gd` : règles des duels.
- `scripts/avatar.gd` : personnages provisoires.
- `assets/sect_courtyard.png` : décor généré avec l'outil intégré imagegen.
- `tests/test_game.gd` : tests de progression, sauvegarde, combat, interactions et inspection.

## Validation

Depuis PowerShell, dans le projet :

```powershell
$env:APPDATA = Join-Path (Get-Location) 'tools/test-user'
& './tools/godot/Godot_v4.4.1-stable_win64_console.exe' --headless --path . --script res://tests/test_game.gd
& './tools/godot/Godot_v4.4.1-stable_win64_console.exe' --path . -- --smoke
```

Le second appel produit `tests/hub-preview.png` puis quitte.

## Direction artistique

Décors « Encre et fleurs de prunier », personnages élancés. Ambiance murim originale, sans personnages ni assets des œuvres citées comme inspiration.
Prompt du décor : voir `assets/ART_DIRECTION.md`. Moteur : https://godotengine.org/ ; binaire local officiel 4.4.1, licence MIT.

## Mise à jour visuelle

Les silhouettes dessinées en code sont remplacées par quatre personnages détaillés aux proportions adultes : recrue, Lian, Jun et Shen. Trois planches transparentes fournissent quatre poses par personnage et orientation, animées à 7,5 images/s. Quatre orientations : trois quarts droite/gauche, véritable vue de face en descendant et de dos en montant. Les diagonales suivent l'axe dominant (vertical à égalité). À l'arrêt, la dernière orientation est conservée. Respiration discrète, ombres au sol et recoloration de la recrue conservées. Les disciples marchent vers leurs destinations lors des changements de période.

La reconstruction a désormais un effet visible sur le pavillon central :
1. Marches et soubassement restaurés.
2. Toiture réparée.
3. Boiseries et bannières renouvelées.

Les transitions utilisent le compteur `repairs` existant : sauvegardes compatibles, aucune migration nécessaire. Les autres bâtiments ne disposent pas encore de leur propre chantier. Un shader combine localement le décor initial et sa version restaurée, sans remplacer la cour.

Le feuillage du prunier oscille sous un vent localisé ; 65 pétales suivent des trajectoires avec dérive, rotation et flottement. Aucun objet supplémentaire n'est nécessaire dans la scène pour utiliser ces effets.

Validation supplémentaire : `tests/test_visuals.gd` vérifie les régions restaurées, la stabilité de la cour et de l'architecture, le vent, les quatre poses et le retour à l'arrêt. Captures des trois étapes dans `tests/repair-stage-1.png` à `tests/repair-stage-3.png`.

