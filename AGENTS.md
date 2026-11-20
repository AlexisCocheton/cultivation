# Les Cendres du Prunier — consignes de collaboration

## Revue critique obligatoire

Demandée explicitement par le propriétaire du projet le 20 novembre 2026.
Pour toute prochaine modification ou implémentation, faire intervenir un agent
indépendant nommé `critique` avant de déclarer le travail terminé.
Réutiliser l’agent existant dans la conversation si disponible ; sinon en créer
un avec cette mission. L’agent principal coordonne et reste responsable des
corrections et de la validation finale. Il ne remplace pas la revue par une
autoévaluation et n’annonce pas une revue qui n’a pas eu lieu.

### Mission du critique

- Examiner le résultat réellement implémenté, pas uniquement la description.
- Pour l’interface, regarder les captures Godot actualisées et les interactions
  pertinentes : composition, proportions, cadres, intégration des illustrations,
  lisibilité, débordements, états de boutons, navigation et tailles d’écran.
- Chercher les éléments manquants, les baisses de qualité, les incohérences entre
  écrans et les changements appliqués à un seul endroit au lieu des composants
  partagés. Vérifier le respect des références et des choix validés du joueur.
- Pour le code, examiner les risques de régression, les règles métier, la
  réutilisation des composants et les tests pertinents. Préserver les sauvegardes.
- Adapter la profondeur à la modification : ne pas refaire un audit global pour
  une correction locale. Les corrections purement documentaires ont une revue
  courte de cohérence et d’exactitude.
- Si une maquette est fournie, comparer explicitement la référence et une capture
  actuelle côte à côte : icônes, cadres, proportions, densité, typographie,
  hiérarchie et intégration. Une interface fonctionnelle ne suffit pas à valider
  la qualité visuelle. Signaler chaque élément important omis ou simplifié ;
  distinguer les différences voulues par le joueur des pertes de finition.

### Déroulement

1. L’agent principal réalise le changement et les vérifications pertinentes.
2. Il transmet au critique le périmètre, les références validées, les fichiers
   modifiés, les captures actuelles et les résultats des tests.
3. Le critique travaille en lecture seule et retourne des constats concrets,
   classés par gravité, avec preuve, conséquence et correction proposée.
   Distinguer défaut vérifié, risque non vérifié et préférence subjective.
4. Corriger les défauts bloquants ou importants dans le périmètre demandé, puis
   demander une contre-vérification ciblée. Ne pas modifier silencieusement les
   règles du jeu ou les choix artistiques validés pour satisfaire une préférence.
5. Consigner les réserves restantes. Un verdict « prêt avec réserves » doit
   préciser lesquelles ; ne pas présenter une limitation connue comme résolue.

Verdicts : **prêt**, **prêt avec réserves**, **à corriger**.
La revue ne nécessite pas une nouvelle autorisation utilisateur. Si le service
d’agents est indisponible, le signaler explicitement ; ne pas simuler son avis.

## Références visuelles et sauvegardes

- Si une ambiguïté du prompt change le périmètre ou la composition attendue,
  demander une clarification avant de choisir une interprétation. Préférence
  explicitement demandée par le joueur le 20 novembre 2026.

- Inventorier les assets avant toute génération et réutiliser ceux qui conviennent.
- Les concept arts définissent l’identité ; ils ne sont pas des images d’interface
  prêtes à recadrer. Composer scènes, personnages, cadres et textes en calques.
- Garder les illustrations interchangeables et les données en contrôles Godot.
- Valider les changements sur un profil de test isolé, sans écraser la partie du joueur.
