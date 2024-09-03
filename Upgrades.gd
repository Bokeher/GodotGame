extends Node2D

const upgrade_scene = preload("res://scenes/Upgrade.tscn")

func _ready():
	for upgrade in Global._upgrades:
		var new_upgrade = upgrade_scene.instantiate()
		new_upgrade.get_node("Background/Effect").text = upgrade.name
		$VBoxContainer.add_child(new_upgrade)
