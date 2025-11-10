extends ScrollContainer

const upgrade_scene = preload("res://scenes/UpgradeTab.tscn")

func _ready() -> void:
	# remove placeholder upgrades
	var children = $VBoxContainer.get_children()
	for child in children:
		$VBoxContainer.remove_child(child)
		child.queue_free()
	
	for upgrade in Global.upgrades:
		var new_upgrade = upgrade_scene.instantiate()
		new_upgrade.set_meta("upgrade_id", upgrade.id)
		new_upgrade.get_node("Background/UpgradeName").text = upgrade.name
		new_upgrade.get_node("Background/UpgradeBonus").text = upgrade.description
		new_upgrade.get_node("Background/UpgradeButton").text = str(upgrade.cost)
		
		$VBoxContainer.add_child(new_upgrade)
