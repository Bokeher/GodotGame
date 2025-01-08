extends Button

func _pressed() -> void:
	Global.player_stats = PlayerStats.new()
	Global.read_upgrades()
	Global.read_skills()
	
	# Update upgrades
	var upgradeVBox = $"../MainTabContainer/UpgradesPanel/UpgradeContainer/VBoxContainer"
	for upgradeChild in upgradeVBox.get_children():
		upgradeChild.update_upgrade()
	
	# TODO: Update skills
	
	$"../PlayerHealthBar".update_player_health_bar()
	$"../MainTabContainer/UpgradesPanel/GoldAmount".update_gold()
	$"../MainTabContainer/StatsPanel/Stats".update_stats()
