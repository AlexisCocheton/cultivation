extends SceneTree
var game
func _initialize(): call_deferred("run")
func snap(name):
 for width in [1280,960]:
  root.size=Vector2i(width,int(width*832.0/1280))
  await process_frame
  await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png("res://docs/painted-ui/refine-"+name+("-960" if width==960 else "")+".png")
func run():
 root.size=Vector2i(1280,832)
 root.content_scale_size=Vector2i(1280,832)
 game=load("res://visual/preview.tscn").instantiate()
 root.add_child(game)
 await process_frame
 assert(not game.persistence)
 game.stage=3
 game.calendar.slot=10
 game.calendar.seen=["M01","M02"]
 game.calendar.ranks={"L":2,"J":2,"H":2}
 game.menu_ui()
 await snap("sect-menu")
 game.ui.get_child(0).get_node("ControlsButton").pressed.emit()
 var controls=game.ui.get_child(0).get_node("Controls")
 await snap("controls")
 controls.get_node("Paper/open_deck").pressed.emit()
 assert(controls.pending=="open_deck")
 await snap("controls-pending")
 var conflict=InputEventKey.new()
 conflict.pressed=true
 conflict.physical_keycode=KEY_E
 conflict.keycode=KEY_E
 controls._input(conflict)
 assert(not controls.get_node("Paper/Notice").text.is_empty())
 assert(controls.pending=="open_deck")
 var escape=InputEventKey.new()
 escape.pressed=true
 escape.keycode=KEY_ESCAPE
 controls._input(escape)
 assert(controls.pending.is_empty())
 controls.get_node("Paper/Back").pressed.emit()
 game.garden_ui()
 await snap("garden")
 game.pavilion_ui()
 await snap("pavilion")
 game.hub()
 game.dialogue(2,false,"La garde ne sert pas seulement à encaisser. Observe ton adversaire, puis choisis ton ouverture.","Continuer",game.hub)
 await snap("dialogue")
 var dialogue=game.ui.get_child(0)
 dialogue.get_node("Hide").pressed.emit()
 assert(not dialogue.get_node("Paper").visible and not dialogue.get_node("Choice").visible)
 dialogue.get_node("Hide").pressed.emit()
 assert(dialogue.get_node("Paper").visible and dialogue.get_node("Choice").visible)
 dialogue.get_node("Paper/TextScroll/Words").text="Un long souvenir. ".repeat(70)
 await process_frame
 assert(dialogue.get_node("Paper/TextScroll").get_v_scroll_bar().visible)
 assert(not dialogue.get_node("Paper/TextScroll").get_global_rect().intersects(dialogue.get_node("Choice").get_global_rect()))
 game.dialogue(2,true,"Bien. Tu commences à comprendre !", "Continuer",game.hub)
 await snap("dialogue-happy")
 game.confirm_restart()
 var before=game.calendar.snapshot()
 await snap("confirm")
 game.ui.get_child(0).get_node("Cancel").pressed.emit()
 assert(game.calendar.snapshot()==before)
 print("RESIDENT UI PASS: 16 captures, remap cancel, confirm cancel, expressions, isolated profile")
 game.sound.stop()
 game.sound.stream=null
 game.queue_free()
 await create_timer(0.3).timeout
 quit()
