extends Button

func _pressed() -> void:
	Global.player_stats = Player.new()
	Global.read_upgrades()
	Global.read_skills()
	Global.inventory = {}
	
	# Update upgrades
	var upgradeVBox = $"../MainTabContainer/UpgradesPanel/UpgradeContainer/VBoxContainer"
	for upgradeChild in upgradeVBox.get_children():
		upgradeChild.update_upgrade()
	
	# Update skills
	var skillTreePanel = $"../MainTabContainer/SkillsPanel/SkilTree/SubViewportContainer/SubViewport/SkillTreePanel"
	for skillNode in skillTreePanel.get_children():
		skillNode.update_skill()
	
	$"../MainTabContainer/InventoryPanel/Inventory".update_inventory()
	
	$"../MainTabContainer/SkillsPanel/SkillPointsAmount".update_skill_points()
	$"../PlayerHealthBar".update_player_health_bar()
	$"../MainTabContainer/UpgradesPanel/GoldAmount".update_gold()
	$"../MainTabContainer/StatsPanel/Stats".update_stats()
