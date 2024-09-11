extends Label

func _ready():
	update_damage()

func update_damage():
	$".".text = str(Global.player_stats.damage) + " damage"
