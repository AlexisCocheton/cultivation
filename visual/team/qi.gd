extends Control

func set_energy(value: int, recharge: int = 2) -> void:
	$Value.text = str(value)
	$Seal.modulate = Color(0.65,0.65,0.65) if value == 0 else Color.WHITE
	for i in range($Charges.get_child_count()):
		$Charges.get_child(i).visible = i < maxi(recharge,value)
		$Charges.get_child(i).modulate.a = 1.0 if i < value else 0.16
	tooltip_text = "Qi disponible : %d\nRecharge à %d au début de chaque tour." % [value,recharge]
