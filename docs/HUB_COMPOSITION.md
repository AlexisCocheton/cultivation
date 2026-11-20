# Cour principale — composition et sources

Le décor a été généré depuis la référence de cour fournie par le joueur, en supprimant le héros, tous les passants/gardes et toute interface incrustée. La variante réparée est un edit de ce décor, limité au pavillon et à l’escalier.

Calques : `scene.tscn/Background` (décor et shader local de vent/restauration), acteur Jun existant (six poses), pétales existants, `hud.tscn` (cadres et texte éditables). Aucune capture de maquette utilisée comme écran aplati.

Illustrations : `assets/ui/hub/courtyard.png`, `restored.png`. Jun : `assets/jun_attack/attack.tres`. Cadres : `visual/shared/status_frame.tres`.

Prévisualisation isolée : Godot `--path . --script visual/hub/layer_preview.gd`. Jour 4 temporaire, pas de chargement ni d’écriture de la sauvegarde joueur. Ajouter `-- --capture` pour exécuter les contrôles et produire les captures puis quitter.

Contrat : choisir un lieu ou une activité ; montrer jour, période, réserves et échéance. Clic sur accès encadrés, clavier Tab/Entrée, raccourcis Jun/deck configurables. Le portail peut présenter plusieurs rencontres simultanément. Échap referme ce choix avant d’ouvrir le menu général.
