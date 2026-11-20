extends Control
var section = 0
const HEADINGS = ["Jouer son tour", "Lire les intentions", "Protéger un disciple", "Les dagues empoisonnées", "La dernière pilule", "Victoire et défaite"]
const EXAMPLES = ["Une main et une réserve de qi propres à chaque disciple.", "L’icône annonce l’action. Le portrait indique sa cible.", "", "9 poison → 9 dégâts, puis 8 poison.\nUn nouveau coup ajoute encore 9 poison.", "Le dernier rival récupère cette manche.\nSa prochaine attaque est renforcée de 50 %.", "La recrue doit rester en vie jusqu’à la victoire."]
func _ready() -> void:
 for i in range($Sections.get_child_count()):
  var index = i
  $Sections.get_child(i).pressed.connect(func(): select_section(index))
 visibility_changed.connect(func():
  if visible:
   select_section(section)
   $Sections.get_child(section).grab_focus())
 select_section(0)
func select_section(index: int) -> void:
 section = clampi(index,0,HEADINGS.size()-1)
 var paragraphs = $Words.text.split("\n\n")
 $Heading.text = HEADINGS[section]
 $Body.text = paragraphs[section] if section < paragraphs.size() else ""
 $Body.scroll_to_line(0)
 $Example.text = EXAMPLES[section]
 $Example.visible = section != 2
 $Examples.visible = section == 2
 for i in range($Sections.get_child_count()): $Sections.get_child(i).button_pressed = i == section
