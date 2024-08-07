extends Button

func _pressed():
	Global.clicks += Global.damage
	$"../ClicksInfo".text = str(Global.clicks) + " clicks"
	
