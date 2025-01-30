extends Control

func _ready():
	update_inventory()

func update_inventory() -> void:
	if Global.inventory.has(1):
		print(Global.inventory[1])
		$VBoxContainer/Item1.text = "Stick: " + str(Global.inventory[1])
