extends Button

func _pressed():
	Global.clicks += 1
	$"../Label".text = str(Global.clicks) + " clicks"
