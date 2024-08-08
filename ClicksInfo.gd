extends Label

func _ready():
	update_clicks()

func update_clicks():
	$".".text = str(Global.clicks) + " clicks"
