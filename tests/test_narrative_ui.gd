extends SceneTree
var game
func _initialize(): call_deferred("run")
func capture(label):
 await process_frame
 await process_frame
 await RenderingServer.frame_post_draw
 assert(root.get_texture().get_image().save_png("res://docs/painted-ui/refine-"+label+".png") == OK)
func show_scene(path):
 game.clear_ui()
 var view = load("res://visual/"+path+".tscn").instantiate()
 game.ui.add_child(view)
 return view
func run():
 root.size = Vector2i(1280,832)
 root.content_scale_size = Vector2i(1280,832)
 game = load("res://visual/preview.tscn").instantiate()
 root.add_child(game)
 await process_frame
 assert(not game.persistence)
 game.stage = 3
 game.calendar.slot = 13
 game.calendar.ranks = {"J":2,"L":2,"H":2}
 for width in [1280,960]:
  root.size = Vector2i(width,832 if width == 1280 else 624)
  var suffix = "" if width == 1280 else "-960"
  for kind in ["invite","prepare","recruit:J","return","candidates"]:
   if kind == "return": game.calendar.story.battle_report = {"members":[{"name":"Jun","hp":12,"guard_received":8},{"name":"Lian","hp":0,"guard_received":2}]}
   game.story_ui(kind)
   await capture("story-"+kind.replace(":","-")+suffix)
  for id in ["H","J"]:
   var overlay = show_scene("study/overlay")
   overlay.setup(game,[id+"01"],id)
   overlay.finish()
   await capture("study-"+id+suffix)
  show_scene("combat/reward").setup(game)
  await capture("reward"+suffix)
  game.start_combat()
  game.battle.outcome = "victory"
  show_scene("combat/result").setup(game,"Jun rengaine sa lame.\n\nTu remportes le duel d’entraînement.")
  await capture("result"+suffix)
  show_scene("visitor/encounter").setup(game)
  await capture("visitor"+suffix)
  show_scene("spy/arrival").setup(game)
  await capture("spy"+suffix)
 game.sound.stop()
 game.sound.stream = null
 game.queue_free()
 await create_timer(0.2).timeout
 print("NARRATIVE UI PASS: 22 captures, isolated no persistence")
 quit()
