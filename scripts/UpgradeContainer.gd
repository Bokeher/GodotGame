extends ScrollContainer

const upgrade_scene = preload("res://scenes/Upgrade.tscn")

func _ready() -> void:
	# remove placeholder upgrades
	var childs = $VBoxContainer.get_children()
	for child in childs:
		$VBoxContainer.remove_child(child)
	
	for upgrade in Global._upgrades:
		var new_upgrade = upgrade_scene.instantiate()
		new_upgrade.get_node("Background/UpgradeName").text = upgrade.name
		new_upgrade.get_node("Background/UpgradeBonus").text = upgrade.description
		new_upgrade.get_node("Background/UpgradeButton").text = str(upgrade.cost)
		new_upgrade.get_node("Background/UpgradeId").text = str(upgrade.id)
		
		$VBoxContainer.add_child(new_upgrade)
