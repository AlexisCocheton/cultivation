# Plan de développement des Cendres du Prunier

Version du 19 novembre 2026. Nom de travail, à confirmer.

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

**État courant :** jour 4 intégré avec marchand S01 et équipements ; plafond visuel à la fin du jour 4. Sauvegardes v2 reprises sans réinitialisation, écriture v3 avec archive avant migration. Duels progressifs vérifiés. J5–J6 et S06 restent à produire. Les paragraphes ci-dessous retracent les décisions des étapes précédentes ; voir le dernier bilan d’intégration en fin de document.

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
- Trois résidents avec quatre rangs chacun ; techniques aux rangs 1, 2 et 3 ; romance facultative au rang 4 de Lian.
- Combat avec 45 PV de départ, trois qi par tour, main de cinq cartes et intentions annoncées ; v0.2 ajoute une pression progressive au boss et ajuste quatre cartes de Lian/Shen.
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
| J7–J8 | Exploitation du sentier ; S02 (pavillon 1, E04 et +1 réserve si victoire), S05 (E06/O02 si victoire) ; retour du marchand J8 ; poursuite des rangs 3. | Les trois orientations de deck peuvent obtenir une préparation viable ; combat offensif et défensif compris sans explication orale. |
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
