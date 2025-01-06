extends Button

func _pressed() -> void:
	Global.player_stats = PlayerStats.new()
	$"../PlayerHealthBar".update_player_health_bar()
	
	#TODO: re-read here upgrade stats and skills
	$"../MainTabContainer/UpgradesPanel/GoldAmount".update_gold()
	$"../MainTabContainer/StatsPanel/Stats".update_stats()
