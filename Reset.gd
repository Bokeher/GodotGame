extends Button

func _pressed():
	Global.player_stats.damage = 1
	Global.player_stats.gold = 0
	Global.load_upgrade_stats()
