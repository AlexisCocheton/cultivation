extends Node2D

const SOURCE = preload("res://assets/manhua_combat.png")
const EXPORT = preload("res://tests/spriteforge/export/godot/recruit_attack.tres")
const DURATIONS = [0.15,0.10,0.16,0.15]
var original: Sprite2D
var processed: AnimatedSprite2D
var paused = false
var elapsed = 0.0
var zoomed = false
var phase = 0
var info: Label

func _ready() -> void:
	original = Sprite2D.new()
	original.texture = SOURCE
	original.hframes = 4
	original.vframes = 4
	original.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	original.position = Vector2(320,545)
	original.offset = Vector2(0,SOURCE.get_height()/8.0-300)
	add_child(original)
	processed = AnimatedSprite2D.new()
	processed.sprite_frames = EXPORT
	processed.animation = "attack"
	processed.centered = false
	processed.offset = Vector2(-163.75,-300)
	processed.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	processed.position = Vector2(960,545)
	add_child(processed)
	caption("ATTAQUE DE LA RECRUE — COMPARATIF SPRITE FORGE",Vector2(30,22),28)
	caption("Même dessin • 4 poses • 560 ms • contact à 250 ms • aucun appel payant",Vector2(30,66),19)
	caption("A  /  DÉCOUPAGE ACTUEL",Vector2(70,135),25)
	caption("B  /  TRAITEMENT SPRITE FORGE",Vector2(710,135),25)
	caption("Cellules régulières de la planche originale",Vector2(70,177),18)
	caption("Alpha nettoyé, découpage par personnage, export Godot",Vector2(710,177),18)
	caption("La pose 3 déborde de sa cellule : pied coupé\net fragment dans la pose 2.",Vector2(70,592),19)
	caption("91 pixels récupérés sur la pose 3.\nAucune pose intermédiaire créée.",Vector2(710,592),19)
	info = caption("",Vector2(40,674),21)
	make_button("Pause / lecture",Vector2(40,728),func(): paused = not paused)
	make_button("Pose suivante",Vector2(290,728),func(): paused = true; phase = (phase+1)%4; elapsed = 0.0; for i in range(phase): elapsed += DURATIONS[i]; show_frame())
	make_button("Taille jeu / ×2",Vector2(540,728),func(): zoomed = not zoomed; update_zoom())
	make_button("Rejouer",Vector2(790,728),func(): elapsed = 0; paused = false)
	update_zoom()
	show_frame()

func caption(value: String, pos: Vector2, font_size: int) -> Label:
	var node = Label.new()
	node.text = value
	node.position = pos
	node.add_theme_font_size_override("font_size",font_size)
	node.add_theme_color_override("font_color",Color("e7e1d2"))
	add_child(node)
	return node

func make_button(value: String, pos: Vector2, callback: Callable) -> void:
	var node = Button.new()
	node.text = value
	node.position = pos
	node.size = Vector2(220,48)
	node.pressed.connect(callback)
	add_child(node)

func update_zoom() -> void:
	var factor = (92.0/(SOURCE.get_height()/4.0))*2.1*(2.0 if zoomed else 1.0)
	original.scale = Vector2.ONE*factor
	processed.scale = original.scale

func _process(delta: float) -> void:
	if not paused:
		elapsed = fmod(elapsed+delta,1.3)
		var cursor = 0.0
		phase = 3
		for i in range(4):
			cursor += DURATIONS[i]
			if elapsed < cursor:
				phase = i
				break
	show_frame()

func show_frame() -> void:
	original.frame = phase
	processed.frame = phase
	info.text = "Pose %d / 4 · %s · %s" % [phase+1,["Préparation","Armement","Frappe / contact","Récupération"][phase],"PAUSE" if paused else "LECTURE"]
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(20,115,600,540),Color("182d37"))
	draw_rect(Rect2(660,115,600,540),Color("182d37"))
	for x in [320,960]:
		draw_line(Vector2(x-260,545),Vector2(x+260,545),Color("9da985"),1)
		draw_line(Vector2(x,220),Vector2(x,565),Color("34525b"),1)
