# Visiteuse : poses de combat

Source : génération intégrée, 21 novembre 2026, référence assets/visitor/portrait-cutout.png. Aucun service externe payant.

Planche transparente 2 × 2 : attente, anticipation, extension de l’éventail fermé vers la gauche, garde. Même costume violet/ivoire, coiffure et bijoux que le concept validé. Source PNG conservée ici ; copie moteur dans assets/visitor.

Le sprite Godot aligne les pieds par les limites alpha avec une échelle commune aux quatre poses. Le présentateur de duel orchestre déplacement, contact et retour. Animation volontairement limitée à quatre poses ; aucun changement des mécaniques.

Le moteur écarte les pixels alpha < 0,02 avec alpha_cleanup.gdshader. Une seconde proposition de nettoyage générée n’a pas été intégrée : elle conservait les mêmes résidus quasi transparents.
