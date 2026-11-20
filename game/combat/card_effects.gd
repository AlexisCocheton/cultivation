extends RefCounted
# Effect kinds describe behaviour; card IDs never enter this resolver.
static func cost(card: Dictionary, member) -> int:
	var value: int = card.cost
	for effect in card.get("effects",[]):
		if effect.kind == "cost_if_deck" and member.deck.initial_size >= effect.threshold: value = int(effect.amount)
	return value

static func damage(card: Dictionary, member, target) -> int:
	var value: int = card.damage
	for effect in card.get("effects",[]):
		match effect.kind:
			"damage_combo":
				if member.played >= effect.threshold: value = int(effect.amount)
			"damage_per_deck": value += maxi(0,member.deck.initial_size-int(effect.threshold))*int(effect.amount)
	if value > 0:
		value += member.bonus + member.strength
		if target.state.exposed: value = int(floor(value*1.5))
	return value

static func apply_play(card: Dictionary, member, target) -> void:
	for effect in card.get("effects",[]):
		match effect.kind:
			"expose": target.state.exposed = true
			"bonus": member.bonus += int(effect.amount)
			"hand_limit": member.deck.hand_limit += int(effect.amount)
			"energy": member.energy = mini(int(effect.get("cap",5)),member.energy+int(effect.amount))
			"heal": member.state.hp = mini(member.state.max_hp,member.state.hp+int(effect.amount))
			"self_damage": member.state.hp = maxi(0,member.state.hp-int(effect.amount))
	member.deck.draw_cards(card.draw)
	for effect in card.get("effects",[]):
		match effect.kind:
			"damage_combo":
				if member.played >= effect.threshold: member.deck.draw_cards(int(effect.get("draw",0)))
			"draw_if_exposed":
				if target.state.exposed: member.deck.draw_cards(int(effect.amount))

static func begin_turn(member, base_draw: int) -> void:
	var extra_draw = 0
	for id in member.deck.active:
		for effect in member.cards[id].get("effects",[]):
			match effect.kind:
				"turn_strength": member.strength += int(effect.amount)
				"turn_draw": extra_draw += int(effect.amount)
	member.deck.draw_cards(base_draw+extra_draw)

static func bot_bonus(card: Dictionary, member) -> float:
	var value = 4.0 if card.persistent else 0.0
	for effect in card.get("effects",[]):
		match effect.kind:
			"expose": value += 5.0 if member.energy >= 2 else 0.0
			"bonus": value += float(effect.amount)*1.5 if member.energy >= 1 else 0.0
			"energy": value += float(effect.amount)*6.0
			"heal": value += mini(int(effect.amount),member.state.max_hp-member.state.hp)*1.2
			"self_damage": value -= float(effect.amount)*1.25
	return value

static func survives_play(card: Dictionary, member) -> bool:
	var hp: int = member.state.hp
	for effect in card.get("effects",[]):
		match effect.kind:
			"heal": hp = mini(member.state.max_hp,hp+int(effect.amount))
			"self_damage": hp = maxi(0,hp-int(effect.amount))
	return hp > 0

static func tr_text(text: String) -> String: return String(TranslationServer.translate(text))

static func describe(card: Dictionary) -> String:
	var parts: Array[String] = []
	if card.damage: parts.append(tr_text("%d dégâts") % card.damage)
	if card.block: parts.append(tr_text("%d garde") % card.block)
	if card.draw: parts.append(tr_text("pioche %d") % card.draw)
	var persistent: Array[String] = []
	for effect in card.get("effects",[]):
		match effect.kind:
			"bonus": parts.append(tr_text("prochaine attaque +%d") % effect.amount)
			"turn_strength": persistent.append(tr_text("+%d Force par tour suivant") % effect.amount)
			"hand_limit":
				if card.persistent: persistent.append(tr_text("main +%d") % effect.amount)
				else: parts.append(tr_text("main +%d") % effect.amount)
			"turn_draw": persistent.append(tr_text("pioche +%d par tour suivant") % effect.amount)
			"damage_per_deck": parts.append(tr_text("+%d dégât par carte au-delà de %d dans le deck initial") % [effect.amount,effect.threshold])
			"cost_if_deck": parts.append(tr_text("coûte %d qi si deck initial de %d cartes ou plus") % [effect.amount,effect.threshold])
			"expose": parts.append(tr_text("Ennemi Exposé : il reçoit +50 % de dégâts ce tour"))
			"self_damage": parts.append(tr_text("perd %d PV") % effect.amount)
			"damage_combo":
				if int(effect.get("draw",0)) > 0: parts.append(tr_text("combo : %d dégâts et pioche %d") % [effect.amount,effect.draw])
				else: parts.append(tr_text("combo %d cartes : %d dégâts") % [effect.threshold,effect.amount])
			"energy": parts.append(tr_text("+%d qi") % effect.amount)
			"heal": parts.append(tr_text("soigne %d PV") % effect.amount)
			"draw_if_exposed": parts.append(tr_text("pioche %d si cible Exposée") % effect.amount)
	if not persistent.is_empty(): parts.append(tr_text("Persistante : ")+" ; ".join(persistent))
	if card.exhaust: parts.append(tr_text("retirée après usage jusqu'au prochain combat"))
	return " · ".join(parts)

static func compact_description(card: Dictionary) -> String:
	var text = describe(card).replace(tr_text("retirée après usage jusqu'au prochain combat"),tr_text("Épuisement"))
	for effect in card.get("effects",[]):
		match effect.kind:
			"damage_per_deck":
				text = tr_text("%d + %d × (deck −%d) dégâts\nTaille initiale") % [card.damage,effect.amount,effect.threshold]
			"cost_if_deck":
				text = tr_text("Pioche %d\n%d Qi si deck initial ≥%d") % [card.draw,effect.amount,effect.threshold]
	return text.replace(" · Persistante : ","\n"+tr_text("Persistante : "))
