extends Button

const HEADS = preload("res://assets/team/chibi-heads.png")
const SWORD = preload("res://visual/team/intent-sword.svg")
const SHIELD = preload("res://visual/team/intent-shield.svg")
const POISON = preload("res://visual/team/poison.svg")
const PILL = preload("res://visual/team/pill.svg")

static func head(index: int) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	if index == 6:
		atlas.atlas = preload("res://assets/hub/portraits.png")
		var extent = atlas.atlas.get_size()/Vector2(3,2)
		atlas.region = Rect2(Vector2(extent.x*2,0),extent)
		return atlas
	atlas.atlas = HEADS
	var cell = HEADS.get_size()/Vector2(3,2)
	atlas.region = Rect2(Vector2(index%3,int(index/3))*cell+Vector2(0,70),cell-Vector2(0,125))
	return atlas

func present(battle, index: int, selectable: bool) -> void:
	var unit: Dictionary = battle.units[index]
	$Actor.configure(index,unit.appearance)
	$Actor.set_guard(unit.guard if unit.hp > 0 else 0)
	$Actor.downed = unit.hp <= 0
	$Actor.enraged = unit.enraged
	$Actor.poisoned = unit.poison > 0
	$Name.text = unit.name
	$HP.max_value = unit.max_hp
	$HP.value = unit.hp
	$HP.tint_progress = Color("518f91") if unit.guard > 0 and unit.hp > 0 else Color("c22e31")
	$GuardBadge.tooltip_text = "Garde : absorbe les dégâts avant les PV. " + ("Dure pendant ta prochaine phase de cartes." if index >= 3 else "Expire après les attaques adverses.") + " Le poison l’ignore."
	$GuardBadge.visible = unit.guard > 0 and unit.hp > 0
	$GuardBadge/Value.text = str(unit.guard)
	$Health.text = "%d/%d" % [unit.hp,unit.max_hp]
	set_marker(unit.hp > 0 and index == battle.actor and not battle.resolving,selectable,index >= 3)
	var intent: Dictionary = unit.intent
	$Intent.visible = not intent.is_empty()
	$Status.text = "Poison %d" % unit.poison if unit.poison > 0 else ""
	if index == 4 and battle.coated: $Status.text = "Dagues enduites"
	$Fury.visible = unit.enraged and unit.hp > 0
	$Name.offset_right = 130 if $Fury.visible else 188
	if unit.hp <= 0: $Status.text = ""
	if not intent.is_empty():
		$Intent/Icon.texture = {"attack":SWORD,"guard":SHIELD,"coat":POISON,"poison":SWORD,"recover":PILL}[intent.kind]
		$Intent/Value.text = "" if intent.kind == "recover" else str(intent.value)
		$Intent/Target/Head.texture = head(battle.units[intent.target].appearance)
		$Intent/Poison.visible = intent.get("poison",0) > 0
		$Intent/PoisonValue.visible = $Intent/Poison.visible
		$Intent/PoisonValue.text = str(intent.get("poison",0))
		$Intent.modulate.a = 1.0 if unit.hp > 0 and battle.units[intent.target].hp > 0 else 0.3
		tooltip_text = "%s : %s %d → %s" % [unit.name,"attaque" if intent.kind == "attack" else ("attaque" if intent.kind == "poison" else "garde"),intent.value,battle.units[intent.target].name]
		if intent.kind == "coat": tooltip_text = "Enduit ses dagues. Dès la prochaine manche : %d dégâts directs + autant de poison. La garde absorbe seulement les dégâts directs." % int(ceil(battle.POISON_DOSE * (1.5 if unit.enraged else 1.0)))
		elif intent.kind == "recover": tooltip_text = "Absorbe la pilule : aucune action cette manche, attaques +50 % dès la suivante."
		elif intent.kind == "poison": tooltip_text += " · +%d poison, même si la garde bloque le coup. Cumul sans plafond." % intent.poison
		if unit.hp <= 0 or battle.units[intent.target].hp <= 0: tooltip_text += " · action annulée"
	else: tooltip_text = unit.name + " · sélectionne son portrait pour jouer ses cartes"
	if unit.poison > 0: tooltip_text += "\nPoison : %d dégâts en fin de manche, ignore la garde, puis diminue de 1." % unit.poison
	if unit.enraged: tooltip_text += "\nFurie : +50 % d’attaque (inclus)."
	if unit.hp <= 0: $Health.text = "Hors combat"
	$Health.add_theme_font_size_override("font_size",15 if unit.hp <= 0 else 19)

func set_marker(active: bool, target: bool, enemy: bool = false) -> void:
	$Select.visible = active or target
	$Select.modulate = Color("df5646") if target and enemy else Color("f5e7bd")
	$Select.modulate.a = 1.0 if active else 0.28

func _make_custom_tooltip(for_text: String) -> Object:
	var tip = preload("res://visual/team/unit_tooltip.tscn").instantiate()
	tip.get_node("Text").text = for_text
	return tip
