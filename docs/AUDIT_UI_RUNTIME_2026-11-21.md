# Audit des écrans réellement accessibles — 21 novembre 2026

Verdict de l’audit initial, avant correction : **à corriger**. tous les écrans ne sont pas cohérents. Le combat de la visiteuse est resté une présentation de prototype. Les tests fonctionnels passés lors de la précédente livraison ne prouvaient pas l’achèvement de ses variantes visuelles.

## Méthode et preuves

- 30 entrées de l’inventaire précédent, complétées par les transitions visiteuse et les variantes compagnons, résultats, espionne, collection vide et fin de séquence.
- 57 états capturés à 1280×832 et 960×624 : 114 PNG dans `ui-audit-runtime-2026-11-21/`.
- Scripts : `tests/audit_runtime_screens.gd` et `tests/audit_runtime_transitions.gd`. Exécution Godot graphique, audio Dummy, profil APPDATA isolé ; assertion de persistance désactivée. Aucune modification du code du jeu ni de la sauvegarde personnelle par cet audit.
- La visiteuse est ouverte via visitor_ui puis le bouton réel Relever le défi. Les résultats Jun 47 passent par finish_combat avec les textes du jeu. Les issues et PV des combats sont préparés pour examiner leurs écrans, sans prétendre avoir gagné/perdu ces combats manuellement.
- Les captures de résultats 37/38/49 ont été régénérées avec des PV cohérents ; les anciennes captures avec tous les combattants vivants étaient des fixtures artificielles, pas un bug prouvé du jeu.
- L’ancienne capture 08 répétait la description parce que le test remplissait lui-même le champ avec Cards.description. L’audit utilise maintenant le vrai contenu Effects et le badge Way séparé. Ne pas confondre ce défaut de fixture avec une régression de l’inspection réelle.

## Défauts confirmés

### P1 — Combat de la visiteuse resté au stade prototype

Preuve : `31-visiteuse-combat.png` et `31-visiteuse-combat-960.png`.
`visual/visitor/encounter.tscn:123` définit une Arena avec deux TextureRect et aucun décor de combat ; Shade couvre l’arrière-plan. `encounter.gd:21` affiche B01 en guise de recrue, ce qui remplace le héros vert par un homme en blanc. Les actions appellent pulse, un changement de couleur, sans les animations d’attaque/garde des autres combats. Les cartes, Qi, intentions et barres partagés ne suffisent donc pas à uniformiser la présentation.

Correction prioritaire : scène de combat commune paramétrée par décor, combattants et animations. Réutiliser les assets de la recrue ; préparer les poses nécessaires de la visiteuse en respectant son concept art. Ne pas se limiter à ajouter un fond derrière les deux portraits.

### P2 — Inspection d’une carte depuis les compagnons : focus non transféré

Preuve code : `visual/team/companions.gd:46–53` remplit Detail puis show, sans donner le focus à Close ; contrairement à l’inspection du deck et du bilan. Test50 : focus nul lors d’une ouverture programmée, fonds bloqués à la souris mais aucun focus initial modal. Échap ferme déjà correctement. Risque : navigation clavier restant hors de la fiche quand elle était initiée depuis une carte.

Correction : centraliser ouverture/fermeture de la fiche, mémoriser le contrôle d’origine, transférer et contenir le focus, puis le restituer. Vérifier le parcours clavier effectif avant de qualifier cette réserve de blocage de navigation.

### P3 — Résultats et retours : illustration indépendante du résultat

`visual/combat/result.gd:6` utilise toujours la scène joyeuse de Jun, victoire ou défaite (`36-jun-defaite.png`, `47-jun-resultat-reel-defeat.png`). Le retour du tournoi réutilise le rassemblement du serment malgré les textes décrivant des disciples blessés (`27-retour.png`). Les conséquences écrites sont correctes, mais l’illustration peut les contredire.

Correction : variantes de résultat sobres, ou composition neutre commune ; ne pas modifier les conséquences du combat pour les adapter à l’image.

### P3 — Recherche sans résultat : message incorrect

Preuve : `43-collection-vide-960.png`. Sous Toutes, chercher une chaîne sans correspondance affiche « Aucune carte acquise dans cette voie », alors que le joueur possède des cartes. Le message statique de `visual/deck/menu.tscn:167` est activé par `menu.gd:111` sans distinguer les causes.

Correction : différencier aucune correspondance, voie vide et collection vide ; proposer d’effacer la recherche.

## Ce qui n’est pas un nouveau bug

- Les actions indisponibles selon l’horaire, la taille de deck et le recrutement restent intentionnellement verrouillées.
- La fin de séquence J7 est explicitement signalée ; l’arrivée de l’espionne J8 est une scène narrative, pas une campagne entière J8–J14 déjà livrée.
- La préparation présente quatre candidats et les règles ont moins d’illustrations que les maquettes : limites de fidélité déjà consignées, pas interfaces vides.
- Le portrait souriant de Jun a désormais une transparence propre dans l’état46.

## Limites de cet audit

Captures et vérification du code couvrent les états listés, pas toutes les combinaisons de cartes, de liens et d’échecs d’écriture. Les erreurs de sauvegarde, le clavier complet dans chaque modal, les résolutions hors des deux formats et un parcours utilisateur intégral restent à vérifier spécifiquement. Un rendu capturé sans erreur moteur ne signifie pas « validation artistique ».

## Prochaine passe recommandée

1. Corriger la présentation du combat visiteuse par le composant de combat commun.
2. Ajouter ce parcours et ses résultats à la vérification visuelle systématique.
3. Uniformiser les fenêtres d’inspection, dont focus et retour.
4. Adapter les illustrations de résultat et traiter les réserves de composition relevées par le critique.

## Revue indépendante achevée

Verdict critique : **à corriger**. P1 visiteuse confirmé ; P2 focus et P3 illustrations/recherche vide confirmés, sans autre anomalie majeure relevée dans les 30 captures nominales. Le critique a vu ces 30 images puis les variantes runtime31–49, surtout à 960, et lu le routage, la visiteuse, le présentateur, les dialogues, résultats et inspections. Il n’a pas rejoué les combats ni inspecté personnellement les 114 PNG. Les fixtures artificielles 08/37/38 ne sont pas retenues comme bugs de production. Cet audit ne livre aucun correctif de gameplay ou d’interface ; il identifie et priorise la prochaine passe.


## Passe corrective autorisée — 21 novembre 2026

Les quatre constats ci-dessus décrivent l’état initial. Les captures du même dossier ont été réactualisées après correction : elles montrent désormais le résultat corrigé, pas les anciennes preuves.

- Visiteuse : décor d’arène existant, recrue verte animée réutilisée, quatre poses à l’éventail depuis le concept validé. Même présentateur d’attaque/garde que les autres duels, contact appliqué une seule fois, approche et retour. Les règles et la progression restent dans les moteurs existants.
- Fiche partagée : focus sur Fermer, Tab/Shift+Tab et directions contenus, restitution au contrôle d’origine. Le même composant sert aux compagnons, au deck et au bilan.
- Défaite Jun : recrue au repos. Retour avec un membre à terre : préparation de soins ; retour sans blessé conserve le rassemblement. Réutilisation d’illustrations existantes.
- Recherche : distinction entre absence de correspondance, voie sans cartes et collection vide ; effacement disponible dans le champ existant.

Validation : 24 suites de régression passées ; test_runtime_ui_fixes.gd passé en rendu graphique (actions normales et mouvement réduit, dégâts uniques, retour des acteurs, garde, focus, recherche). Les deux scripts d’audit passent, soit 57 états à deux tailles. Les captures 51/52 montrent les poses supplémentaires. Profils APPDATA isolés et persistance désactivée ; aucun lancement de la sauvegarde personnelle pendant ces tests.

La visiteuse utilise une animation en poses, pas une animation fluide redessinée image par image. Les scénarios de résultat sont préparés par les tests : ils ne constituent pas une partie manuellement jouée de bout en bout.

### Contre-revue finale des corrections

Verdict indépendant : **prêt avec réserves de finition**. Aucun autre blocage identifié. Le critique a vérifié les captures actuelles et les changements partagés. Sa première réserve sur des franges rouges a été rectifiée après lecture alpha indépendante : 6421 pixels rouges, tous à 1–2/255 d’opacité ; pas de contour rouge opaque prouvé dans Godot. Le shader alpha_cleanup.gdshader écarte les résidus sous 0,02 d’alpha sans recolorer le sprite. Les captures 51/52 et le test ciblé ont été refaits après ce filtre.

Réserves non bloquantes : costume de la visiteuse plus dense que celui de la recrue, animation limitée à quatre poses. Ni le critique ni ces fixtures ne remplacent une validation artistique du joueur ou un parcours manuel complet.
