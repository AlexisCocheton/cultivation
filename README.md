# Les Cendres du Prunier

Prototype Godot 4.4.1 d’un jeu murim de relations, de reconstruction et de combats de cartes. La séquence actuelle couvre les jours 2 à 4 ; le laboratoire explore les règles de la campagne de 14 jours. Le jeu complet de 3–5 heures reste en développement.

## Lancer la version actuelle

- **Jouer.cmd** ou **SequenceVisuelle.cmd** : même version actuelle, même sauvegarde de partie normale.
- **ParcoursTest.cmd** : même jeu, avec la sauvegarde séparée du parcours de test. Relancer reprend ce parcours sans l’effacer.
- **Godot : importer project.godot puis F5** : lance désormais `visual/preview.tscn`. L’éditeur conserve son dossier utilisateur Godot standard, distinct des profils des lanceurs. Pour retrouver la progression jouée avec un lanceur, utiliser ce même lanceur.

Les lanceurs nécessitent le moteur portable local dans `tools/godot`. Une copie du dépôt Git seule ne contient pas ce binaire. Pour le développement, utiliser Godot 4.4.1.

Dans la cour : ZQSD/WASD/flèches ou clic pour marcher ; les boutons ouvrent les activités et les rencontres. Lian dispose d’un jardin, Shen d’un pavillon ; Jun propose des duels progressifs. Le marchand du jour 4 fournit des équipements. Le menu du deck permet de choisir de 12 à 20 cartes acquises : Ajouter, Retirer ou Remplacer, sans obligation de remplir vingt places. Le premier lot orthodoxe propose des effets persistants de pioche/Force et des bonus liés à la taille initiale du deck.

## Sauvegardes

Les lanceurs conservent leurs emplacements existants :

- Partie normale : `tools/play-user/Godot/app_userdata/Les Cendres du Prunier/sequence_visuelle_v2.json`.
- Parcours de test : `tools/parcours-test-user/Godot/app_userdata/Les Cendres du Prunier/sequence_visuelle_v2.json`.

Le nom historique du fichier reste inchangé ; les nouvelles écritures utilisent le format v4 et lisent aussi les formats v2/v3. La première conversion conserve aussi une archive `.before-orthodox`. Une copie `.bak` permet la récupération. Seul un fichier principal validé remplace cette copie ; une sauvegarde corrompue ne l’écrase plus. La migration garde également l’archive `.before-day4` lorsqu’un ancien fichier principal v2 est présent.

Avant les corrections de fiabilité, une copie datée des deux profils a été créée dans `tools/save-backups/`, avec empreintes SHA-256. Les profils et ces copies sont exclus de Git. Ne pas supprimer ces dossiers pour mettre le jeu à jour.

## Historique et validation

Git conserve désormais un état initial jouable du jour 4 et les corrections suivantes. Cet historique est local ; il ne constitue pas une sauvegarde distante du disque.

Les tests doivent employer un profil isolé. Exemple PowerShell depuis le projet :

```powershell
$env:APPDATA = Join-Path (Get-Location) 'tools/regression-user'
& './tools/godot/Godot_v4.4.1-stable_win64_console.exe' --headless --path . --script res://tests/test_reliability.gd
```

`test_reliability.gd` vérifie les corruptions successives, la conservation de la copie de secours, le refus d’un état invalide, la reprise de copies des profils existants, Exposé et la scène principale. Autres suites : `test_day4_merchant.gd`, `test_combat_ui.gd`, `test_jun_progression.gd` et `prototypes/run_tests.gd`.

## Versions de travail et documentation

- `Laboratoire.cmd` : calendrier, économie et combats des règles v0.2, sauvegarde indépendante.
- `ComparatifSpriteForge.cmd` : comparaison de l’animation d’attaque.
- `main.tscn` : ancien prototype conservé, accessible explicitement par F6 ; il n’est plus la scène principale. Sa sauvegarde `prunier_save.json` n’est pas convertie en partie actuelle.
- [Plan de développement](docs/PLAN_DEVELOPPEMENT.md).
- [Règles validées](docs/ETAPE_03_REGLES_DU_JEU.md).
- [Direction artistique](docs/ETAPE_05_DIRECTION_ARTISTIQUE.md).
- [Essai Sprite Forge](docs/ESSAI_SPRITE_FORGE.md).

Décors et personnages originaux inspirés de l’ambiance murim ; interfaces papier et encre, titres Kaushan Script et textes d’effets lisibles. Les assets et leurs notes sont conservés dans `assets/`.
