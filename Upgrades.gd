extends Node2D

const upgrade_scene = preload("res://scenes/Upgrade.tscn")

func _ready():
	for upgrade in Global._upgrades:
		var new_upgrade = upgrade_scene.instantiate()
		new_upgrade.get_node("Background/UpgradeName").text = upgrade.name
		new_upgrade.get_node("Background/UpgradeBonus").text = upgrade.description
		new_upgrade.get_node("Background/UpgradeButton").text = str(upgrade.cost)
		
		$VBoxContainer.add_child(new_upgrade)
