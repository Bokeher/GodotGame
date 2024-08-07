extends Button

func _pressed():
	if Global.clicks < 50:
		# TODO: show error 
		return
	
	Global.clicks -= 50
	
	Global.damage += 1
	$"../DamageInfo".text = str(Global.damage) + " damage"
