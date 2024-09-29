extends Button

func _pressed():
	Global.player_stats.damage = 1
	Global.player_stats.gold = 0
	Global.load_upgrade_stats()
	
	$"../Info/GoldAmount".update_gold()
	$"../Info/DamageInfo".update_damage()
	$"../Stats".update_stats()
