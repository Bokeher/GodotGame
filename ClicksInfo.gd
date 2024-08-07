extends Label

func _ready():
	$".".text = str(Global.clicks) + " clicks"
