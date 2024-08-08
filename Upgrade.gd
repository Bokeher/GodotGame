extends Button

func _pressed():
	if Global.clicks < 50:
		# TODO: show error 
		return
	
	$"../..".upgrade(50, 1)
