extends Button

func _pressed() -> void:
	Global.player_stats.damage = 1
	Global.player_stats.crit = 0
	Global.player_stats.speed = 1
	Global.player_stats.wisdom = 1
	Global.player_stats.luck = 1
	
	Global.player_stats.gold = 0
	Global.player_stats.max_stage_reached = 1
	
	Global.load_upgrade_stats()
	$"../Info/GoldAmount".update_gold()
	$"../Stats".update_stats()
