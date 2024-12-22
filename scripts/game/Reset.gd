extends Button

func _pressed() -> void:
	Global.player_stats = PlayerStats.new()
	$"../PlayerHealthBar".update_player_health_bar()
	
	Global.load_upgrade_stats()
	$"../MainTabContainer/Panel/GoldAmount".update_gold()
	$"../MainTabContainer/Stats".update_stats()
