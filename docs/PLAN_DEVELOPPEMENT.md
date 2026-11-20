# Plan de développement des Cendres du Prunier

Version du 19 novembre 2026. Nom de travail, à confirmer.

**Nouvelle décision de périmètre validée :** deux voies de reconstruction, orthodoxe et démoniaque, une PNJ initiatrice et conversion des disciples par amitié ou par la force. Contenu planifié, non implémenté ; voir la section « Deux voies de reconstruction et initiation démoniaque » en fin de document.

Ce plan organise le passage du prototype Godot actuel à un jeu publiable. Chaque étape produit un résultat vérifiable ; atteindre une étape signifie satisfaire ses critères, pas simplement ajouter les fonctionnalités prévues. Les chiffres de contenu et les délais commerciaux seront fixés après mesure du coût réel d'une séquence représentative.

## Méthode et sources

Les grandes phases sont la préproduction, la production, la finalisation et le suivi après sortie. La planification, le prototypage et l'organisation du travail précèdent la production à grande échelle. Cette structure reprend les principes présentés par [Unity Learn](https://learn.unity.com/tutorial/the-real-time-production-cycle?uv=2021.3).

Une vertical slice est une courte séquence représentative de l'expérience et du niveau de qualité visés. Elle sert aussi à éprouver la capacité à fabriquer le contenu. Le [guide de CG Spectrum](https://www.cgspectrum.com/hubfs/gamedev-careerguide.pdf?hsLang=en) présente son rôle dans le processus de développement.

Les étapes détaillées ci-dessous sont une adaptation à notre projet, et non une norme unique appliquée par tous les studios. Les termes alpha et bêta ont ici les définitions explicites indiquées dans le tableau.

## Situation actuelle

Le projet dispose d'un prototype : cour explorable, personnalisation simple, horaires de trois personnages, liens élémentaires, calendrier, cartes acquises, duel, inspection, sauvegarde et changements visuels de restauration. Les personnages ont des cycles de marche latéraux, de face et de dos. Un décor généré, des effets de feuillage et des pétales donnent une première direction visuelle.

Cela ne constitue pas encore une vertical slice validée. La profondeur des choix, l'équilibrage, les parcours narratifs, la cohérence des assets, le son, l'accessibilité et le fonctionnement d'une version distribuable doivent encore être travaillés. Les tests automatisés existants vérifient certains comportements ; ils ne remplacent pas des parties réalisées par des joueurs extérieurs.

## Étapes et critères de passage

| Étape | Travail | Livrables | Critère de passage |
|---|---|---|---|
| 1. Cadrage | Définir la promesse, le public, les piliers, les limites et les hypothèses de ressources. | Note de vision, périmètre initial, décisions ouvertes. | Une vision commune et un périmètre cible explicitement validés. |
| 2. Faisabilité et positionnement | Comparer les expériences proches, identifier la différence du jeu, inventorier les compétences, outils, coûts et risques. | Comparatif ciblé, registre des risques, hypothèses de budget et de disponibilité. | Les risques majeurs ont un test ou une réduction de périmètre prévue. |
| 3. Conception des systèmes | Définir les règles du calendrier, combat, deck, liens, reconstruction et progression ; traiter les échecs et les conflits de conditions. | GDD vivant, schémas de boucles, tables de règles, exemples joués sur papier. | Une journée et un combat sont simulables sans ambiguïté majeure. |
| 4. Prototypes ciblés | Tester plaisir des combats, choix d'activités, conséquences relationnelles et pression du calendrier. Réutiliser le prototype existant. | Petits scénarios jouables, observations de tests, décisions de conserver/modifier/supprimer. | Les joueurs comprennent les choix et plusieurs stratégies restent intéressantes. |
| 5. Direction artistique et sonore | Fixer résolution, grille, taille des sprites, orientations, cycles, portraits, interface, palettes, ambiance et effets sonores. | Bible artistique, modèles d'assets, scène de référence et échantillons audio. | Des assets de sources différentes restent cohérents dans le jeu réel. |
| 6. Fondations techniques | Découper les responsabilités Godot, externaliser les données, structurer les scènes, sécuriser sauvegardes et outils de contenu. | Architecture documentée, export reproductible, tests, journal d'erreurs et sauvegardes versionnées. | Un nouveau personnage, une carte ou une activité s'ajoute sans modifier toute la logique centrale. |
| 7. Vertical slice | Réaliser 20 à 30 minutes représentatives : accueil, journée sociale, choix de technique, préparation, combat, restauration et conséquence. | Une version complète avec graphismes cohérents, sons, interface et tutoriel. | Un nouveau joueur termine la séquence sans guidage oral ; qualité et méthode de fabrication jugées suffisantes. |
| 8. Planification de production | Mesurer le temps de fabrication de la slice ; fixer le volume final et le contenu prioritaire. | Liste de contenu chiffrée, budget, calendrier, responsabilités, marges et plan de réduction. | Le périmètre tient dans les moyens identifiés, avec une réserve pour les imprévus. |
| 9. Production par chapitres | Produire environnements, personnages, dialogues, quêtes, rencontres, cartes, animations et audio en lots jouables. | Chapitres intégrés et testés, suivi des tâches et versions régulières. | Chaque lot fonctionne dans le parcours complet, pas seulement en isolation. |
| 10. Alpha | Connecter la campagne entière et terminer les systèmes prévus ; conserver une liste explicite des éléments provisoires. | Jeu parcourable du début à la fin, revue de progression et inventaire des manques. | Aucun système majeur absent ; chaque chemin indispensable est accessible. |
| 11. Finalisation du contenu | Remplacer les éléments provisoires, compléter les branches, affiner les animations, sons, tutoriels et textes. | Contenu complet, textes stabilisés, première passe de localisation. | Le contenu prévu est présent ; les ajouts importants passent par arbitrage de périmètre. |
| 12. Bêta | Corriger, équilibrer et optimiser ; tester sur machines cibles et avec joueurs extérieurs. | Rapports QA, tests de compatibilité, accessibilité, retours de parties et correctifs. | Objectifs de stabilité, compréhension, performances et sauvegarde atteints. |
| 13. Préparation commerciale | Finaliser page boutique, captures fidèles, bande-annonce, démo éventuelle, prix, support, crédits et informations demandées par la plateforme. | Dossier boutique, plan de communication et calendrier de publication. | Présentation fidèle au jeu, éléments nécessaires prêts et examens de plateforme anticipés. |
| 14. Version candidate | Geler une version précise ; tester installation neuve, mises à jour, reprise des sauvegardes, paramètres et parcours complet. | Release candidate identifiée, liste des problèmes connus, procédure de retour à la version précédente. | Aucun défaut bloquant identifié ; décision de sortie fondée sur une checklist. |
| 15. Sortie | Publier, surveiller les erreurs et retours, trier les signalements et préparer les correctifs urgents. | Version publique, annonces, canal de support et suivi des incidents. | Achat, téléchargement et démarrage vérifiés ; support opérationnel. |
| 16. Après sortie | Corriger, améliorer et décider des extensions selon les retours et les moyens. | Correctifs, bilan de production et feuille de route éventuelle. | Les priorités répondent à des problèmes observés ; chaque nouveau contenu est replanifié. |

## Travaux qui se poursuivent en parallèle

- **Production et budget** : une personne porte chaque décision et chaque tâche, même si la même personne cumule plusieurs métiers. Réévaluer le reste à faire à chaque jalon.
- **Tests** : tester les règles dès la conception, les versions à chaque livraison et l'expérience avec des personnes extérieures avant la bêta.
- **Communication** : préciser le public dès le cadrage ; recueillir des retours et préparer des supports lorsque l'expérience est représentative. Ne pas attendre la fin du jeu.
- **Accessibilité** : prévoir lisibilité, remappage, volume séparé, réduction des animations et absence d'information portée uniquement par une couleur dès les interfaces initiales.
- **Localisation** : séparer les textes du code et prévoir les variations de longueur tôt ; traduire les textes stabilisés.
- **Gestion des assets** : suivre origine, fichier source, droits d'utilisation et crédits des ressources, y compris les contenus générés.
- **Sauvegardes et versions** : Git, sauvegarde externe du dépôt et des sources, versions jouables identifiées ; éviter de dépendre d'un seul ordinateur.

Pour une sortie Steam, la page boutique et la version jouable font l'objet d'un processus de vérification distinct ; leur préparation doit être anticipée. Les conditions seront revérifiées au moment de planifier la publication. Voir la [documentation de validation Steamworks](https://partner.steamgames.com/doc/store/review_process). Les tests externes pourront utiliser une distribution privée ou [Steam Playtest](https://partner.steamgames.com/doc/features/playtest).

## Rythme de travail proposé

Cycles d'une à deux semaines, adaptés à la disponibilité réelle : choisir un objectif jouable, décomposer les tâches, réaliser, tester, puis montrer une version. À la revue, relever les problèmes de compréhension, les défauts et le coût réel avant de choisir le prochain objectif.

Une tâche est terminée lorsque le comportement est intégré, testé, relu visuellement si nécessaire et documenté quand il modifie les règles. Un jalon insuffisant entraîne une correction ou une réduction de périmètre, pas automatiquement le passage à la suite.

## Priorités immédiates

**État courant :** jour 4 intégré avec marchand S01 et équipements ; plafond visuel à la fin du jour 4. Sauvegardes v2 reprises sans réinitialisation, écriture v3 avec archive avant migration. Duels progressifs vérifiés. Fiabilité des sauvegardes et affichage Exposé corrigés ; historique Git local créé ; lancement principal sur la séquence actuelle. J5–J6 et S06 restent à produire. Les paragraphes ci-dessous retracent les décisions des étapes précédentes ; voir le dernier bilan d’intégration en fin de document.

1. Cadrage initial terminé : jeu complet de 3 à 5 heures, créateur accompagné de Codex, budget de 100 €, plusieurs heures par jour disponibles, reprise avant l'événement final en cas d'échec. Voir [la note de vision](ETAPE_01_CADRAGE.md).
2. Périmètre de l'étape 2 validé : [dossier détaillé](ETAPE_02_FAISABILITE.md). Cible : 1 recrue, 3 résidents, 2 visiteurs, 30 cartes au total, 5 lieux dans 3 scènes, 24 événements, 10 à 12 combats et 14 journées. Trois chantiers à deux niveaux ; une romance facultative et une fin principale. Coût réel à mesurer avec un lot témoin.
3. Règles de l'étape 3 validées par le créateur : [conception des systèmes](ETAPE_03_REGLES_DU_JEU.md).
4. Étape 4 : équilibrage v0.2 conservé à titre provisoire. [Bilan actuel](ETAPE_04_EQUILIBRAGE_V2.md). 10 800 combats de calibration, 2 600 duels de contrôle et 300 campagnes acquises (3 600 combats). Le créateur a essayé le laboratoire et juge qu'une interface sans visuels ne permet pas encore un retour utile sur le plaisir. Tests humains reportés jusqu'à une présentation représentative ; étape non clôturée.
5. Étape 5 en cours : [direction artistique et séquence jouable](ETAPE_05_DIRECTION_ARTISTIQUE.md). Référence Mount Hua recherchée sur le site officiel ; portraits originaux au style manhua, deux expressions par résident. Première séquence isolée : dialogue → acquisition → deck réel → duel illustré avec règles v0.2. Lancement par SequenceVisuelle.cmd. Tests d'intégration et captures Godot ; validation artistique du créateur encore attendue. Pas de changement du périmètre ni de validation implicite de l'équilibrage.

Vérification du lot visuel : parcours d'intégration PASS dans Godot 4.4.1 ; régression du laboratoire : 43 927 vérifications, zéro échec. Présentation examinée sur les captures réelles du moteur.

Mise à jour artistique : sprites des quatre personnages harmonisés avec les portraits manhua, marches de face/dos/profil conservées. Dans la séquence visuelle, recrue et Jun disposent d'attaques et de gardes en quatre poses dessinées, dégâts synchronisés au contact et garde maintenue tant que la protection subsiste. Tests d'animation, de séquence et de régression visuelle PASS. L'équilibrage reste v0.2 ; validation humaine de l'étape 5 toujours attendue.

Essai d'outillage demandé : les cinq skills Agent Sprite Forge sont installés. [Bilan sans frais](ESSAI_SPRITE_FORGE.md) : comparaison locale d'une attaque existante, correction par ownership d'un pied débordant (91 pixels récupérés), export Godot testé, mêmes quatre poses et timing conservé. Aucun appel payant. ComparatifSpriteForge.cmd ouvre les deux versions. La génération d'une animation nouvelle reste à tester : aucune route vidéo actuellement disponible. Production inchangée ; budget autorisé pour cet essai : 0 €.

Lot suivant intégré pendant l'essai du créateur : attaque corrigée Sprite Forge utilisée dans le jeu, activités au choix jusqu'à la fin de J3, reconstruction visible du pavillon en deux niveaux, serment M02, bilan et sauvegarde v2 avec secours. Refonte du menu demandée à partir d'une capture : grille de cartes, coût et effets visibles, fiche de lecture, onglets deck/collection et remplacement confirmé. Tests du parcours, des combats, du calendrier, de la sauvegarde et des boutons du deck PASS. Aucun nouveau frais. La fenêtre de test déjà ouverte n'a pas été remplacée ; ces changements sont accessibles au prochain lancement de SequenceVisuelle.cmd.

Aucune date de sortie n'est fixée. Le budget disponible est de 100 € ; l'étape 2 propose des enveloppes indicatives sans achat engagé. Les coûts réels, la comparaison commerciale et le choix de distribution restent à établir. La sauvegarde avant le final fonctionne dans le laboratoire ; sa migration vers le hub et sa sécurisation pour la production restent à réaliser.

## Périmètre de production validé

Le [dossier de faisabilité](ETAPE_02_FAISABILITE.md) détaille les comptes, les limites artistiques, la répartition des cartes et événements, l'hypothèse de durée et les réductions possibles. La cible reste un jeu complet de 3 à 5 heures ; les 20 à 30 minutes de slice servent à vérifier sa qualité et à mesurer le coût de fabrication.

Les nouvelles quantités remplacent les hypothèses correspondantes du prototype, sans s'y ajouter. Le calendrier de 14 jours, les règles des chantiers, les rangs de lien et les trente cartes sont maintenant expérimentés dans le laboratoire séparé ; le hub principal conserve ses anciennes règles. Dialogues finalisés et intégration complète restent à produire. Ne pas étendre le volume avant d'avoir évalué le lot témoin et ses corrections.

## Règles cibles de l'étape 3

- 42 périodes : six séquences narratives réservées et 36 périodes libres ; exploration et préparation du deck gratuites.
- Deck de douze cartes ; trente définitions réparties entre huit techniques de base, neuf relationnelles, quatre d'équipement, deux d'objets réutilisables et sept d'événements.
- Trois résidents avec cinq rangs (révision du 20 novembre 2026) : rencontre, transmission, recrutement, seconde transmission, amélioration des techniques pour les deux personnages. Romance facultative au rang 5 de Lian.
- Duel solo avec 45 PV de départ, trois qi par tour, main de cinq cartes et intentions annoncées ; combat d’équipe révisé le 20 novembre : trois personnages contrôlés, mains et qi séparés (voir dernière section) ; v0.2 ajoute une pression progressive au boss et ajuste quatre cartes de Lian/Shen.
- Trois chantiers, chacun coûtant trois puis quatre réserves et une période par niveau. Récompenses fonctionnelles et changements visuels.
- La reconstruction facilite le final, sans en bloquer l'accès. La victoire au duel conclut l'histoire ; les autres réalisations modulent l'épilogue.
- Sauvegardes distinctes avant activité, préparation finale et inspection. Défaite finale : reprise du point préalable, sans sursis automatique.

Le [document des règles](ETAPE_03_REGLES_DU_JEU.md) contient le catalogue complet, les horaires, les déclencheurs, l'ordre de résolution du combat et les critères de test. Il est la référence de conception pour la prochaine implémentation ; les nombres pourront être ajustés après les tests sans augmenter le périmètre validé.

## Résultats actuels de l'étape 4

- Lancement : `Laboratoire.cmd`. Modules dédiés dans `prototypes/`, sans écriture dans la sauvegarde du hub.
- Version active v0.2 : boss +2 dégâts initiaux puis +2 tous les trois tours ; combos Lian à 12/18 dégâts, garde Shen à 8/10. Les autres profils gardent leurs valeurs d'apprentissage.
- Aide : +2 réserves, +3 après réparation de la cuisine ; événements matériels : +1 ; duels libres : +1, sentier +2, pendant les trois premières victoires seulement. Équipement : 3 réserves, 2 avec atelier amélioré. Travaux inchangés à 3 puis 4.
- Deck manuel de douze cartes réellement acquises ; une arme, un talisman et une sacoche. Équipement cohérent avec les cartes, suggestions filtrées, validation atomique et sauvegarde de la composition. Les presets entièrement débloqués sont réservés au duel hors calendrier.
- 43 927 vérifications répétées, zéro échec. Les deux parcours de 42 périodes restent finançables même en perdant les combats intermédiaires. Réserves finales reconstruction : 4 à 9 ; équipement : 13 à 18.
- Sur cent graines, avec trois améliorations et sans repas : victoires contre le boss 14 % départ, 100 % Jun, 93 % Shen, 90 % Lian. Avec les cartes réellement acquises dans 300 campagnes : 44 à 50 victoires finales sur 50 selon parcours/style. Résultats d'agent automatique, pas validation humaine.
- Historique préservé : `prototypes/results-v1.json`. Résultats v0.2 : `prototypes/results-v2.json` et `results.json`. Comparaison des neuf configurations : `prototypes/balance_results.json`.
- Prochaine action : essais humains sur compositions manuelles et choix de calendrier, puis scène relationnelle représentative. Le hub principal n'a pas encore migré vers ces règles ; l'étape 4 reste ouverte.

## Menu de deck — direction « L’encre et le sabre » intégrée

Le 19 novembre 2026 : proposition 2 retenue par le joueur et intégrée à la séquence visuelle. Menu dans `visual/deck/menu.tscn`, cartes dans `tile.tscn`, thème et cadres SVG dédiés. Douze cartes visibles en quatre colonnes et trois lignes à 1280 × 832, papier ivoire, encre noire, sceaux vermillon, sélection persistante et fiche illustrée. Textes issus du catalogue et de l’équilibrage actif. Illustrations existantes réutilisées : les compositions et textures de la maquette ne sont pas reproduites à l’identique.

Remplacement depuis la collection réellement acquise, contrôles des doublons, motif de refus visible, retour à la cour et Échap. Ouverture directe possible avec `res://visual/preview.tscn -- --deck` ; chargement de la sauvegarde habituelle.

Validation : `tests/test_visual_day.gd` PASS ; `tests/test_deck_manhua.gd` PASS (douze cartes dans le cadre, combo réel, remplacement valide, limite de doublons, retour). Capture réelle : `tests/deck-manhua.png`. Retour utilisateur sur lisibilité et confort encore attendu.

### Interface de combat cohérente avec la proposition 2

Le 19 novembre 2026 : le combat réutilise les cartes `visual/deck/tile.tscn`, le thème ivoire/encre/vermilllon et les boutons en forme de trait de pinceau. HUD éditable dans `visual/combat/hud.tscn` : PV, garde, intention adverse, Qi, décomptes des piles, effets et dégâts actuels au survol/focus (bonus, combo et garde adverse). Cinq cartes visibles ; main jusqu’à dix cartes accessible par défilement. Cartes indisponibles atténuées avec coût barré et explication. Actions bloquées pendant les animations. Écran de résultat du duel également harmonisé (`result.tscn`). Les règles de combat restent inchangées.

Validation : tests d’animation et test ciblé `tests/test_combat_ui.gd` réussis ; captures réelles `tests/combat-manhua.png` et `tests/combat-result-manhua.png`. La planche `docs/ui-proposals/font-comparison.png` compare trois associations à partir des polices système, sans achat ni installation : Georgia italique + Segoe UI (actuelle), Cambria + Segoe UI, Palatino Linotype italique + Calibri. Choix définitif de la police en attente du joueur ; la planche est éditable dans `visual/combat/font_proposals.tscn`.

### Typographie validée et intégrée

Le 19 novembre 2026, le joueur a choisi Kaushan Script pour les titres, noms des cartes et boutons. Police embarquée dans `assets/fonts/kaushan/` avec licence OFL ; thème partagé du deck et du combat mis à jour. Effets, coûts, PV et compteurs de combat restent en Segoe UI. La séquence visuelle hérite également de la typographie des boutons et des titres principaux. Captures du deck et du combat relues ; tests `test_deck_manhua.gd` et `test_combat_ui.gd` réussis. Aucun achat.

### Proposition de composition du hub et des dialogues

19 novembre 2026 : maquettes générées avec l’outil imagegen intégré, non implémentées, à examiner avec le joueur. Références : capture du hub fournie par le joueur et portraits_manhua.png.

- docs/ui-proposals/hub-vivant-concept.png : cour plus intime, vue de biais, Lian sous le prunier avec table, Jun auprès des mannequins, Shen lisant sur la terrasse. Ombres de contact, premier plan, UI légère calendrier/réserves/objectif, interaction à proximité et trois accès Techniques/Activités/Menu. Demande de génération : recomposer le hub murim en conservant les quatre personnages, la secte déchue et le style encre/ivoire/vermilllon, avec cohérence d’échelle, lumière et activité.
- docs/ui-proposals/dialogue-manhua-concept.png : grand portrait de Lian sans cadre, fond de la cour atténué, texte sur papier ivoire bordé d’encre, choix vermillon. Demande de génération : dialogue manhua chaleureux avec portrait de référence, texte français lisible et hiérarchie claire. Texte et choix illustratifs uniquement, pas de nouveaux embranchements implémentés.

L’intégration de cette composition demanderait un fond sans personnages ni UI, la variante restaurée alignée, les zones de déplacement et occultation correspondantes, puis poses d’activité des résidents. La maquette ne garantit pas ces animations et n’est pas un fond directement utilisable.

### Hub habité et dialogues — intégration du 19 novembre 2026

Direction validée intégrée dans la séquence visuelle : nouveau décor manhua de la cour avec variante restaurée alignée ; reconstruction en deux niveaux, vent et pétales conservés. Lian entretient sa lame près de la table sous le prunier, Shen tient un livre à côté de la table d’étude sur la terrasse (poses fixes), Jun répète son animation d’attaque aux mannequins. Échelle revue, ombres de contact et ordre d’affichage selon la profondeur. La recrue circule dans la cour et parle à Shen depuis le pied de la terrasse ; les marches ne sont pas une zone d’exploration supplémentaire.

HUD compact : calendrier/réserves, objectif, accès Techniques/Activités/Menu. Les boutons permanents des résidents sont remplacés par une interaction contextuelle à moins de 155 pixels, au clic ou avec E. Menu de pause et dialogues en scènes dédiées dans visual/hub : portraits détourés, fond assombri, texte ivoire et boutons vermillon, Kaushan Script pour les titres. Les petits personnages sont masqués pendant un dialogue. Les activités et récompenses existantes reprennent aussi les cadres papier et boutons partagés. Sauvegarde et règles inchangées.

Vérifications réussies : séquence complète, activités/sauvegarde/reconstruction, animations de combat, nouveau test_hub_composition.gd (proximité des trois résidents, invite contextuelle, dialogue/retour, menu, limite de déplacement, restauration). Captures tests/hub-composition.png, hub-dialogue.png, hub-menu.png et hub-rebuilt.png. Lian et Shen ont des poses d’activité illustrées fixes ; aucune animation de lecture ou de polissage complète n’est annoncée.

### Proposition de lieux illustrés — Shen et Lian

Deux concepts générés avec imagegen intégré : docs/ui-proposals/shen-pavillon-illustre.png et docs/ui-proposals/lian-jardin-illustre.png. Non intégrés au jeu. Personnages intégrés au dessin, perspective et éclairage communs, sans pixel art ni avatar mobile. Identités basées sur assets/portraits_manhua.png.

Prompts de direction : Shen assis à une table dans un pavillon modeste et usé, livre ouvert, lumière latérale chaude, encens, porte à gauche vers la cour ; Lian assise sous le prunier dans un jardin clos, entretien du sabre, lumière filtrée, banc de pierre et sortie par porte ronde à droite. Rendu manhua encré, corps et objets en contact cohérent, aucun HUD ni texte. Les scènes monolithiques proposées devront être préparées en couches avant toute animation indépendante ; elles ne constituent pas encore des assets animés.

### Jardin animé de Lian — intégré

19 novembre 2026 : l’illustration approuvée est copiée dans assets/garden/lian-garden.png et utilisée par visual/garden/scene.tscn. Le personnage fait partie de l’illustration ; aucun avatar mobile dans ce lieu. Accès « Jardin · Lian » depuis la cour, clic sur Lian pour parler et clic sur la porte ronde ou Retour pour sortir. Lian n’est plus doublée par un sprite dans la cour. Dialogue sur le jardin sans portrait superposé ; retour du deck vers le lieu d’origine.

Animations temps réel Godot : 42 pétales avec trajectoires/phases variées et opacité réduite devant le visage ; ondulation localisée des fleurs et feuillages périphériques par shader, protégeant personnage et architecture ; trois filaments de vapeur depuis la tasse avec diffusion progressive. Effets doux désactive vapeur/pétales et mouvement du feuillage. Aucun mouvement du corps ou des mains annoncé. L’illustration n’a pas été découpée en profondeur : premier passage d’ambiance par masques locaux et effets superposés, sans nouveau coût de génération.

Tests réussis : test_lian_garden.gd (différences de pixels rendus dans feuillage et vapeur à deux instants, arrêt des effets, interaction, dialogue, retour du deck, sortie et périodes inchangées), test_sequence.gd et test_visual_day.gd. Captures tests/lian-garden.png, tests/lian-garden-motion.png, tests/lian-garden-dialogue.png. Démarrage de test possible avec res://visual/preview.tscn -- --garden ; sauvegarde habituelle conservée.

### Variantes de dialogue de Lian — système préparé

Chaque appel dialogue peut recevoir un dictionnaire presentation avec pose et expression. Le jardin résout ces clés depuis visual/garden/lian_appearances.tres, avec repli vers pose/neutral puis l’image actuelle si une illustration manque. Deux couches d’image permettent un fondu de 0,22 s, sans réinitialiser vapeur ni pétales ; les changements rapides annulent le fondu précédent et Effets doux applique l’image immédiatement. Retour au jardin : pose d’entretien du sabre souriante.

Seule sword_care/smile possède actuellement une illustration. Les autres poses et expressions ne sont PAS encore dessinées. Lot proposé : écoute neutre, sourire amusé, réflexion sérieuse ; puis pose explicative, sans produire toutes les combinaisons. Les nouvelles images doivent garder 1536 × 1024, caméra et décor exactement alignés, tasse au même endroit, personnage hors des masques de vent. Si une pose dépasse ces zones, revoir les masques. Les répliques peuvent demander par exemple {"pose":"listening","expression":"thoughtful"}. Le système conserve l’image disponible tant que la variante n’existe pas.

Validation : test_lian_garden.gd réussi, comprenant variante manquante, transitions interrompues et mode effets doux avec textures de test. Aucun nouvel asset d’expression produit à ce stade.

### Expressions de Lian — illustrations créées et branchées

Quatre nouvelles variantes réelles dans assets/garden : listening-neutral.png, listening-amused.png, listening-thoughtful.png, explaining-smile.png. L’illustration souriante d’entretien du sabre reste la pose de repos. Génération par l’outil imagegen intégré depuis l’image approuvée, sans API externe payante.

Les dialogues existants sont segmentés en répliques : réflexion sur l’état de la secte, écoute de la recrue, sourire et explication avec geste de la main. Les conseils après apprentissage utilisent trois variantes. Texte et récompense existants conservés ; la période n’est consommée qu’après le bouton final d’entraînement. Variantes reliées au manifeste lian_appearances.tres.

Le shader conserve le décor original et limite les substitutions au visage ou à la zone du geste, pour éviter les différences de décor entre images générées. Fondu de 0,22 s avec modulation alpha, indépendant des pétales et de la vapeur ; changement immédiat avec Effets doux. Ces transitions entre illustrations ne constituent pas une animation de parole synchronisée.

Tests : test_lian_expressions.gd et test_lian_garden.gd réussis. Premier apprentissage, conseils répétés, fondus terminés/interrompus, repli d’une variante absente, effets doux et absence de coût de temps pendant les répliques vérifiés. Captures tests/lian-expression-0.png à lian-expression-3.png.

### Pavillon de Shen — intégré

L’illustration approuvée est intégrée dans assets/pavilion/shen-study.png et visual/pavilion/scene.tscn. Accès par le bâtiment central cliquable et le bouton Pavillon · Shen dans la cour. Shen est désormais dans cette scène illustrée, sans doublon de sprite à l’extérieur. Vapeur du thé, fumée d’encens superposée et poussière flottante animées ; arrêt des effets ajoutés avec Effets doux (la fumée peinte dans l’illustration reste visible). Pas de nouvelle animation du corps ni variante d’expression de Shen à ce stade.

Clic sur Shen pour dialoguer, sans portrait doublé ; retour au pavillon depuis le dialogue et le deck ; porte de gauche et bouton Retour pour la cour. Bouton Étudier · 1 période relié à l’action H du calendrier existant : progression du lien et cartes réellement acquises. Les règles d’indisponibilité, événements prioritaires et plafond de la séquence sont conservés. Visiter, parler et composer le deck sont gratuits. Étudier reste bloqué avant l’introduction de Lian. La sauvegarde existante est conservée.

Tests réussis : test_shen_pavilion.gd (accès par bâtiment, visibilité, effets doux, dialogue, retour du deck, sortie, temps inchangé en navigation, étude et H01, plafond), test_visual_day.gd, test_lian_garden.gd. Captures tests/shen-pavilion.png et tests/shen-pavilion-dialogue.png. Option de lancement --pavilion pour ouvrir directement ce lieu.

### Expressions de Shen et propositions chibi

Deux éditions d’expression générées depuis shen-study.png avec imagegen intégré : shen-kind.png (sourire bienveillant, yeux fermés) et shen-serious.png (regard concentré). Instructions : modifier uniquement les traits du visage, conserver identité, corps, livre, lumière, caméra et décor. Trois états avec l’original neutre. Intégrés aux trois répliques du conseil existant, avec fondu de 0,22 s et masque local du visage maintenant le décor stable. Effets doux supprime le fondu. Test_shen_pavilion.gd réussi, y compris succession serious/kind/neutral et périodes inchangées.

Planche de propositions docs/ui-proposals/chibi-study-options.png : trois séquences de quatre poses, recrue adulte chibi en tenue jade, assise à un bureau bas. Prompts : lecture attentive (lit, se penche, suit le texte, reprend sa posture), prise de notes (encre, écrit, consulte le livre, revient à l’encre), révélation (hésite, réfléchit, comprend, reprend la lecture). Génération imagegen intégrée ; planche illustrative, pas un atlas nettoyé ni une animation déjà jouable. Recommandation : prise de notes en boucle durant une courte transition d’étude, révélation ponctuelle si technique gagnée ; séquence passable, résolution de l’activité une seule fois. Choix du joueur attendu avant création des frames finales.

### Animation chibi d’étude — intégrée après validation

Atlas transparent assets/study/chibi-study.png généré avec imagegen intégré depuis la proposition approuvée : grille 4 × 2, quatre poses de prise de notes et quatre poses de révélation. Intégration dans visual/study/overlay.tscn : notes durant 2,8 s (deux boucles), révélation durant 1,6 s seulement si une technique a été réellement acquise, puis bilan et Continuer. Passer/Echap affiche immédiatement le résultat ; Effets doux présente directement le bilan statique. La tenue jade actuelle est fixe dans cet atlas.

Étudier dans le pavillon applique et sauvegarde l’action H une seule fois avant la présentation ; verrou contre les doubles clics, aucune récompense attribuée par les frames ou le bouton de sortie. Une interruption du jeu ne rejoue donc pas la transaction. Au plafond de la séquence, Continuer affiche le bilan des journées.

Test test_study_chibi.gd réussi : vrais changements de frames, révélation, saut, double déclenchement, temps unique et effets doux. Captures study-chibi-notes.png, study-chibi-revelation.png et study-chibi-result.png. Aucun achat ni appel à une API externe payante.

### Animations chibi de Jun et Lian — intégrées

Atlas transparent assets/study/chibi-activities.png : quatre poses de pratique au sabre de bois avec Jun (garde, préparation, frappe/parade, retour), quatre poses de thé avec Lian (servir, lever la tasse, boire/échanger, reposer). Même recrue en jade et rendu illustré que l’étude. Génération imagegen intégrée, prompt archivé dans assets/study/ACTIVITIES.md ; aucun service externe payant.

Deux boucles de 1,6 s par activité, bilan affichant le rang et les techniques réellement acquises. Le panneau partagé conserve Passer/Echap, Continuer et Effets doux. Transactions et sauvegarde avant animation, une seule période, double déclenchement bloqué. Retour à la cour pour Jun, au jardin pour Lian, au bilan si la séquence est terminée.

Accès : dialogue de Jun → Répéter les mouvements · 1 période ; jardin → Partager le thé · 1 période ; menu Activités → les trois résidents déclenchent maintenant leur animation. L’activité L existante est présentée comme un échange de conseils autour du thé ; coûts, rangs et récompenses inchangés. L’apprentissage initial de Lian et les duels de cartes restent leurs séquences propres. Disponibilités, rangs et événements prioritaires du calendrier conservés.

Tests test_resident_chibi.gd et test_study_chibi.gd réussis : acquisitions J01/L02/J02, blocages, double clic, passage, retour, effets doux et plafond. Captures en moteur tests/chibi-jun-training.png et tests/chibi-lian-tea.png vérifiées visuellement. Retour utilisateur encore attendu.

### Carnet des activités et bilan quotidien — papier et encre

Écrans natifs visual/activities/menu.tscn et entry.tscn, thème papier ivoire, pinceau vermillon et titres Kaushan Script. Six entrées statiques éditables dans Godot : Lian/Jun/Shen à gauche avec portraits, travail/restauration/repos à droite. Coûts et gains lus dans le calendrier et les constantes d’équilibrage ; causes de blocage visibles, boutons désactivés. Écran du serment harmonisé avec les mêmes éléments et descriptions réelles des cartes exclusives.

Contrat d’interaction : comparer les activités disponibles, lire leur coût et la prochaine technique, puis engager une période. Visites et consultation du bilan gratuites. Souris et navigation native des boutons, focus visible, Échap pour revenir à la cour. Ni nouvelles ressources ni nouvelles règles de progression.

Bilan accessible depuis le carnet et automatiquement après une activité du soir (après Continuer pour les chibis). Journal matin/après-midi/soir tiré de calendar.history ; première leçon de Lian identifiée correctement. État actuel : réserves, pavillon, collection, taille du deck et liens. Journée en cours distinguée de journée achevée ; fin du jour 3 clairement indiquée comme fin de la séquence, avec accès au deck et à la cour. Sauvegarde et calendrier conservés. Option --activities pour lancer directement le carnet dans l’état de la sauvegarde.

Validation : test_visual_day.gd, test_activities_menu.gd, test_resident_chibi.gd et test_study_chibi.gd réussis. Vérifications en moteur : menu, bilan du jour 2, bilan final et serment ; tests des gains de travail avec cuisine, blocages, consultation gratuite, choix exclusif, transition chibi et plafond. Retour utilisateur attendu.

### Choix du serment illustré

Deux illustrations de compétences ajoutées directement aux choix E01/E02, avec effets et coût de combat conservés. Source partagée avec le deck ; E02 emploie maintenant le visuel de garde dans toutes les vues de carte pour distinguer le serment protecteur du serment offensif. Aucun changement de règle.

Vignette chibi propre à M02 : Shen, Lian, Jun et la recrue réunis autour du serment. Asset assets/events/oath-chibi.png, prompt dans assets/events/README.md, génération imagegen intégrée sans API payante. Image fixe. Ce premier événement sert de direction pour les futures vignettes ; les événements de la campagne non encore intégrés n’ont pas encore leurs illustrations.

Test test_activities_menu.gd réussi : images présentes et distinctes, cohérence avec le deck, choix exclusif et coût d’activité inchangés. Capture tests/activities-oath.png vérifiée en moteur.

### Parcours de test séparé — prêt pour retour joueur

Lanceurs ParcoursTest.cmd / ParcoursTest.ps1 : dossier APPDATA propre tools/parcours-test-user, indépendant de tools/play-user. Départ neuf du prototype au jour 2 matin, stage 0, avant Lian ; titre de fenêtre Parcours de test. Les relances reprennent uniquement la sauvegarde de test. Aucun reset ni écriture de la partie principale. Consignes et chemin conseillé dans docs/PARCOURS_TEST.md. Test humain des deux journées désormais à réaliser ; étape d’équilibrage non déclarée terminée.

### Retour joueur — duel tutoriel et intentions

Duel gagné facilement ; le joueur confirme son rôle d’apprentissage de l’interface. Difficulté du premier duel conservée, sans conclure à l’équilibrage de la campagne. Demande appliquée : suppression du panneau rectangulaire d’intention, remplacé par épée + dégâts et/ou bouclier + garde au-dessus de l’adversaire. Valeurs issues de battle.intent(), chiffres lisibles avec contour, icônes vectorielles CC0, infobulles explicatives au survol. Position suit Jun pendant ses mouvements ; attaque et garde simultanées prises en charge.

Test de combat étendu : attaque seule, garde seule, intention mixte, valeurs du modèle et suivi de position. Captures en moteur vérifiées. Retours sur cartes, ressources et choix d’activité encore attendus.

### Duels répétés de Jun — difficulté progressive

Demande joueur : rendre le duel légèrement plus difficile à chaque répétition. Premier duel conservé comme tutoriel (30 PV, attaques 6/9, garde 5). Chaque duel terminé, victoire ou défaite, ajoute un palier au suivant : +4 PV, +1 dégât sur les tours offensifs, +1 garde sur le tour défensif. Plafond après quatre paliers : 46 PV, attaques 10/13, garde 9. Quitter ou interrompre un duel ne fait pas progresser le compteur. Duels libres toujours sans coût de période ni réserve. Palier indiqué dans le HUD ; annonce au résultat.

Compteur completed_duels dans la sauvegarde visuelle, réinitialisé avec Recommencer. Anciennes sauvegardes compatibles : un duel déjà terminé inféré au stage 3, faute d’historique des anciens duels libres. Aucun autre adversaire ni profil du laboratoire modifié par défaut. Tests test_jun_progression.gd et test_visual_day.gd réussis : valeurs, plafond, intentions, abandon, défaite, double résolution, persistance, migration et reset. Valeurs de départ à confirmer par test humain des répétitions.

## Audit des duels et préparation des jours suivants — 19 novembre 2026

### Résultat de la vérification

Exécutés dans tools/regression-user, sans charger ni écrire les sauvegardes de jeu principale ou du parcours utilisateur :

- tests/test_jun_progression.gd : PASS. Tutoriel inchangé, quatre paliers, plafond, intentions, abandon, victoire/défaite, protection contre une double résolution, sauvegarde du compteur, migration des anciennes sauvegardes et réinitialisation.
- tests/audit_jun_saves.gd : PASS. 1 000 duels terminés ; reprise par la même fonction load_progress utilisée au démarrage, restitution du deck/calendrier/paramètres/compteur, interruption avant résolution, lancement au bon palier, abandon sans hausse, JSON cassé et compteur négatif récupérés depuis .bak, indépendance de deux emplacements.
- tests/test_visual_day.gd : PASS. Calendrier, reconstruction, serment exclusif, secours de sauvegarde, deck et absence de gains répétés par les duels libres.

La lecture de sauvegarde a été extraite dans load_progress() pour que le test appelle réellement le chemin utilisé au démarrage. Pas de changement des valeurs de combat ni du calendrier pendant cet audit. Les tests emploient des fichiers temporaires propres au répertoire de régression.

Résultats reproductibles : tests/jun_audit_results.json. Deux decks accessibles au début (départ, puis départ avec L01), 100 graines identiques par palier et par deck, agent heuristique à une étape. Ce n’est pas une mesure du niveau d’un joueur humain.

| Palier | PV de Jun | Attaques / garde | Tours moyens, deck avec L01 | PV restants moyens / 45 |
|---|---:|---|---:|---:|
| Tutoriel | 30 | 6 et 9 / 5 | 3,18 | 41,96 |
| 1 | 34 | 7 et 10 / 6 | 3,77 | 40,45 |
| 2 | 38 | 8 et 11 / 7 | 4,49 | 39,52 |
| 3 | 42 | 9 et 12 / 8 | 4,83 | 37,09 |
| 4, plafond | 46 | 10 et 13 / 9 | 5,63 | 35,28 |

L’agent gagne 100 % des 1 000 simulations, y compris avec le deck de départ. La pression augmente sans blocage observé, mais surtout par l’allongement du duel. Décision : garder cette progression douce pour l’entraînement ; ne pas augmenter silencieusement la difficulté après le retour positif sur le tutoriel. Le test humain des paliers reste nécessaire. Après une défaite, le palier suivant augmente également selon l’implémentation actuelle : observer si cela crée une spirale frustrante et, dans ce cas, proposer une hausse seulement après victoire.

Limites : le compteur des anciens duels libres n’existait pas ; une ancienne partie au stage 3 est reprise avec un duel terminé, pas avec un historique reconstitué. Un combat interrompu revient avant le duel avec un nouveau tirage ; reprise exacte du générateur aléatoire non implémentée. Les points de préparation/final et les trois sauvegardes manuelles de campagne ne sont pas encore dans l’interface visuelle. La récupération d’un fichier corrompu testée ici ne constitue pas une validation de toute corruption possible.

### Prochain bloc à produire : jours 4 à 6

Objectif : passer du tutoriel à une décision de préparation qui a une conséquence dans un combat extérieur. Ne pas ajouter de nouvelles cartes au total validé de 30, ni de nouveau résident. Ce tableau décrit une proposition de contenu ; les activités facultatives ne deviennent pas un itinéraire obligatoire.

| Journée | Déroulement et choix disponibles | Conséquences existantes à intégrer | Présentation à produire |
|---|---|---|---|
| J4 — Le marchand de passage | Marchand dans la cour toute la journée. S01 facultatif : nouvelles, puis achat facultatif. S06 : exercice conseillé par Jun ou Shen. Relations, travail et chantiers restent disponibles. | S01 donne E03 ; achat facultatif à 3 réserves dans la même période. S06 donne +1 réserve et un aperçu de deck, aucune nouvelle carte. Rang 2 des liens accessible si rang 1 acquis. | Un portrait du marchand (visiteur déjà budgété), une vignette chibi S01, une vignette S06 avec variante de conseiller ; choix d’équipement montrant image, coût et effet. |
| J5 — Préparer sa sortie | Aucune scène principale imposée. Arbitrer entre un chantier, une relation, du travail ou les secondaires encore disponibles. S03 à la cuisine dès J3 reste accessible ; pas de rendez-vous manqué définitif. | S03 : O01 et +1 réserve. Cuisine niveau 1 : travail à +3 réserves. Atelier niveau 1 : achats sans attendre le marchand. Pavillon : préparation de S02 après M03. | Cour réutilisée, zones cuisine/atelier cliquables, états de reconstruction cohérents, vignette chibi d’intendance S03. Pas de nouvel intérieur. |
| J6 — Incident sur le sentier | M03 obligatoire le matin ; les deux autres périodes restent libres. Après résolution, sentier ouvert le jour ; rang 3 des liens accessible si rang 2 acquis. S04 proposé si au moins un niveau de chantier existe. | M03 : combat extérieur, +1 réserve en cas de victoire. Défaite non bloquante. S04 : E05 et +1 réserve, sans niveau de bâtiment gratuit. S02/S05 deviennent possibles selon leurs conditions. | Un fond illustré du sentier et le combat commun ; vignette chibi M03 et S04. Intentions par icônes conservées. Bilan de J6 montrant les conséquences réelles. |

Rythme : neuf périodes, dont une principale imposée, huit libres. Ne pas forcer toutes les propositions du tableau. Marchand revu J8/J12 si S01 ignoré ; relations et secondaires restent accessibles selon les règles. Pas de carte indispensable enfermée dans un événement facultatif perdu.

Exemple réalisable à contrôler à l’intégration, pas chemin imposé : J4 S01 sans achat / travail / atelier 1 ; J5 relation / S03 / pavillon 1 ; J6 M03 / relation ou travail / S04. Avec 0 réserve au début, le chantier de J4 doit pouvoir être repoussé : aucun achat obligatoire, travail et repos toujours disponibles hors événement principal. Le chemin exact dépend des choix de J2–J3 ; ne pas réinitialiser les acquis pour le rendre possible.

### Ordre de réalisation du bloc

1. **Fondations de campagne avant de lever le plafond.** Distinguer la séquence J2–J3 de la campagne ; centraliser sa limite actuellement dispersée (contrôleur, scènes des résidents, animations et menus). Prévoir une migration explicite : le slot 9 marque le matin de J4, sans consommation supplémentaire. Le lecteur de sauvegarde actuel refuse les slots supérieurs à 9 : l’étendre et le tester avec la campagne, sans simplement supprimer la limite dans l’UI. Conserver la partie de test séparée.
2. **J4 jouable.** Ajouter les données et la présentation de S01/S06, le marchand et l’acquisition d’équipement. Le laboratoire ne résout pas encore l’achat facultatif inclus dans S01 : implémenter la transaction une seule fois (une période, débit seulement si achat accepté). Tester refus, fonds insuffisants, objet déjà possédé et reprise. Équipement et objet : faire respecter les emplacements et le remplacement dans les douze cartes.
3. **J5 et les chantiers.** Brancher cuisine et atelier sur leurs règles existantes, leurs changements visuels et le carnet. Ajouter S03 sans exiger un niveau de cuisine non prévu par les règles. Vérifier coûts 3 puis 4, travail 2 puis 3, remise atelier niveau 2 et sauvegarde.
4. **J6 et premier combat extérieur.** Intégrer M03 comme événement dédié : ne pas utiliser le résultat de duel libre de Jun. Une résolution = une période ; victoire, défaite et reprise avant activité testées. Débloquer les rangs 3 et le sentier seulement après résolution, pas après simple visite.
5. **Partie de contrôle J2–J6.** Tester au moins un parcours orienté liens et un orienté reconstruction/équipement, dont un avec peu de réserves. Aucune dépense double, aucun verrou irréversible par manque d’argent, sauvegarde reprise à chaque transition. Faire ensuite un test humain avant de produire J7–J9.

### Suite de la campagne, à détailler après J4–J6

| Bloc | Contenu prévu dans le périmètre existant | Critère avant passage au bloc suivant |
|---|---|---|
| J7 | Nouvelle direction : premier boss, affrontement de trois disciples contre trois pour le territoire face à une école souhaitant s'installer sur place. Voir la conception du tournoi ci-dessous. S02/S05 restent à répartir dans les périodes libres. | Prototyper le combat d'équipe, la lisibilité des intentions/cibles et la reprise après défaite avant intégration à la campagne. |
| J8 | Arrivée de l'espionne, retour du marchand, poursuite des liens et du sentier. | Arrivée unique, aucune collision avec le marchand ; conséquences du tournoi connues. |
| J9 | M04 : défi intermédiaire contre Jun, E07 si victoire, défaite non bloquante. Après-midi et soir libres. | Défi calibré sur les cartes acquises à J9. Le profil M04 reste distinct des duels répétables : ne pas cumuler automatiquement leurs paliers avec ses statistiques. |
| J10–J12 | Résolution des rangs 4 ; romance de Lian facultative le soir après intérêt explicite, version amicale équivalente en puissance ; chantiers finaux ; dernière visite du marchand J12. | Aucun avantage indispensable réservé à la romance ; annonces claires des échéances et états de bâtiments lisibles. |
| J13 | M05 : bilan de préparation et +1 réserve, point de sauvegarde distinct ; deux périodes libres. | Sauvegarde de préparation durable, avertissement sur le final, édition du deck valide. |
| J14 | Matin/après-midi libres ; M06 obligatoire le soir, sauvegarde préalable conservée en cas de défaite ; inspection et épilogue. | Reprise avant épreuve sans perte, préparation du deck possible ; victoire nécessaire à l’épilogue, variations selon liens et chantiers. |

### Maîtrise du périmètre et décisions à préserver

- 14 journées / 42 périodes, 6 événements principaux + 12 scènes de liens + 6 secondaires = 24, 30 cartes. Les vignettes illustrent ces événements ; elles n’en créent pas de nouveaux. Une illustration chibi par événement écrit, réutilisable pour les variantes, avant toute animation supplémentaire.
- La séquence actuelle commence J2 et considère M01 déjà passé. L’arrivée/personnalisation de J1 reste à intégrer avant une campagne complète ; le test de deux jours n’est pas présenté comme le début finalisé de l’histoire.
- Le jardin de Lian, ajouté et validé pendant la direction artistique, dépasse déjà la proposition initiale de trois scènes lorsqu’on ajoute le sentier. Réutiliser cour, jardin et pavillon ; le sentier est la seule nouvelle scène prévue pour ce bloc. Cuisine et atelier restent des zones de cour, pas de nouveaux intérieurs. Le périmètre artistique doit refléter cet ajout déjà accepté plutôt que prétendre rester à trois décors.
- Les duels libres gratuits du prototype servent à tester les decks. Leur articulation avec l’activité de campagne « entraînement, une période » devra être explicitée lors de la migration : pas de récompenses gratuites répétables, pas de quota de combats imposé. La cible de 10–12 rencontres concerne un parcours, pas une limite de rejouabilité.
- Durée de 3–5 heures encore cible, pas durée mesurée. Mesurer le bloc témoin avant d’augmenter le volume. Aucun achat ni nouvelle génération d’assets engagés pour cette planification.

**État à la clôture de cette tâche : vérifications techniques réussies ; suite préparée et sauvegardée ; J4–J14 pas encore intégrés dans la séquence visuelle. Étape 4 non clôturée sur ces seuls tests.**

## Jour 4 intégré — marchand et équipement

Le plafond central est désormais Progress.END_SLOT = 12 (fin du jour 4). Une sauvegarde au slot 9 reprend au matin de J4 sans consommer de période ni réinitialiser le calendrier. Cour, activités, scènes de résidents, chibis et bilan utilisent ce plafond commun. Le marchand est accessible depuis la cour et le carnet durant J4 ; J5 reste fermé. S06, cuisine et atelier visuels restent pour un lot ultérieur.

Échoppe papier/encre, quatre cartes illustrées Q01–Q04, prix, blocages, sélection puis achat explicite. Première rencontre S01 : E03 offerte, achat facultatif dans la même période ; Échanger sans achat fonctionne sans réserves. Après S01, chaque achat supplémentaire coûte une période ; un équipement déjà possédé n’est pas rachetable. Consulter, sortir et équiper sont gratuits. Scène native visual/merchant/menu.tscn ; vignette assets/events/merchant-chibi.png, prompt dans MERCHANT.md. Aucun appel externe payant.

Les achats rejoignent la collection, pas automatiquement le deck. Depuis Techniques, choisir la carte à remplacer puis l’équipement ; une arme et un talisman maximum. Une nouvelle arme remplace l’ancienne si ce slot est occupé, avec aperçu du remplacement réel. Remplacer un équipement par une technique le déséquipe sans le perdre. Le même calcul valide le bouton et la transaction, en conservant exactement douze cartes. Infrastructure également compatible avec la sacoche, sans nouvel objet ajouté dans ce lot.

Sauvegarde v3 dans le même chemin que précédemment ; lecteur accepte v2 et v3. Au premier enregistrement sur une v2, copie permanente .before-day4 avant écriture, distincte du .bak tournant. Compteur de Jun, deck, collection, réserves, liens, constructions et paramètres conservés. Migration testée sur fixtures et copies des deux sauvegardes réelles (partie principale et parcours de test) ; les originaux sont restés identiques pendant les tests. Aucun achat ou passage de période effectué sur la partie utilisateur.

Vérifications réussies : test_day4_merchant.gd (migration/archive, coût/période, double clic, refus sans argent, acquisition, remplacement/déséquipement, reprise, plafond, vraie sauvegarde sur copie), test_visual_day.gd, test_activities_menu.gd, test_jun_progression.gd, test_resident_chibi.gd, test_shen_pavilion.gd. Régression du laboratoire : 43 927 vérifications, zéro échec (tests/day4-regression.log). Compatibilité préservée pour les anciens appels transmettant le choix de serment à toutes les activités. Captures day4-merchant.png, day4-equipped.png et day4-result.png vérifiées dans Godot ; débordement de texte du cadeau corrigé. Validation humaine de J4 encore attendue.


### Fiabilité et lancement — 19 novembre 2026

Lot terminé après audit. Correction de la conclusion initiale sur J02 : les règles approuvées de l’étape 3 indiquent qu’Exposé affecte l’ennemi, pas la recrue. Le calcul était conforme. Le texte précise désormais « Ennemi Exposé : il reçoit +50 % de dégâts ce tour » et l’état apparaît dans le panneau ennemi. L’effet expire à la fin du tour ; aucun changement d’équilibrage n’a été introduit.

Sauvegardes : validation du fichier temporaire avant remplacement ; rotation de la copie `.bak` seulement si le fichier principal est valide. Après récupération depuis `.bak`, un principal corrompu ne détruit plus la copie de secours. Les versions v2/v3, le nom de fichier et les deux profils restent compatibles. Les tests couvrent deux corruptions successives, un JSON lisible mais invalide, un principal absent et le rejet d’une nouvelle progression invalide.

Préservation : copie datée des sauvegardes normale et parcours dans `tools/save-backups/20261119-161516`, avec manifeste SHA-256. Tests de reprise sur copies isolées ; fichiers originaux conservés. Les profils `tools/*-user/`, les copies de sécurité et les exports sont exclus de Git.

Historique : premier commit local `a6c71ac` conservant l’état jouable du jour 4 avant correction. Les corrections et ce bilan font l’objet du commit suivant. Le dépôt inclut code, scènes, assets, documentation et tests ; aucun envoi distant n’a été réalisé. Cet historique local ne protège pas d’une perte du disque.

Lancement : `project.godot` pointe sur `visual/preview.tscn`. `Jouer.cmd` et `SequenceVisuelle.cmd` partagent le même lanceur et la même sauvegarde normale ; `ParcoursTest.cmd` conserve son profil séparé. F5 lance la version actuelle mais utilise le dossier utilisateur standard de l’éditeur ; le README précise cette distinction. L’ancien `main.tscn` reste disponible explicitement avec F6.

Validation : 31 contrôles ciblés, zéro échec ; suites marchand J4, interface de combat et progression de Jun réussies ; laboratoire : 43 927 contrôles, zéro échec. Démarrage de la scène principale sans argument de scène vérifié en mode headless pendant 60 frames, sans erreur. Les contrôles automatisés ne remplacent pas une nouvelle validation visuelle humaine.

Suite : enrichissement des dialogues et du son, puis intégration J5–J6/S06 selon le périmètre déjà validé. Aucun contenu supplémentaire ni changement de difficulté dans ce lot.


### Voies des cartes — 19 novembre 2026

Intégré : métadonnée explicite de voie sur les trente cartes ; orthodoxe pour les bases et enseignements de Lian/Jun/Shen, non orthodoxe pour le marchand, les quatre équipements courants et les pratiques extérieures. La troisième voie, démoniaque, est définie mais aucune carte démoniaque n’est distribuée dans J2–J4. Répartition : 22 orthodoxes, 8 non orthodoxes. Aucun changement d’effet, de prix, de coût de période, de limite de deck ou de sauvegarde.

Affichage : bandeau lisible sur les cartes du deck, de la collection, du marchand et de la main de combat ; voie dans la fiche détaillée, les descriptions et les récompenses du serment. Le marchand explique l’origine non orthodoxe de ses techniques. M02 et S01 constituent les premiers événements d’acquisition des deux voies présentes.

Reporté et documenté dans ETAPE_03_REGLES_DU_JEU.md : événement unique du feuillet scellé, talisman rare démoniaque, choix de refus, conditions d’acquisition et contrôles de sauvegarde. Les noms et mécanismes proposés restent à concevoir et équilibrer ; aucune augmentation implicite du périmètre à trente cartes. Pas de corruption ni de restriction de mélange des voies pour l’instant.

Validation : test_card_ways.gd, 101 contrôles réussis sur le catalogue, les sources, l’acquisition chez le marchand et l’affichage deck/combat. Suites marchand J4, activités, combat et fiabilité relancées. Les identifiants sauvegardés restent inchangés : aucune migration nécessaire.

Captures en moteur du deck, du marchand et du combat vérifiées : bandeaux lisibles dans le style papier/encre. Sauvegardes personnelles comparées au manifeste SHA-256 : inchangées.


### Identités mécaniques des voies — direction utilisateur du 19 novembre 2026

Direction enregistrée dans ETAPE_03_REGLES_DU_JEU.md : orthodoxe simple, accumulation, buffs, gros decks, pioche, main élargie et effets persistants ; non orthodoxe centrée sur affaiblissements, poison, contrôle des actions et intentions, protection d’un tour ; démoniaque centrée sur vol de vie, affaiblissements, combustion, invocation, prévention de la mort, scaling PV perdus, dégâts automatiques et qi maximal accru pour le combat.

Ce lot est une mise à jour de conception, pas une implémentation des effets. La classification et l’affichage des voies restent jouables ; deck de 12, main maximale de 10 et règles de qi actuelles restent inchangés jusqu’au prototype dédié. La nouvelle direction impose notamment de réviser la taille fixe du deck. La plage 12–20, le sens précis de « brûler », le calcul des PV perdus et les modalités du qi maximal sont documentés comme propositions, non comme règles déjà approuvées.

Ordre recommandé pour le prochain chantier de combat : socle d’états/effets persistants → petit lot orthodoxe → contrôle non orthodoxe → sacrifice/vol de vie démoniaques → invocation et prévention de mort → acquisitions dans la campagne. Ce chantier nécessite de rééquilibrer les cartes existantes et les decks mixtes avant d’étendre le contenu. Respecter le budget de trente cartes ; aucun nouveau système de corruption ou de factions ajouté implicitement.

Aucun fichier de gameplay ni aucune sauvegarde modifié lors de cette formalisation. La suite narrative J5–J6 demeure au plan ; cette évolution du combat est un lot distinct à réaliser progressivement.


### Premier lot orthodoxe et decks libres — 19 novembre 2026

Intégré et testé : taille choisie de 12 à 20 cartes sans remplissage obligatoire ; boutons Ajouter/Retirer en plus du remplacement ; compteur dynamique ; validation des cartes acquises, copies et équipements. Le laboratoire suit aussi la nouvelle plage. Les cartes persistantes disposent d’une zone active, d’effets au début du tour suivant et d’une remise à zéro à chaque combat.

Quatre cartes réutilisées : B04 dégâts selon taille initiale ; B06 pioche renforcée à 16 ; B07 garde puis main +2 et pioche +1/tour ; H02 garde puis Force +1/tour. Les trois cartes de base sont déjà accessibles ; H02 conserve sa source Shen rang 2. Aucun déblocage gratuit, nouvelle carte ou changement de progression. Atteindre 20 cartes dépend de la collection et des limites de copies : le jeu n’ajoute pas de cartes de remplissage.

Interface : effets abrégés sur les cartes, explications complètes dans la fiche et au survol, Force/main/pioche/persistantes visibles en combat. Sauvegardes v2/v3 lisibles, nouvelles écritures v4 et archive `.before-orthodox`. Le test des profils réels s’effectue en lecture et sur copies isolées ; aucune sauvegarde personnelle remplacée pendant le développement.

Validation : 642 contrôles dédiés ; 39 454 contrôles laboratoire, zéro échec ; suites marchand J4, combat, voies et fiabilité réussies. Captures orthodox-deck.png et orthodox-combat.png utilisées pour contrôler la lisibilité. Trois tailles, même noyau de techniques avancées, 100 graines chacune contre inspecteur/3 réparations : 100 % de victoires pour 12/16/20, respectivement 6,66/5,61/5,58 tours moyens. Lot jouable de test, équilibrage non final : varier les profils ennemis et recueillir le retour humain avant validation.

Arbre du personnage futur : enregistrer petit deck/gros deck comme axe de spécialisation. Le petit deck profite déjà de sa régularité ; prévoir des compétences et talents conditionnels qui rendent le gros deck intéressant, sans pénaliser arbitrairement les petites listes. Aucun arbre ajouté maintenant. Les règles détaillent les pistes et les interactions à tester. Suite du chantier combat : test utilisateur du lot orthodoxe, calibration, puis poison/contrôle non orthodoxes ; J5–J6 restent au plan narratif.


Retour ergonomique du joueur : ajout/retrait jugé peu pratique. Proposition à valider avant refonte : collection et deck visibles côte à côte, bouton + sur les cartes disponibles et − sur les cartes équipées, compteur 12–20 explicite, distinction nette entre sélection (consulter) et modification. Idéalement édition en brouillon avec Enregistrer/Annuler, permettant de passer temporairement sous 12 pendant la composition sans altérer le deck sauvegardé ; enregistrement seulement si légal. Les équipements occupés demandent un échange explicite. Variante économique : garder les onglets mais ajouter +/− directement sur les cartes. Le glisser-déposer peut compléter ces actions, pas les remplacer. Cette refonte n’est pas encore implémentée.


### Menu de deck à deux panneaux — 19 novembre 2026

Maquette épurée validée intégrée dans Godot : fond sombre discret, collection à gauche et deck regroupé par technique à droite. Pas de grand titre supérieur ni de phrase explicative dans le pied de page. Filtres de voies, compteurs de copies, boutons +/− ronds, nombre total, capacité 20 et coût moyen. Les illustrations existantes sont réutilisées. Survol pour la description ; clic sur une carte ou une ligne pour ouvrir une fiche lisible.

Composition en brouillon : ajout/retrait sans toucher au calendrier, au deck actif ni au fichier. Le brouillon peut descendre sous 12 cartes ; Enregistrer reste désactivé tant que le deck est invalide. Annuler ou Échap abandonne le brouillon et revient au lieu précédent. Enregistrer applique deck et équipements, sauvegarde une seule fois et revient au jeu. Si l’écriture échoue, le deck actif et le stade du tutoriel sont restaurés ; le brouillon reste disponible pour réessayer.

Copies, collection, taille maximale et emplacements restent contrôlés. Pour échanger un équipement, retirer l’ancien avec − puis ajouter le nouveau avec +. Les cartes non acquises ne sont pas affichées. Filtre démoniaque vide explicite tant qu’aucune carte de cette voie n’est acquise. La présence de L01 dans le deck enregistré valide toujours le tutoriel.

Validation : 20 contrôles dédiés (brouillon, annulation, fichier inchangé, validation, double clic, équipement, erreur d’écriture, filtres et plafond) ; suites journée visuelle, marchand J4, voies et orthodoxe réussies. Capture deck-draft-menu.png vérifiée dans le moteur. Les anciens tests d’interface ont été adaptés au nouveau parcours. Sauvegardes utilisateur préservées ; ouverture demandée sur le profil normal, directement dans le menu de deck.


### Rapprochement visuel avec la maquette validée

Retour utilisateur : illustrations, typographie et boutons de la première intégration moins convaincants que la maquette. Ajout de douze illustrations manhua de techniques, via atlas partagé entre collection, combat et marchand. Les autres cartes conservent temporairement leurs anciennes images. Cartes de collection agrandies, titres Kaushan Script à 22 px ; filtres sobres et lisibles ; retrait en cercle rouge fin, ajout en cercle plein, Annuler sur papier encadré. Le fond reste discret, sans titre supérieur ni phrase inférieure.

Validation : nouvelle capture en moteur deck-draft-menu.png, test du brouillon réussi (20 contrôles). Aucune modification de règles, de cartes possédées ou de sauvegardes. Planche, correspondance des cartes et prompt consignés dans assets/CARD_MANHUA_ART.md.

### Proportions du menu de deck — 19 novembre 2026

Cartes de collection ajustées à 232 × 272, illustrations agrandies et zone visible cadrée sur deux rangées de trois cartes sans bande de troisième rangée au repos. Boutons + inclus dans le cadre, lignes du deck compactées à 44 px avec commandes − de 34 px : neuf techniques visibles. Les effets longs restent consultables intégralement au survol/clic ; aperçu limité à deux lignes dans la collection. Tests de géométrie ajoutés : six cartes et leurs boutons intégralement contenus, neuvième ligne visible. 34 contrôles réussis, capture tests/deck-draft-menu.png produite dans Godot. Aucun changement de règles ou de sauvegarde.


## Deux voies de reconstruction et initiation démoniaque

Décision validée par le joueur le 19 novembre 2026. Deux voies de reconstruction sont retenues pour le jeu : **orthodoxe** et **démoniaque**. Cette décision fait évoluer le périmètre narratif et artistique antérieur ; elle ne signifie pas que ces branches sont déjà intégrées. La troisième voie de reconstruction, non orthodoxe, est reportée. Les cartes non orthodoxes, le marchand et les decks mixtes restent présents.

### Reconstruction et identité de la secte

La reconstruction matérielle et l’orientation de la secte sont deux progressions distinctes. Les travaux réalisés restent acquis en cas de basculement ; la voie démoniaque transforme la secte reconstruite, elle ne remplace pas les chantiers par leur abandon.

| Voie | Décors et bâtiments | Disciples |
|---|---|---|
| Orthodoxe | Secte restaurée, neuve et resplendissante : pierre claire, bois soigné, bannières renouvelées, prunier florissant. | Tenues renouvelées et cohérentes avec la secte orthodoxe, signes de rang et expressions de fierté. |
| Démoniaque | Transformation radicale de l’identité visuelle : ornements sombres, sceaux, lanternes et végétation inquiétantes, en réutilisant la structure des lieux. | Tenues et portraits démoniaques ; attitudes et répliques tenant compte de la conversion volontaire ou forcée. |

Cible artistique de départ : trois états de référence par lieu principal — déchu, restauré orthodoxe, transformé démoniaque. Les étapes intermédiaires de chantier réutilisent autant que possible les couches et effets existants. Priorité à la cour, au jardin de Lian et au pavillon de Shen, puis aux tenues et portraits de Lian, Jun et Shen. Inventorier ensuite les adaptations nécessaires aux animations, chibis et scènes illustrées pour éviter des apparences contradictoires.

L’orientation démoniaque de la secte est choisie lors d’un événement explicite, après découverte des intentions de l’initiatrice. Posséder ou jouer une carte démoniaque, accepter un premier cadeau ou composer un deck mixte ne bascule pas automatiquement toute la secte.

### Nouvelle PNJ initiatrice

Une experte itinérante se présente comme une pratiquante non orthodoxe. Elle cherche en réalité à corrompre le héros progressivement, en gagnant sa confiance et en présentant la puissance interdite comme un moyen de sauver la secte. Son nom, son apparence, les jours de rencontre et les valeurs des récompenses restent à concevoir.

| Étape | Rencontre et condition | Récompense ou conséquence |
|---|---|---|
| 1. Le défi | Elle engage initialement un combat contre le héros. Une victoire l’impressionne et débloque sa proposition d’enseignement. | Une défaite laisse une possibilité de revanche ; elle ne supprime pas définitivement cette voie. |
| 2. Le service rendu | Elle propose une première aide concrète, sans révéler son objectif. | Équipement réellement non orthodoxe. |
| 3. Les leçons | Elle enseigne et remet progressivement en cause les interdits de la secte. | Technique non orthodoxe. |
| 4. Le cadeau dangereux | Elle propose un pouvoir plus inquiétant et en minimise les risques dans le dialogue. | Équipement démoniaque, dont la voie et les effets sont affichés avant acceptation. |
| 5. La révélation | Son origine et son intention de corrompre le héros deviennent explicites. | Choix d’accepter ou de refuser son enseignement démoniaque ; accès aux techniques démoniaques si accepté. Le choix d’orientation de la secte doit être explicite. |

Accepter ses premières récompenses ne verrouille pas la route. Refuser un équipement ou la révélation ne confisque pas les récompenses antérieures. La tromperie appartient au récit ; l’interface ne masque pas la nature ni les effets d’une carte démoniaque. Cible de production : une PNJ récurrente, cinq rencontres courtes, quatre récompenses et un décor réutilisé, sans lui ajouter implicitement quatre rangs sociaux ou une romance.

### Conversion des disciples

Sur la voie démoniaque, Lian, Jun et Shen peuvent être convertis individuellement par deux approches :

- **Par amitié et confiance** : un lien suffisamment fort ouvre une scène de persuasion. Le disciple accepte volontairement pour une raison cohérente avec son caractère. Seuils de relation et arguments propres à chacun restent à écrire.
- **Par la force** : après son opposition, le héros peut choisir un défi. La victoire permet sa conversion forcée ; elle ne donne pas automatiquement de l’amitié ni les bénéfices narratifs d’une adhésion volontaire. Les modalités de défaite et de revanche restent à fixer avant implémentation.

La méthode est mémorisée pour chaque disciple et influence ses dialogues, expressions et l’épilogue. Une secte démoniaque réunie volontairement et une secte soumise partagent les mêmes décors et tenues de voie, mais pas la même ambiance relationnelle. Prévoir aussi les disciples non convertis : ne pas supposer que l’adoption de la voie transforme immédiatement tout le monde.

Aucune jauge globale de corruption n’est nécessaire au premier lot. Ne pas ajouter implicitement des morts, départs définitifs ou verrous de romance : leurs éventuelles règles demanderaient une conception distincte.

### Travail à réaliser et limites de périmètre

1. Écrire les cinq rencontres de l’initiatrice, les choix de refus et l’événement de basculement ; fixer leurs coûts et leur place dans le calendrier existant.
2. Prototyper une conversion volontaire et une conversion forcée sur un seul disciple, avec reprise de sauvegarde et réaction visible, avant de produire les trois parcours.
3. Ajouter aux sauvegardes l’orientation de la secte, l’étape de la PNJ et l’état/méthode de conversion de chaque disciple. Les anciennes sauvegardes doivent conserver travaux, liens, deck et progression, sans imposer une conversion.
4. Produire un lieu et un disciple témoins dans leurs deux identités pour mesurer le coût artistique ; décliner ensuite les lieux et membres prioritaires.
5. Relier les récompenses aux mécaniques non orthodoxes et démoniaques, encore partiellement à produire ; définir les conséquences sur le final et l’épilogue.

Le budget de 100 euros, l’équipe de deux et la cible de 3–5 heures restent les contraintes. Cette nouvelle branche nécessite un arbitrage explicite des scènes et événements précédemment prévus : réutiliser le tronc commun et réaffecter des places du catalogue à trente cartes avant toute extension chiffrée. Les anciennes hypothèses de volume ne doivent pas être présentées comme déjà compatibles sans mesure.

Critères de validation : accès orthodoxe sans enseignement démoniaque ; accès démoniaque après choix explicite ; progression de la PNJ dans le bon ordre ; refus et revanche sans blocage involontaire ; conversion volontaire/forcée distincte pour chaque disciple ; travaux conservés ; visuels cohérents avec orientation et conversion ; absence de récompenses répétables ; reprise correcte des anciennes et nouvelles sauvegardes.

**État : décision sauvegardée, conception détaillée et implémentation à venir. Aucun changement de gameplay, d’asset ou de sauvegarde utilisateur dans ce lot documentaire.**

### Espionne infiltrée — direction validée le 19 novembre 2026

Personnage distinct de la voyageuse initiatrice violette : jeune femme adulte aux cheveux courts noirs aux reflets carmin, petite tresse, éventail et pendentif de jade rouge. Sa version humaine conserve son charme assuré, sans cornes ni yeux lumineux ; vêtements de voyage et de disciple sobres, détails d'espionnage discrets. Sa forme démoniaque reprend le concept noir et carmin, les petites cornes et la tenue asymétrique. Références conservées dans `assets/spy/` ; le nouveau visuel humain reste une proposition à examiner.

Elle rejoint la secte après une semaine. Convention de calendrier retenue pour la conception : arrivée au début de J8, après sept journées complètes. Son identité publique est celle d'une recrue itinérante ; elle dissimule une mission d'espionnage. Son nom, son commanditaire et son objectif précis restent à écrire. « Non corrompue » désigne ici son apparence humaine ; cela ne signifie pas que son intention initiale est honnête.

Trois issues demandées :

- **Rédemption orthodoxe** : en suivant la voie orthodoxe et en développant suffisamment leur proximité, le héros peut l'aider à renoncer à sa mission et revenir vers le droit chemin. Prévoir une scène de choix et une adhésion volontaire, pas une conversion automatique au franchissement d'un score. Seuil et scènes de confiance à définir ; romance non obligatoire.
- **Expulsion** : le héros peut la chasser de la secte lors de la confrontation sur sa véritable mission. Le choix et ses conséquences doivent être explicitement annoncés. Les modalités d'un éventuel retour restent à concevoir.
- **Coopération démoniaque** : si le héros a explicitement choisi la voie démoniaque, il peut lui proposer une alliance en connaissance de cause. Sa présence et ses techniques ne changent pas à elles seules l'orientation de la secte.

Production proposée : une arrivée, des interactions de confiance réutilisant les lieux existants, une révélation commune puis trois conclusions courtes. Prévoir à terme les états arrivée / mission révélée / rédemption / expulsion / alliance et un lien propre à cette PNJ. Ne pas confondre cette rédemption avec la conversion forcée des disciples ni attribuer automatiquement les récompenses de l'initiatrice à l'espionne.

**État : conception et références visuelles uniquement.** J8 et ces embranchements ne sont pas encore jouables ; le contenu de calendrier et la migration des sauvegardes devront être développés et testés avant leur intégration. Aucun changement de sauvegarde ni de règles de combat dans ce lot. Cette seconde PNJ augmente le périmètre : réutiliser les décors et arbitrer les scènes/cartes existantes pour conserver la cible de 3–5 heures et le budget de 100 euros.

### Espionne : design validé et arrivée J8 préparée — 19 novembre 2026

Cette mise à jour remplace le statut « conception uniquement » pour la scène d'arrivée, pas pour ses branches futures. Le joueur valide **`assets/spy/human-concept-v2.png`**, avec cou raccourci et proportions corrigées. Ce fichier est la référence humaine définitive actuelle ; les versions précédentes sont conservées pour comparaison. La forme démoniaque reste `assets/spy/demonic-concept.png`. Ne pas réutiliser la silhouette de la voyageuse violette pour cette PNJ.

Scène implémentée : `visual/spy/arrival.tscn`, papier et encre, portrait issu du design validé, quatre échanges. Elle demande une place en tant que voyageuse sachant suivre une piste et porter des messages. Shen l'accueille à l'essai ; un papier dissimulé dans sa manche suggère un secret sans dévoiler sa mission. Son nom reste à choisir. L'expulsion relève de la confrontation future, pas d'un refus ajouté à cette arrivée.

Déclenchement préparé au retour dans la cour à partir du **créneau 21, J8 matin**, après le tutoriel (stade 3), si la campagne n'est pas terminée et si l'accueil n'a pas été enregistré. Rattrapage possible après ce créneau. Validation unique via `seen.spy_arrived` : aucun coût en réserve, aucune période consommée, aucune carte accordée, aucun changement de voie ou de lien. Si l'écriture échoue, le marqueur est retiré et un bouton permet de réessayer. Quitter avant validation permet de revoir l'accueil.

**Limite de disponibilité : les journées 5 à 7 ne sont pas encore intégrées à la séquence visuelle.** Le plafond normal demeure la fin de J4 (`END_SLOT = 12`). L'arrivée est testable séparément avec `ApercuEspionne.cmd` : état J8 créé en mémoire, profil `tools/spy-preview-user`, aucune lecture/écriture de la sauvegarde personnelle. Cet aperçu ne constitue pas une partie complète de J8 et ne propose pas encore ses activités.

Persistance préparée sans nouveau champ obligatoire : le format v4 accepte désormais les créneaux jusqu'à 24 (fin J8), indépendamment du plafond de gameplay ; v2 et v3 conservent leurs bornes. Les sauvegardes actuelles ne sont ni avancées ni réécrites par cette préparation. L'arrivée est mémorisée dans la liste de marqueurs existante, sans migration destructive. Le système de relation de l'espionne, sa révélation et les trois issues restent à développer.

Validation : **38 contrôles dédiés, zéro échec**, couvrant date, rattrapage, accueil unique, échec d'écriture sans mutation, sauvegarde/relecture J8, compatibilité J4, compteur de duels conservé et parcours UI. Régressions fiabilité : 31 contrôles réussis ; suite marchand J4 réussie. Capture réelle Godot `tests/spy-arrival.png` vérifiée. Six fichiers personnels sauvegardés dans `tools/save-backups/spy-j8-20261119-202725` et empreintes SHA-256 identiques après les tests.

### J7 — premier boss : le défi du territoire

**Direction demandée par le joueur :** une école rivale veut s'installer sur le territoire. Les chefs de secte engagent leur revendication dans une épreuve où trois disciples de chaque camp s'affrontent. Le joueur voit les intentions de ses alliés (attaque/défense), les intentions adverses et la cible de chaque adversaire. Des têtes chibi identifient les cibles. Ce premier boss précède l'arrivée de l'espionne à J8 ; elle ne fait donc pas partie de l'équipe de J7. Les chefs organisent le défi, les disciples combattent.

**Format proposé pour le prototype, à tester :** un affrontement simultané 3 contre 3, avec la recrue, Jun et Lian face à un disciple capitaine accompagné d'un assaillant et d'un protecteur. Shen reste le représentant de la secte. Seul le deck de la recrue est contrôlé directement ; les alliés possèdent des actions simples et annoncées. Aucun recrutement supplémentaire ni trois decks complets à gérer dans ce premier lot.

Boucle de manche proposée :

1. Afficher les intentions et cibles des six combattants, avec l'ordre de résolution. Le joueur doit pouvoir comprendre le prochain échange avant d'engager une carte.
2. Jouer les cartes de la recrue. Les attaques monocibles sélectionnent un adversaire ; les cartes de garde actuelles restent personnelles sauf mention explicite. Prévoir une technique de protection d'allié en réaffectant une carte existante, afin que voir les cibles permette réellement de réagir.
3. À « Fin du tour », résoudre d'abord les gardes/protections annoncées, puis les attaques alliées et enfin les attaques ennemies dans un ordre fixe visible. Une seule action par allié et adversaire, sans changement caché d'intention.
4. Un combattant mis hors combat perd son action. Une attaque visant une cible déjà hors combat est annulée, sans redirection surprise. Les effets de zone, quand ils existent, portent explicitement leur propre règle.
5. La garde protège jusqu'à la fin de cette manche, puis disparaît ; les intentions suivantes sont affichées après résolution. Tester ce rythme séparément du duel existant avant toute généralisation.

L'intérêt tactique recherché : concentrer une attaque pour interrompre un ennemi qui menace Lian, protéger Jun quand il s'engage offensivement, ou laisser un allié achever une cible pour économiser du qi. Les relations pourront ultérieurement améliorer les actions de soutien ; éviter que les liens deviennent une condition obligatoire pour gagner J7.

**Présentation proposée :** au-dessus de chaque combattant, petites icônes sans panneau carré : épée + dégâts, bouclier + garde, puis miniature chibi de la cible. Exemple : `épée 8 → tête de Lian`. Au survol/sélection, afficher « Attaque : 8 dégâts sur Lian » et une liaison temporaire vers la cible ; surbrillance de cette dernière. Pour une protection, afficher bouclier + valeur + tête protégée. Pour une attaque de groupe, icône de groupe et détail explicite. Formes, noms et surbrillance complètent les couleurs. Chaque combattant dispose de PV/garde propres et d'un état hors combat lisible. Réutiliser les chibis disponibles, avec recadrage de tête ; produire uniquement les portraits adverses manquants après validation du prototype.

**Calendrier et enjeu proposés :** annonce du défi avant J7 ; matin J7 réservé à la préparation, confrontation l'après-midi, débriefing le soir. Les rivaux cherchent un droit d'installation ; en cas de victoire, ils renoncent à leur revendication. Les détails exacts du territoire mis en jeu restent à écrire. Prévoir un point de reprise distinct avant le tournoi, permettant de revoir le deck après défaite sans effacer la campagne ni les chantiers. Pas de destruction irréversible de la secte ni de conversion forcée ajoutée implicitement. Proposition de défaite du prototype : recrue hors combat ; les alliés peuvent être hors combat sans mourir dans le récit. Victoire lorsque les trois adversaires sont hors combat. Ces conditions restent à valider en jouant.

**Périmètre et intégration :** le moteur actuel est un duel avec une seule réserve de PV ennemie ; le 3 contre 3 nécessite des entités, des cibles, une file d'actions, une garde et des statuts individuels. Ne pas simuler trois adversaires avec une unique barre de vie. Construire d'abord un laboratoire d'équipe isolé et testé (cible hors combat, annulation d'intention, garde, sauvegarde/reprise, victoire/récompense unique), puis intégrer J7 après J5–J6. Les anciennes cartes et les duels Jun doivent conserver leur comportement. Réexaminer M04/J9 et les récompenses existantes pour absorber ce boss dans le budget de scènes/cartes plutôt que tout additionner. Ne pas déplacer M03, qui déverrouille le sentier, sans adapter ses dépendances.

**État : direction enregistrée, règles ci-dessus proposées pour le prochain prototype ; combat d'équipe et tournoi J7 non implémentés.** L'arrivée J8 reste préparée séparément. Aucun changement au moteur de combat, au calendrier exécuté ou aux sauvegardes personnelles dans ce lot de conception.

### Laboratoire 3 contre 3 jouable — 19 novembre 2026

Premier prototype implémenté et isolé : `CombatEquipe.cmd` ouvre `visual/team/lab.tscn`, sans instancier la campagne, dans `tools/team-lab-user`. Aucun chargement ni écriture de sauvegarde de partie. La scène J7 de campagne et son point de reprise restent à intégrer après validation du laboratoire ; le plafond de campagne demeure J4.

Équipe : recrue (45 PV), Jun (32), Lian (28), contre capitaine (38), assaillante (27), protecteur (32). Six réserves de PV et de garde, intentions et cibles propres. Jun alterne attaque/protection ; Lian alterne protection/attaque ; le protecteur rival défend son camp une manche sur deux. Intentions fixées au début de la manche, sans redirection cachée : une source ou cible hors combat annule l'action. Toutes les protections annoncées sont résolues avant les attaques alliées, puis les attaques ennemies. La garde expire à la fin de la manche. Victoire quand les trois adversaires sont hors combat ; défaite si la recrue est hors combat. Retenter réinitialise tout le combat avec une nouvelle graine.

Deck d'essai fixe de douze cartes, distinct de la collection personnelle : B01 ×2, B02 ×2, B03, B04, B05, B06, B07, B08, L01, E05. La main initiale garantit une attaque et E05 pour tester immédiatement le ciblage, sans ajouter de carte. Les effets de base (qi, pioche, épuisement, bonus, posture persistante) réutilisent le moteur existant. **E05 / Travail commun, uniquement dans ce laboratoire : 6 garde à un allié choisi et pioche 1.** Les autres cartes de garde restent personnelles. Les règles et descriptions de campagne ne changent pas.

Interface : papier/encre et cartes existantes, six portraits chibi distincts. Au-dessus de chaque combattant : épée ou bouclier, valeur et tête chibi de la cible. Survol/focus : description et liaison temporaire vers la cible ; après sélection d'une carte, les cibles légales sont surlignées. Échap ou Annuler abandonne la sélection sans coût. Intentions annulées grisées, animation courte et journal des deux dernières actions pendant résolution ; bouton Règles pour consulter l'ordre. Ce sont des portraits animés par une impulsion visuelle, pas encore des animations martiales complètes.

Validation : **2 290 contrôles dédiés réussis**, y compris 100 combats automatisés, ciblage illégal sans dépense, protection de Jun, absence de redirection, allié hors combat, persistance, victoire/défaite, réinitialisation et parcours réel de l'UI. Capture `tests/team-battle.png` vérifiée dans Godot. Suites de régression Jun et orthodoxe réussies (642 contrôles orthodoxes). Agent automatique : 100 victoires sur 100 graines, 6,89 manches moyennes ; difficulté volontairement accessible pour tester la compréhension, pas un équilibrage final de boss. Évaluer ensuite la pression sur Jun/Lian, l'utilité du soutien et le rythme avant de durcir le duel.

Sauvegardes personnelles : copie préalable dans `tools/save-backups/team-lab-20261119-203700`, comparaison SHA-256 des six fichiers après tests. Aucun changement de progression, de collection, de deck personnel ou d'état des relations. Retour humain attendu : cibles et ordre compris sans explication, intérêt à protéger un allié, lisibilité des têtes chibi, durée et difficulté.

### Révision visuelle du laboratoire : personnages en pied

Retour utilisateur : remplacer la présentation de grands portraits par une scène de bataille comparable à la composition montrée en référence, personnages animés et cartes en bas. Intégré : équipes face à face, formation légèrement décalée en profondeur, nouveau décor manhua latéral avec sol libre, PV sous les pieds et intentions au-dessus. Les têtes chibi servent désormais uniquement aux cibles. Surlignage au sol au lieu de cadres de portraits, bande de main en bas et journal compact.

Animation : la recrue reprend l'attaque Sprite Forge et ses poses de garde, Jun reprend son atlas de combat. Lian et les trois adversaires disposent d'un nouvel atlas de poses en pied. Respiration légère, préparation/extension/reprise du coup, avancée et retour au point de départ, réaction de recul de la cible, pose/arc de garde. Les pieds des nouveaux sprites sont alignés selon leur contenu alpha. Les PV et la garde changent au contact de l'animation, pas au clic ; actions concurrentes bloquées jusqu'à son terme. Intentions annulées ne déclenchent pas d'attaque.

Pas de changement des règles ou de la difficulté : seul le moment visuel de résolution est synchronisé. Le laboratoire reste indépendant de la sauvegarde et de la campagne. Validation : 2 310 contrôles réussis, dont dégâts différés, application unique au contact, verrouillage des entrées, retour exact de la recrue, orientation des six combattants, animation Jun/Lian/capitaine. Capture Godot actualisée dans `tests/team-battle.png`. Les nouvelles poses restent un premier lot artistique à affiner après essai, pas des animations finales.

### Reprise des armes et des planches individuelles

Retour utilisateur : armes brisées, longueurs variables et défauts dans la planche commune. Nouvelle génération personnage par personnage, puis reprises ciblées de cadrage et des lames. Le laboratoire utilise désormais quatre PNG 2 × 2 : Lian à l'épée droite, capitaine au sabre large, assaillante aux deux dagues et protecteur à la lance. Gardes distinctes : épée devant le corps, sabre en parade, dagues croisées et hampe en travers. L'ancienne planche est conservée pour comparaison.

Import : une échelle fixe par personnage pour les quatre poses (aucun ajustement automatique par image), pieds alignés d'après les pixels suffisamment opaques pour ignorer les traces alpha presque invisibles. Aucun élément opaque ne traverse les séparations de cases sur les quatre planches corrigées. Capture Godot vérifiée avec les nouvelles armes. Tests : **2 358 contrôles réussis**, incluant les 16 poses et leur échelle constante ; résultats de simulation inchangés. Ces validations techniques ne remplacent pas le contrôle artistique des proportions.

Ce lot modifie les visuels seulement : les mécaniques de poison et de pilule restent à développer. Sauvegarde de campagne inchangée, aucune carte ni progression réattribuée. Prompts et provenance consignés dans `assets/team/ART.md`.

### Poison et pilule : premier lot jouable dans le laboratoire

Implémenté le 19 novembre 2026 dans le seul laboratoire `CombatEquipe.cmd` ; cette section remplace le statut « à développer » ci-dessus pour ces deux mécaniques. Aucun chargement ni écriture de la sauvegarde personnelle. La rencontre de campagne J7 et son point de reprise restent un chantier distinct.

**Dagues :** la première intention de l'assaillante est d'enduire ses armes, sans attaque. L'action est annulée si elle est déjà hors combat. Dès la manche suivante, les intentions d'attaque portent une goutte verte et leur cible chibi ; une blessure inflige +2 poison, cumulable jusqu'à 6. Une attaque entièrement absorbée par la garde ne donne aucun poison. Fin de manche : dégâts égaux au poison, ignorant la garde, puis diminution de 1. Le poison est individuel, visible sur la cible, et peut mettre la recrue hors combat. Statut, particules et chiffres accompagnent son effet ; les valeurs complètes sont au survol et dans Règles.

**Pilule :** une réserve visible annonce l'intervention du chef. Après la résolution complète de l'action qui ne laisse qu'un rival debout, activation unique : PV maximum restaurés, poison retiré, furie (+50 % de dégâts d'attaque, arrondi supérieur). Le survivant absorbe la pilule au lieu d'agir cette manche : son intention devient récupération et son éventuelle action déjà en file est retirée. Les autres actions alliées conservent leur ordre et leurs cibles ; le joueur garde sa main et son qi restants si le déclenchement a lieu pendant son tour. Dès la manche suivante, les dégâts renforcés sont inclus dans les nouvelles intentions, sans modifier rétroactivement une attaque annoncée. Si les trois adversaires sont hors combat, victoire sans résurrection ; si la recrue est déjà hors combat, aucune intervention.

Présentation : animation de pilule depuis la réserve du chef vers le survivant, bannière temporaire, aura rouge et statut « Furie : attaques +50 % ». Le chef est représenté par sa réserve/intervention hors champ dans ce prototype, sans nouveau personnage animé. Verrouillage des commandes pendant l'animation ; Retenter réinitialise enduit, poison, pilule, furie et événements. La pilule ne multiplie pas la dose de poison.

Validation : **43 contrôles spécifiques réussis** (enduit, garde complète/partielle, cumul/plafond, dégâts et décroissance, poison létal, trois survivants, soin/purge, action retirée, unicité, aucun vol de main/qi, aucune résurrection, UI et réinitialisation). Régression du laboratoire : **2 397 contrôles réussis**. Agent automatique : 100 victoires sur 100 graines, 7,01 manches moyennes ; données techniques, équilibrage humain encore à tester. Captures `tests/team-poison.png` et `tests/team-pill.png` vérifiées dans Godot.

Sauvegardes personnelles copiées dans `tools/save-backups/poison-pill-20261119-210555` et comparées par SHA-256 après les tests : six fichiers inchangés. Aucun cadeau, événement de campagne, carte ou relation modifié par ce lot.

### Interface de combat : correction du périmètre demandé

Le joueur a refusé la simplification trop large. Ne supprimer que les éléments explicitement demandés : bandeau d'aide/journal, « À toi de jouer », titre « Le défi du territoire » et compteur de tours. Règles et son panneau, noms des équipes, voies des cartes, PV/garde numériques, compteurs pioche/défausse/persistantes/main maximale, Quitter, Annuler et Retenter sont conservés.

Qi : sceau de jade au-dessus de Fin du tour, chiffre lisible, charges lumineuses et état atténué à zéro. Intentions : épée et bouclier redessinés, valeurs avec contour sombre, cible chibi dans un médaillon rond ; détails au survol et liens de ciblage conservés.

Validation : 2 397 contrôles de combat réussis ; captures Godot à 1 et 0 qi. Aucun changement des règles ni de la sauvegarde personnelle.

### École rivale : armes distinctes et tricheries — propositions à prototyper

Demande du joueur : varier les armes ; les rivaux ne combattent pas loyalement. Prévoir des armes empoisonnées et une intervention du chef qui lance une pilule au dernier disciple debout après la mise hors combat des deux autres, restaurant tous ses PV et augmentant fortement ses dégâts. Ces mécaniques ne sont pas encore présentes dans le laboratoire actuel.

Distribution proposée : capitaine au sabre lourd (coups puissants), assaillante aux deux dagues (poison et attaques multiples), protecteur à la lance (allonge et protection d'un partenaire). La recrue et Jun peuvent conserver leur épée ; différencier Lian plus tard par un style d'épée souple et précis plutôt que fabriquer immédiatement six familles d'armes. Les sprites rivaux actuels sont encore provisoires et devront être redessinés pour ces armes.

Événement 1, **Les lames enduites** : l'assaillante passe un tour à enduire ses dagues, geste visible et courte réaction d'un allié. Ensuite, ses attaques infligent du poison si elles retirent au moins un PV ; une attaque entièrement bloquée n'empoisonne pas. Proposition initiale : +2 poison par attaque, pas par coup d'une attaque multiple. Fin de manche : dégâts de poison ignorant la garde, puis quantité réduite de 1. Afficher le poison sous les PV de chaque personnage et dans l'intention de l'assaillante, avec la tête de sa cible. Tester le rythme et une limite d'accumulation avant validation ; ne pas ajouter en même temps un système général de consommables. Contre-jeu initial : protection de la cible ou interruption par mise hors combat.

Événement 2, **La pilule du dernier recours** : à la transition de deux adversaires vivants à un seul, le chef intervient une seule fois. Brève animation de lancer et absorption, remise aux PV maximum du survivant, purge proposée de ses malus, puis forte hausse de dégâts. Hypothèse de départ : +50 % aux dégâts d'attaque, arrondis au supérieur ; nouvelle intention affichée et répit avant son exécution. Ce pourcentage est une valeur de test, pas une règle validée. Conserver son arme et son rôle : capitaine amplifie ses frappes, assaillante sa pression avec les dagues, protecteur devient plus offensif. La pilule est visible chez le chef avant le déclenchement ; pas d'attaque renforcée immédiate au milieu d'une résolution déjà annoncée.

Contraintes du déclenchement : marquer la pilule comme utilisée avant l'animation, ne pas la répéter en rechargeant ; finir entièrement l'action à l'origine des mises hors combat avant de compter les survivants. Si aucun adversaire ne reste, victoire sans résurrection. Si les attaques alliées de la file restent à jouer, suspendre/recalculer la prochaine phase de manière explicite plutôt que changer silencieusement une intention en cours. La solution exacte de transition de manche devra être spécifiée et testée avant implémentation.

Autres événements optionnels, à ne pas cumuler dès ce premier boss : **sable aux yeux**, prochaine attaque affaiblie avec malus annoncé ; **faux abandon**, changement de posture suivi d'une attaque explicitement préparée ; **aiguille depuis les gradins**, intervention unique signalée avec cible visible et possibilité de protection. Pour le premier prototype, se limiter au poison et à la pilule, afin de mesurer leur difficulté et la durée ajoutée.

Cette triche donne au joueur une décision sur l'ordre des éliminations : choisir quel spécialiste affronter sous pilule, plutôt que toujours viser celui qui a le moins de PV. Tester trois issues (chaque survivant), protection contre poison, événements uniques, interruptions, victoire simultanée et reprise de sauvegarde. Aucun de ces ajouts ne doit réinitialiser les règles ou la sauvegarde de campagne.


### Jour 7 intégré : défi territorial, Jun et Lian

Le premier boss de campagne est désormais M03 au **matin du jour 7 (slot 18)**, au lieu de l’ancien emplacement de laboratoire au jour 6. Une école rivale veut s’installer sur les terres du Prunier ; les chefs engagent leur territoire dans un affrontement de trois disciples contre trois. Introduction papier/encre, préparation du deck et retour à la cour disponibles avant l’affrontement.

La séquence jouable est ouverte jusqu’à la fin du jour 7 (slot 21). Les jours 5 et 6 utilisent les activités, relations et réparations existantes ; aucun nouvel événement narratif propre à ces journées n’est annoncé. Le défi est obligatoire pour avancer au-delà du matin du jour 7. Après les deux activités restantes du jour 7, l’arrivée déjà préparée de l’espionne au jour 8 devient accessible ; les activités du jour 8 restent à développer.

Combat : recrue, Jun et Lian contre capitaine, assaillante aux dagues empoisonnées et protecteur. Intentions, cibles chibi, animations, poison et pilule unique du dernier survivant sont les mêmes que dans le laboratoire validé. Le deck réel équipé est utilisé sans cartes offertes ni main imposée ; le laboratoire autonome garde son deck de démonstration. PV et difficulté d’équipe restent ceux du prototype ; équilibrage humain avec les decks de campagne encore à poursuivre.

Persistance : sauvegarde de la préparation avant l’entrée en combat, refus de démarrer si l’écriture échoue. Défaite ou sortie : aucune période, carte, réserve ou relation perdue ; Retenter réinitialise le combat, poison et pilule avec la même graine. Interruption/rechargement : reprise avant le combat, pas au milieu d’une animation. Victoire validée par Continuer : une période, récompense M03 existante (+1 réserve), marqueur et historique une seule fois. Si l’enregistrement du résultat échoue, restauration de l’état précédent et nouvelle tentative possible. Aucun changement du format de sauvegarde (v4) ; anciennes versions v2/v3 toujours lisibles.

Validation : **35 contrôles d’intégration J7**, **2 397 contrôles du combat**, **43 contrôles poison/pilule**, et régression marchand/migration J4 réussis. Captures en moteur : `tests/day7-intro.png`, `tests/day7-combat.png`. Les fichiers personnels ont été copiés dans `tools/save-backups/day7-20261119-213125` avant les modifications ; tests dans un profil isolé et sur des copies, empreintes des six fichiers personnels vérifiées inchangées.


### Jun : attaque à six poses intégrée

Version approuvée détourée avec imagegen intégré, puis assemblée sans modification de la géométrie des armes. Ressources : `assets/jun_attack/sheet.png` et `attack.tres`. Utilisation en duel, dans la cour quand Jun s’entraîne et dans le combat 3 contre 3. Six poses, 0,70 seconde, impact unique à la quatrième pose ; taille et ancrage constants, miroir pour frapper vers la gauche. Aucune modification des dégâts, du calendrier ou des récompenses.

Validation : `tests/test_jun_attack.gd` réussi (six poses, transparence, impact unique, miroir, retour au repos, exclusion des autres acteurs), tests d’animation de duel réussis, 2 397 contrôles du combat d’équipe réussis. Capture en moteur inspectée : `tests/jun-attack-clean.png`. Copie de sécurité : `tools/save-backups/jun-animation-20261119-220414` ; six sauvegardes personnelles inchangées. Laboratoire autonome lancé pour tester sans avancer la campagne.


### Lian : attaque intégrée avec lame de longueur fixe

Les six poses validées sont intégrées au combat d’équipe et au jour 7. Pour éliminer les variations de longueur produites par la génération, la lame argentée a été retirée du dessin des poses via imagegen ; une seule lame issue du dessin approuvé est affichée dans Godot, fixée à la garde par une translation/rotation. Texture et échelle identiques sur les six poses, pas de redimensionnement de la lame. Ressources et provenance : `assets/lian_attack/ART.md`, composant `visual/team/lian_attack.tscn`.

Impact à la quatrième pose, attaque de 0,70 s ; garde et repos inchangés, aucune règle ni valeur de dégâts modifiée. Tests Lian (longueur, six poses, impact unique, retour au repos), Jun, 2 397 contrôles du combat et 43 contrôles poison/pilule réussis. Contrôles historiques adaptés à la nouvelle présentation de Lian au lieu d’exiger son ancienne planche 2 × 2. Captures inspectées en moteur : `tests/lian-attack-0.png` et `tests/lian-attack-3.png`.

Sauvegardes copiées avant intervention dans `tools/save-backups/lian-animation-20261119-221305` ; empreintes des six fichiers personnels inchangées. Laboratoire 3 contre 3 relancé pour essai sans progression de campagne.


### Correctif Lian : lame incluse dans chaque image

Retour joueur : lame absente en jeu malgré les premiers contrôles du montage séparé. Cause exacte non reproduite ; suppression de cette dépendance : six PNG complets exportés par Godot avec personnage et lame assemblés. Le jeu ne charge plus le corps sans lame ni le montage séparé. Source éditable conservée. Vérification des pixels de lame dans les six poses, du contact unique et de la vraie attaque au deuxième tour ; capture `tests/lian-live-attack.png`. Aucun changement des règles ou sauvegardes.


### Aperçu des cartes depuis le menu de deck

Correction du panneau de détail : le PopupPanel étirait le bouton Fermer sur tout son contenu. Remplacé par une surimpression Control avec une carte illustrée en grand, coût, voie, nom et description complète. Ouverture depuis une carte de la collection, le nom ou la vignette dans le deck ; fermeture par bouton, Échap ou clic extérieur. Les boutons +/− restent indépendants. Inspection sans modification du brouillon ni sauvegarde. Vérification en moteur : `tests/deck-card-detail.png` ; `tests/test_deck_inspect.gd` valide ouverture, illustration, géométrie, descriptions et conservation du deck. La fenêtre de jeu en cours n’est pas fermée automatiquement pour préserver le brouillon du joueur.


### Ajustement du boss J7 après test joueur — 20 novembre 2026

Retour : enduit de poison trop précoce, dégâts adverses trop faibles, garde peu lisible. L’assaillante attaque normalement au premier tour, annonce/utilise l’enduit au deuxième (action consommée), puis blesse avec poison à partir du troisième. Dose/plafond inchangés et garde complète toujours protectrice. Valeurs d’attaque de base : capitaine 12 (anciennement 8, croissance existante jusqu’à +4 conservée), assaillante 9 (anciennement 6), protecteur 8 (anciennement 5). PV, protections, alliés et multiplicateur de pilule +50 % inchangés ; intentions annoncent les nouvelles valeurs.

Garde : badge bouclier et valeur près des PV, protection translucide devant le personnage orientée vers l’adversaire, réaction au changement et fragments lorsque la garde tombe à zéro. Impacts distinguant garde consommée et PV perdus. Les informations et commandes précédemment conservées restent présentes.

Validation : 2 399 contrôles de combat, 49 contrôles tricheries/garde et 35 contrôles d’intégration J7 réussis. Simulation de référence : 99 victoires sur 100, 7,01 manches moyennes ; ne vaut pas validation d’équilibrage humain avec les decks de campagne. Première hausse à réévaluer avec le joueur. Tests exécutés en profil isolé, aucune modification des sauvegardes de campagne.


### Combat d’équipe : cartes en perspective et glisser-déposer — 20 novembre 2026

La rangée défilante est remplacée par une main en éventail à espacement adaptatif : toutes les cartes de la main sont présentes sans défilement, y compris une main de douze cartes. Elles se chevauchent lorsque la main est grande ; chaque tranche reste sélectionnable et le survol relève/agrandit la carte pour lire ses effets. Illustrations, polices et descriptions existantes réutilisées. Rendu haute résolution par SubViewport, projection de la face via shader avec rotation sur deux axes, ombre et léger reflet : effet de perspective 3D dans l’interface 2D, sans introduire de monde de combat 3D.

Glisser-déposer : attaques sur ennemi vivant, Travail commun sur allié vivant, cartes personnelles sur la recrue. Les cibles valides sont surlignées et le lien indique la cible survolée. Aucun coût avant le lâcher valide et l’animation d’impact existante ; lâcher ailleurs, clic droit, Échap ou perte de focus annulent. Cartes trop coûteuses non déplaçables ; cartes gratuites possibles à zéro qi. Clic classique et sélection clavier conservés. Règles, compteurs et autres boutons inchangés. Application : laboratoire 3 contre 3 et rencontre du jour 7 ; duel solo conserve son interface actuelle.

Validation : `tests/test_team_hand.gd` (événements souris, attaque unique, soutien, auto-ciblage, coût, lâcher invalide, annulation, douze tranches accessibles), 2 399 contrôles du combat et 35 contrôles d’intégration J7 réussis. Captures inspectées : `tests/hand-twelve-cards.png`, `tests/hand-card-hover.png`, `tests/hand-drag-target.png`. Tests en profil séparé ; sauvegardes de campagne non modifiées.

### Garde du combat d’équipe — 20 novembre 2026

La garde ennemie restante est conservée pendant la phase de cartes suivante du joueur, puis expire avant la prochaine résolution des intentions. Elle absorbe réellement les attaques du joueur, sans s’accumuler indéfiniment. La barre de PV d’un ennemi protégé devient bleue ; elle redevient rouge lorsque sa garde tombe à zéro. Badge et valeur restent présents.

Toutes les cartes de garde sans dégâts peuvent protéger un allié vivant choisi (recrue, Jun ou Lian), par clic ou glisser-déposer. Les effets persistants restent attachés à la recrue. Décision du joueur : une carte combinant attaque et garde cible uniquement un ennemi et protège automatiquement la recrue ; aucune deuxième cible à sélectionner.

Validation : 61 contrôles spécifiques de garde/ciblage/couleurs, 2 399 contrôles de combat, 49 contrôles poison/pilule et 35 contrôles J7 réussis ; test des interactions de la main réussi. Capture moteur contrôlée : `tests/enemy-guard-blue.png`. Tests en profil isolé, sauvegardes personnelles non modifiées. Application au laboratoire et au combat J7 partagé.


### Relations, recrutement et mains individuelles — 20 novembre 2026

Décision validée : apprendre une première technique AVANT de recruter. Cette section remplace les anciennes règles de quatre rangs et les actions automatiques de Jun/Lian.

| Rang | Déblocage |
|---|---|
| 1 — Rencontre | Résident connu, visites et activités |
| 2 — Transmission | Première technique (L01, J01 ou H01) dans la collection de la recrue |
| 3 — Confiance | Personnage recruté, disponible pour l’équipe |
| 4 — Complicité | Deuxième technique (L02, J02 ou H02) |
| 5 — Lien profond | Les deux techniques sont améliorées dans le deck du disciple et dans notre collection/deck, sans nouvelle copie ni rééquipement |

**Activités intégrées.** Matin : Jun ; après-midi : Lian ; soir : Shen. L’introduction obligatoire de Lian conserve son créneau de départ. Visites et conversations libres ne consomment rien ; une activité de progression coûte une période, au plus une progression par résident par jour. Paliers disponibles respectivement dès J1, J3, J6 et J10. Le dernier lien de Lian peut rester amical ; la scène romantique facultative se place le soir. Horaires et prochain déblocage sont affichés dans le carnet ; activité indisponible sans coût. Les longues scènes narratives et leurs choix restent à écrire : le système de paliers utilise encore les séquences chibi existantes.

**Améliorations actuellement testables.** L01 : 7→10 dégâts, combo 12→15 ; L02 : 4→7 garde ; J01 : 6→9 dégâts et 3→6 garde ; J02 : pioche 1→2 ; H01 : 8→11 garde ; H02 : 4→7 garde, croissance persistante inchangée. Noms marqués « + » et valeurs identiques dans collection, aperçu, mains et résolution. Duels solo et combat d’équipe utilisent le même contexte de relation. Les troisièmes techniques restent les signatures des compagnons ; celles acquises avant la migration restent possédées par la recrue.

**Combat jouable.** La recrue conserve son deck équipé ; Jun, Lian et Shen ont chacun un deck fixe de douze cartes. Équipe de trois, donc deux compagnons. Une main, pioche, défausse, pouvoirs persistants et réserve de qi par combattant. Hypothèse de test : quatre cartes et deux qi au début de chaque manche ; taille de main initiale dix, effets persistants individuels conservés. Les portraits permettent de choisir l’ordre avant toute carte jouée. Après sa première carte, un personnage termine son tour avant de céder la place. Un personnage ayant fini ou hors combat ne rejoue pas. Quand tous les personnages vivants ont fini, les ennemis exécutent leurs intentions, puis le poison est résolu. Aucun coup automatique supplémentaire des alliés. Qi, cartes et ressources ne sont pas partagés. Une attaque avec garde protège son lanceur ; une garde seule protège un allié choisi. Exposé vise le seul ennemi choisi et profite aux alliés jusqu’à la fin de la manche.

**Équipe J7.** Choix de deux compagnons dans la préparation. Jun et Lian restent disponibles sur ordre de Shen pour cette épreuve obligatoire, même sans rang 3, afin de préserver les anciennes campagnes et le duel de trois disciples. Shen peut remplacer l’un d’eux après recrutement au rang 3 ; deck défensif, 34 PV et sprite existant. Le choix reste un brouillon jusqu’au lancement ; validation de deux membres distincts et sauvegarde avant combat. Pas encore d’animation d’attaque dédiée à Shen. Les futures sorties libres exigeront le rang 3 pour chaque compagnon, sans l’exception narrative J7.

**Sauvegardes.** Format 5, migration de rangs 0→1, 1→2, 2→4, 3→4, 4→5. Toutes les cartes déjà acquises, le deck, les ressources, le jour, les équipements et l’historique sont conservés. La conversion ne se répète pas. Équipe mémorisée, valeur initiale Jun/Lian pour les anciens fichiers. Copie permanente `.before-relations` lors du premier enregistrement migré et récupération `.bak` conservées. Copie supplémentaire des profils personnels dans `tools/save-backups/recruitment-*` avec empreintes SHA-256 ; tests sur profil isolé.

**Validation.** 109 contrôles relations/recrutement/migration et règles de groupe, 10 contrôles d’interface, 3 525 contrôles combat d’équipe, 49 poison/pilule, 61 garde, 35 intégration J7 et 642 orthodoxes réussis ; interactions de main, inspection du deck et progression des duels réussies. Captures moteur inspectées : `tests/recruitment-jun-hand.png`, `tests/recruitment-shen-hand.png`, `tests/relation-activities.png`, `tests/recruited-party-selection.png`, `tests/relation-upgraded-card.png`. Simulation de référence : 100 victoires sur 100, 5,43 manches moyennes avec le bot et les decks de test. Le contrôle des trois personnages facilite le combat : équilibre NON validé, à reprendre après test humain.

**Suite du périmètre.** La campagne jouable s’arrête toujours après J7 et l’arrivée prévue J8 ; le rang 5 dès J10 est implémenté et testé dans le modèle, mais son accès naturel attend les prochaines journées. Restent : scènes de relation dédiées, invitations concurrentes, nouveaux arrivants liés à la reconstruction, sorties avec recrutement volontaire et choix d’évolution des decks compagnons. Pas de nouveaux personnages ni d’assets payants ajoutés par cette révision.

Laboratoire : bouton « Équipe de test » pour choisir deux compagnons parmi Jun/Lian/Shen et activer les liens de rang 5. Appliquer recommence le combat sans écrire dans une sauvegarde de campagne. Permet de tester la maîtrise avant la production de J10.


### Interface du combat : encre et jade — 20 novembre 2026

Direction validée à partir de la maquette générée : remplacement des barres rectangulaires et du texte PV/garde sous les unités. Jauge peinte sur fond d’encre, chiffres actuels/max intégrés et police de lecture conservée. La longueur du coup de pinceau suit les PV en conservant ses extrémités effilées. Toute unité protégée, alliée ou ennemie, utilise une jauge jade bleutée et un sceau avec le nombre de garde ; aucune valeur de garde nulle affichée. Noms conservés, état « Hors combat » maintenu.

Sélection : deux traits au sol, ivoire pour le personnage actif, vermillon pour une cible adverse. Suppression des rectangles de focus autour des combattants. Une courbe fine et effilée relie la carte à sa cible uniquement pendant le ciblage ; aucune ligne orthogonale au survol d’une intention ou pendant les attaques. Les intentions chiffrées et portraits de cible sont conservés. Carte sélectionnée moins relevée pour laisser les PV visibles pendant la visée ; agrandissement de consultation et glisser-déposer conservés.

Furie : volutes d’encre rouge animées derrière les épaules et sceau +50 % près du nom, en remplacement du grand cercle et de la phrase permanente. Suppression du grand polygone lumineux de garde ; pose défensive, sceau, couleur de jauge et fragments lors de la rupture restent lisibles. Infobulles des unités compactes, texte renvoyé à la ligne dans un panneau papier. Assets SVG et scènes Godot éditables, sans nouvelle génération payante et sans changement des règles de combat ou des sauvegardes.

Validation : capture réelle `tests/ink-jade-combat.png`, états et infobulle dans `tests/ink-jade-states.png`. 14 contrôles visuels/états, 61 contrôles de garde, 49 contrôles poison/pilule et test des interactions de main réussis. Vérification de la couleur indépendante des unités, des PV intégrés, des sceaux absents à zéro, de la furie/hors combat et de la courbe réservée aux cartes. Intégré au laboratoire et au combat J7 partagé.


### Dagues : poison cumulable renforcé — 20 novembre 2026

Retour joueur : l’assaillante doit être une cible prioritaire, avec un poison assez dangereux pour menacer la survie d’un compagnon. Révision : premier tour inchangé (9 dégâts directs) ; deuxième tour consacré à l’enduit ; à partir du troisième, le coup applique 9 charges de poison **à la place** des dégâts directs. La garde ne bloque ni l’application ni les dégâts de poison. Suppression du plafond de six charges. En fin de manche, chaque unité vivante perd autant de PV que ses charges, puis celles-ci diminuent de 1. Exemple : 9 appliquées → 9 dégâts, reste 8 ; second coup → 17 charges, 17 dégâts, reste 16. Le poison déjà appliqué continue même si l’assaillante tombe. Il ne prolonge pas un combat déjà gagné.

Intentions : goutte verte et valeur 9 comme intention principale, cible chibi conservée. Animation de frappe conservée, impact « +9 poison », puis impact séparé du déclenchement. Enduit et infobulles/règles mis à jour. Si l’assaillante reçoit la pilule, son application de poison bénéficie du +50 % et passe à 14, annoncé avant le coup. Ordre des actions adverses conservé. Aucun changement du capitaine, du protecteur ou des sauvegardes.

Objectif stratégique : assaillante → capitaine → protecteur. Comparaison par bot fixe sur 100 graines par scénario, trois personnages contrôlés : deck laboratoire 100 victoires en ciblant l’assaillante d’abord contre 95 en la laissant dernière ; deck actuel du joueur lu sans modification, 100 contre 92. Avec l’assaillante dernière, 12 combats sur 100 comportent au moins un allié KO dans chacun des deux lots. En la ciblant d’abord, aucun coup de poison n’a été subi dans ces simulations. **La chute d’un allié n’est donc pas garantie** : le combat peut finir avant que le poison tue. Le bot et ses decks ne remplacent pas un test humain ; équilibre provisoire. Pas de KO scripté ni de hausse supplémentaire des ennemis ajoutée.

Validation : 49 contrôles de tricheries (application à travers 100 garde, absence de dégâts directs, cumul 9→17→34, dégâts progressifs, pilule), 35 contrôles de campagne J7 réussis. Résultats reproductibles dans `tests/test_poison_priority.gd` et `tests/poison-priority-results.json`. Profils personnels inchangés.


### Correction validée : dagues 9 directs + 9 poison — 20 novembre 2026

Correction explicite du joueur : les dégâts de poison s’ajoutent aux dégâts directs, ils ne les remplacent pas. Cette règle remplace la section précédente sur les dagues. Après l’enduit du deuxième tour : chaque coup inflige 9 dégâts directs (absorbables par la garde) ET applique 9 poison, même si le coup est entièrement bloqué. Cumul sans plafond, déclenchement en fin de manche et diminution de 1 inchangés. Sans garde, un premier coup puis son déclenchement retirent donc 18 PV et laissent 8 poison. La pilule conserve le comportement précédent : 14 dégâts directs et 14 poison si l’assaillante est la dernière survivante.

Intentions distinctes épée 9 et goutte 9, impact indiquant dégâts/garde puis poison ajouté, règles et infobulles corrigées. Tests : 51 contrôles poison/pilule réussis, notamment 45→36 PV au contact puis 27 PV au déclenchement, et blocage direct par 100 garde sans bloquer le poison. Capture moteur inspectée. Simulation de priorité réexécutée dans `tests/poison-priority-results.json` pour remplacer les valeurs de l’ancienne variante.

Retour joueur : le combat testé reste faisable et la priorité assaillante → capitaine → protecteur paraît acceptable. Attention : ce retour a précédé l’installation effective du correctif 9 directs + 9 poison ; le nouvel essai doit confirmer cette variante. Aucune hausse supplémentaire des adversaires. Sauvegarde de campagne inchangée.


### Cinq ajouts : parcours relations J5–J7 — 20 novembre 2026

Implémentés dans le prototype :
1. Deux invitations concurrentes Jun/Lian à l’après-midi J5. Une activité consomme la période ; l’invitation non suivie revient à l’après-midi J6. Les horaires ordinaires restent en place en dehors de ces invitations.
2. Scène de recrutement au passage au rang 3 pour Jun, Lian et Shen, deux réponses mémorisées. Ouvrir/annuler la scène ne coûte rien ; confirmer consomme exactement une période. Les réponses expriment la relation, sans bonus mécanique différent pour le moment.
3. Consultation complète des douze cartes de chaque compagnon depuis le menu et la préparation du tournoi, détail au clic, rang/recrutement et jalons 2/3/4/5. Consultation seule : aucun changement du deck personnel ni de la sélection provisoire de l’équipe.
4. Avertissement J6 sur les dagues ; préparation facultative d’une dose d’antidote en échange d’une période, également disponible dans le carnet J6. Utilisation en combat sur un allié vivant empoisonné : tout son poison est dissipé, aucun qi consommé. Aucune dose perdue sur une cible invalide. Le point de reprise avant le combat conserve la dose pour les nouvelles tentatives ; la victoire enregistre le reste.
5. Retour après victoire J7 adapté aux compagnons tombés ou protégés par un autre membre ; réaction à l’antidote utilisé. Deux aspirants, Mei et Tao, attirés par la victoire : accueil à l’essai ou attente de logements, choix conservé et consultable dans le menu. Leur arrivée est narrative uniquement : portraits spécifiques, emploi du temps, recrutement combattant et arcs individuels restent à développer.

Sauvegarde version 6, lecture des versions 2–5 conservée ; copie permanente `.before-story` lors de la première écriture d’un ancien fichier. L’échec de sauvegarde d’une activité annule ses effets en mémoire. Les profils personnels ne sont pas modifiés par les tests.

Parcours joueur : lancer `ParcoursRelations.cmd`. Profil distinct `tools/relations-route-user`, initialisé une seule fois au J5 après-midi, liens au rang 2, premières techniques acquises. Choisir Jun ou Lian, passer le soir (ou recruter Shen), décider de l’antidote au J6, retrouver l’autre invitation, rejoindre le tournoi J7 puis découvrir le retour. Une relance reprend ce profil ; elle ne réinitialise pas la campagne.

Validation : `test_story_route.gd` 26 contrôles réussis (invitations, annulation, recrutement, antidote, consultation, réactions, persistance) et captures Godot inspectées ; régressions J7 35, recrutement 109, poison/pilule 51, garde 61, interface relations 10 contrôles réussis. L’équilibrage de l’antidote reste à confirmer en jeu : il s’agit d’une purge unique et non d’une immunité aux coups suivants.


### Harmonisation transversale des combats — 20 novembre 2026

Correction suite au retour joueur : Jun et la voyageuse conservaient l’ancien HUD alors que le tournoi avait été amélioré. Le HUD solo réutilise désormais la scène de main animée/perspective du 3 contre 3 (toutes les cartes accessibles, survol agrandi, clic puis cible ou glisser-déposer), l’orbe de qi et les barres de vie encre/jade. Garde visible en sceau chiffré, PV au centre de la barre, barre bleue sous garde. Intentions avec les mêmes SVG et portrait chibi de cible. Nombre de tours, panneau d’aide et anciens grands panneaux PV retirés. Les informations de forces/main/persistantes restent accessibles via les compteurs et leur infobulle.

Ciblage solo : attaque ou attaque+garde sur l’adversaire, garde seule sur soi (seul allié présent). Mauvais dépôt : annulation sans consommation. La garde adverse survit déjà au tour du joueur dans le modèle solo ; cette règle reste inchangée. Qi conservé à 3 en duel, 2 par personnage en équipe : différences d’équilibrage explicites, même présentation. Le tutoriel de Jun et ses niveaux de difficulté sont conservés.

Règle de développement : chaque changement partagé de mécanique ou de présentation doit être vérifié sur Jun (tutoriel et entraînement), voyageuse, tournoi J7 et laboratoire 3 contre 3. Réutiliser les composants communs ; documenter les exceptions de règles. Les anciennes scènes de recherche graphique ne constituent pas des écrans de campagne.

Validation : test du HUD révisé couvrant 12 cartes, garde des deux côtés, qi, ciblage, dépôt invalide, coût, action en cours et voyageuse ; régressions main 3 contre 3, garde et progression de Jun. Sauvegardes personnelles non modifiées. Les contrôles GUI ont réussi mais un premier arrêt du processus Godot a produit un crash natif après les assertions : vérification de fermeture réexécutée après délai de libération des vues.

Nouvelle exécution graphique : contrôles réussis et fermeture normale (code 0), sans crash après le délai de libération.


### Audit global de cohérence et architecture — 20 novembre 2026

Rapport : [AUDIT_COHERENCE_ARCHITECTURE_2026-11-20.md](AUDIT_COHERENCE_ARCHITECTURE_2026-11-20.md). Revue du code et des parcours actifs, sans refonte ni changement de règles. 14 suites exécutées dans un profil isolé : 12 réussies, 2 bloquées par leurs références à l’ancien HUD. Reproductions dédiées : cible incorrecte pour J02 en duel, démarrage/récompense malgré échec d’écriture, acceptation d’un rapport narratif mal formé. Ancienne carte encore présente dans la récompense initiale de Lian, textes de fin J4/J7 divergents.

Priorités proposées : (1) sécuriser les transactions et le ciblage, valider les données imbriquées, réparer les tests ; (2) centraliser les règles/UI partagées ; (3) extraire Personnage et Deck avec état unique ; (4) Combat avec équipes de 1 à 3 et configuration de rencontre ; (5) retirer les anciens adaptateurs après parité. Conserver les équilibres, sauvegardes et comportements validés. Cette migration est une recommandation documentée, pas une refonte déjà réalisée.


### Corrections de l’audit et première migration de données — 20 novembre 2026

Réalisé, sans changement des coûts, dégâts, pioche ou probabilités :
- Ciblage centralisé dans `Cards.target_kind` pour duel et équipe : J02 vise l’adversaire, garde seule un allié (soi en duel), attaque+garde vise l’adversaire et protège le lanceur.
- Apprentissage initial, démarrage et résultat de Jun contrôlent l’écriture ; résultat non enregistré annulé en mémoire, écran avec bouton Enregistrer pour réessayer sans attribuer deux fois les récompenses. Ancien helper de remplacement de carte également protégé. Les transactions déjà présentes pour tournoi, voyageuse et menu de deck sont conservées.
- Validation imbriquée des rapports de combat, invitations et choix de recrutement. Fichier mal formé refusé avant remplacement de la sauvegarde primaire.
- Tests de fiabilité et des voies réparés : chemins du nouveau HUD ; comparaison après normalisation des migrations, sans retirer les vérifications de progression.
- Récompense initiale de Lian devenue une scène `.tscn` papier/encre utilisant la même carte que le deck ; texte de fin J7 harmonisé dans le jardin et README actualisé.
- Orbe de qi paramétrable pour une recharge de 2 ou 3, jusqu’à cinq marques pour représenter les gains de qi autorisés. Texte impossible sur les cartes attaque+garde retiré.

Architecture effectivement migrée : `prototypes/combat/character_state.gd`, `deck_state.gd`, `team_state.gd`. Chaque personnage possède ses PV/garde/statuts, son qi/buffs et son deck. Le deck possède les piles et son générateur aléatoire. `battle.gd` expose des accesseurs de compatibilité ; `team_battle.gd` construit des équipes et partage l’état des personnages avec les vues. Les copies aller-retour de PV/garde lors des cartes ont été supprimées. Pioche/mélange et recharge des buffs persistants sont communs aux formats. Les tableaux historiques restent des vues du même état, pas une deuxième source de vérité.

Limite volontaire de cette étape : `battle.gd` et `team_battle.gd` conservent encore leurs orchestrations de rencontre. Le tournoi garde ses six positions et ses règles de poison/pilule. Il ne s’agit pas encore du moteur Combat entièrement paramétrable. Prochaine migration : extraire les configurations de rencontres et l’ordre des phases, puis remplacer les adaptateurs sans modifier les scénarios validés. Les états de combat ne changent pas le format de sauvegarde de campagne.

Validation : `python tools/run_regressions.py` exécute 16 suites avec profil isolé, délai maximal et détection des erreurs GDScript ; toutes réussies. Tests supplémentaires `test_visual_day`, `test_ink_combat_ui` réussis ; HUD et nouveaux écrans contrôlés dans Godot, dont simulation d’échec de sauvegarde puis réussite et absence de double récompense. Contrôle SHA-256 : fichiers des profils `play-user`, `parcours-test-user`, `relations-route-user` inchangés. Résultats dans `tests/regression_results.json` ; tests ciblés dans `tests/test_audit_fixes.gd`.


### Migration du moteur commun coordonnée avec deux agents — 20 novembre 2026

Agent architecture : modèles/moteur/politiques ; agent tests : référence avant migration, tests directs et régressions ; agent principal : revue indépendante, raccordement des interfaces, captures et documentation. Aucun travail concurrent sur les mêmes fichiers de production.

**Intégré :** `prototypes/combat/encounter.gd` est désormais le résolveur commun de cartes, ciblage, actions adverses, phases, garde, poison et KO. Il reçoit deux équipes de 1 à 3 personnages et une configuration. `duel_policy.gd` et `territory_policy.gd` portent les intentions et règles particulières. Les anciennes API `battle.gd` / `team_battle.gd` restent des adaptateurs ; leurs contrôleurs et sauvegardes continuent de fonctionner. Les objets de compatibilité des compagnons partagent le même moteur, sans moteur de duel séparé pour résoudre leurs cartes.

La main partagée lit un contrat de contrôleur (`hand_model`, `can_play_card`, `hand_blocked`) et délègue au moteur. Plus de faux dictionnaire de combat solo. Les coûts et autorisations sont contrôlés dans le moteur, y compris pour glisser-déposer. Les scènes restent 1v1 et 3v3 ; le support 2v3 du moteur n’est pas présenté comme un nouveau contenu jouable.

Deux défauts trouvés pendant revue et corrigés : main de démonstration préparée sur l’ancien acteur lors d’une relance depuis Jun/Lian ; mauvaise cible d’événement poison si deux dictionnaires d’unité devenaient égaux. Couverture dédiée ajoutée.

Validation : parité parfaite des 126 scénarios / 3 890 états capturés avant migration ; 332 contrôles du moteur paramétrable réussis. Premier runner 18/18 ; second runner 17/18 avec crash natif Godot au shutdown de `test_audit_fixes` après assertions PASS. Trois réexécutions ciblées puis une exécution verbose séparée : sortie normale. Incident intermittent de fermeture préexistant, non résolu et conservé dans les résultats. Captures GUI du duel, de la voyageuse, de la main du tournoi et du HUD encre/jade inspectées ; ces trois suites graphiques sortent avec code 0.

Sauvegardes : les 8 fichiers des trois profils de campagne contrôlés par SHA-256 sont inchangés. Format v6 conservé. Pas de rééquilibrage ni de nouvel événement de campagne introduit. Guide technique : [ARCHITECTURE_COMBAT.md](ARCHITECTURE_COMBAT.md). README actualisé pour les profils et migrations. Le gros reliquat moteur séparé signalé dans l’étape précédente est remplacé ; restent les adaptateurs de présentation et le problème intermittent de fermeture du test graphique.


### Lecture du duel — règle révisée (20 novembre 2026)

B06 pioche toujours 2 cartes. Coût : 1 Qi, réduit à 0 Qi pour un deck initial de combat de 16 cartes ou plus. Remplace le précédent bonus de troisième carte piochée. Règle commune aux duels et aux combats en équipe, calculée pour le deck du personnage qui la joue ; le coût affiché en main suit le coût réel. Aucune modification des sauvegardes ni des decks existants.


### Audit des données, responsabilités et accessibilité — 20 novembre 2026

Retour utilisateur confirmé pour les règles par ID, duplications deck, catalogue reparsé, touches brutes et organisation trompeuse. Corrections intégrées : données JSON des cartes, résolution générique d’effets, source commune des restrictions de deck, cache avec copies isolées, déplacement du runtime dans `game/` et archive de l’ancien prototype dans `legacy/`. Session/sauvegardes, dialogues, son et présentation des attaques séparés du coordinateur. États de progression nommés avec conservation des valeurs v6.

InputMap et écran Commandes fonctionnels (remappage, conflit de touches, annulation Échap, reset et persistance séparée). Localisation FR/fallback et fichiers de dialogue en place ; extraction de tous les libellés et langues supplémentaires encore à faire. Les sous-écrans gardent certains callbacks vers le coordinateur : ne pas déclarer le découplage total ou toute l’étape 6 terminée.

Validation finale : 22/22 suites ; parité de 3 890 états de combat et 1 440 états d’effets ; 121 contrôles de données/règles, 332 moteur ; 84 contrôles commandes/localisation GUI. Fuites de cache apparues pendant ce travail corrigées par propriétaire autoload. Huit empreintes de sauvegardes inchangées. Voir [audit détaillé](AUDIT_ARCHITECTURE_DONNEES_2026-11-20.md) et [architecture actualisée](ARCHITECTURE_COMBAT.md).
