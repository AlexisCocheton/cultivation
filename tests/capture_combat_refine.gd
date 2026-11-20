extends SceneTree
var game
func _initialize():call_deferred("run")
func snap(name):
 for width in [1280,960]:
  root.size=Vector2i(width,int(width*832.0/1280))
  await process_frame
  await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("res://docs/painted-ui/refine-"+name+("-960" if width==960 else "")+".png")
func hand_bounds(hand):
 for card in hand.cards:
  for part in [card.get_node("Face"),card.get_node("Shadow")]:
   for point in [Vector2.ZERO,Vector2(part.size.x,0),part.size,Vector2(0,part.size.y)]:
    var corner=part.get_global_transform()*point
    assert(corner.x>=0 and corner.x<=1280 and corner.y>=0 and corner.y<=832)
func run():
 root.size=Vector2i(1280,832)
 root.content_scale_size=Vector2i(1280,832)
 game=load("res://visual/preview.tscn").instantiate()
 root.add_child(game)
 await process_frame
 assert(not game.persistence)
 game.stage=3
 game.calendar.slot=10
 game.start_combat()
 await snap("duel")
 var duel=game.ui.get_child(0)
 game.battle.hand=["B01","B02","B03","B04","B05","B06","B07","B08","B01","B02","B03","B04"]
 duel.get_node("Hand").rebuild()
 await snap("duel-12")
 hand_bounds(duel.get_node("Hand"))
 for i in [0,11]:
  duel.get_node("Hand").hovered=i
  await create_timer(0.3).timeout
  hand_bounds(duel.get_node("Hand"))
  await snap("duel-hover-"+str(i))
 game.hub()
 game.clear_ui()
 var lab=load("res://visual/team/lab.tscn").instantiate()
 game.ui.add_child(lab)
 await snap("team-combat")
 lab.battle.core.hand=["B01","B02","B03","B04","B05","B06","B07","B08","B01","B02","B03","B04"]
 lab.get_node("Hand").rebuild()
 await snap("team-12")
 hand_bounds(lab.get_node("Hand"))
 for i in [0,11]:
  lab.get_node("Hand").hovered=i
  await create_timer(0.3).timeout
  hand_bounds(lab.get_node("Hand"))
  await snap("team-hover-"+str(i))
 lab.get_node("Hand").hovered=-1
 var rules=lab.get_node("HelpPaper")
 var original=rules.get_node("Words").text
 var paragraphs=original.split("\n\n")
 assert(paragraphs.size()==6)
 lab.get_node("Help").pressed.emit()
 for i in range(6):
  rules.get_node("Sections").get_child(i).pressed.emit()
  assert(rules.get_node("Body").text==paragraphs[i])
  assert(rules.get_node("Examples").visible==(i==2))
  await snap("rules-"+str(i))
 assert(rules.get_node("Words").text==original)
 rules.get_node("Words").text=original.replace("Ce laboratoire ne touche pas à ta sauvegarde.","La préparation est sauvegardée avant le combat. Une défaite permet de réessayer.")
 rules.select_section(5)
 assert(rules.get_node("Body").text.contains("La préparation est sauvegardée"))
 rules.get_node("Close").pressed.emit()
 assert(not rules.visible)
 assert(lab.battle.round_index==0 if "round_index" in lab.battle else true)
 print("COMBAT UI PASS: 28 captures, six exact rule sections, campaign text, close, 12-card face/shadow bounds at rest and hover, no game rule mutation")
 game.sound.stop()
 game.sound.stream=null
 game.queue_free()
 await create_timer(0.3).timeout
 quit()
