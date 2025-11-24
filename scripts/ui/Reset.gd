extends Button

func _pressed() -> void:
	# Has to be above all to then reset the unequip items from inventory 
	for child in $"../MainTabContainer/InventoryPanel/Inventory/EquipSlots".get_children():
		child.change_item(-1)
	
	Global.player = Player.new()
	Global.read_upgrades()
	Global.read_skills()
	Global.inventory = {}
	Global.bestiary = Bestiary.new()
	for item in Global.equipped_items:
		item = -1
	
	# Update upgrades
	var upgradeVBox := $"../MainTabContainer/UpgradesPanel/UpgradeContainer/VBoxContainer"
	for upgradeChild in upgradeVBox.get_children():
		upgradeChild.update_upgrade()
	
	# Update skills
	var skillTreePanel := $"../MainTabContainer/SkillsPanel/SkillTree/SkillScrollContainer/SkillTreePanel"
	for skillNode in skillTreePanel.get_children():
		skillNode.update_skill()
	
	# Update bestiary
	$"../MainTabContainer/BestiaryPanel/Bestiary".update_bestiary()
	
	$"../MainTabContainer/InventoryPanel/Inventory".update_inventory()
	
	
	$"../MainTabContainer/SkillsPanel/SkillTree".update_skill_points()
	$"../PlayerHealthBar".update_player_health_bar()
	$"../MainTabContainer/UpgradesPanel/GoldAmount".update_gold()
	$"../MainTabContainer/StatsPanel/Stats".update_stats()
