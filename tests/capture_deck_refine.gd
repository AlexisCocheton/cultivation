extends SceneTree
var game
func _initialize(): call_deferred("run")
func snap(name):
 await process_frame
 await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("res://docs/painted-ui/refine-"+name+".png")
func run():
 root.size = Vector2i(1280,832)
 root.content_scale_size = Vector2i(1280,832)
 game = load("res://visual/preview.tscn").instantiate()
 root.add_child(game)
 await process_frame
 assert(not game.persistence)
 game.stage=3
 game.calendar.grant("L01")
 game.calendar.grant("Q01")
 game.deck_ui()
 var menu=game.ui.get_child(0)
 await snap("deck")
 menu.add_card("L01")
 assert(menu.get_node("Modified").visible)
 menu.get_node("Search").text="souffle"
 assert(menu.get_node("Scroll/Grid").get_child_count()>=2)
 menu.get_node("Search").text=""
 menu.inspect("B06")
 await snap("card")
 root.size=Vector2i(960,624)
 await snap("card-960")
 menu.close_detail()
 await snap("deck-960")
 menu.get_node("Filters/Base").pressed.emit()
 assert(menu.get_node("Scroll/Grid").get_child_count()==8)
 menu.get_node("Filters/Demonic").pressed.emit()
 assert(menu.get_node("Empty").visible)
 menu.get_node("Filters/All").pressed.emit()
 for id in game.Cards.catalog():
  menu.inspect(id)
  await process_frame
  assert(menu.get_node("Detail/Effects").get_minimum_size().y<=252)
 game.clear_ui()
 var reward=load("res://visual/combat/reward.tscn").instantiate()
 game.ui.add_child(reward)
 reward.setup(game)
 await snap("reward-960")
 root.size=Vector2i(1280,832)
 await snap("reward")
 print("DECK REFINE PASS: search/base/empty/draft/inspection; 6 captures")
 game.queue_free()
 await process_frame
 quit()
