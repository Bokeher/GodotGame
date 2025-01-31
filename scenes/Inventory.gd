extends Control

func _ready():
	update_inventory()

func update_inventory() -> void:
	$VBoxContainer/Item1.text = "Stick: " + str(Global.inventory.get(1, 0))
