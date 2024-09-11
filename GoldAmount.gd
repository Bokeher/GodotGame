extends Label

func _ready():
	update_gold()

func update_gold():
	$".".text = str(Global.player_stats.gold) + " Gold"
