extends Control

@onready var this_slot_id: int = $".".get_meta("id")
@onready var this_slot_type: int = $".".get_meta("slot_type")

func _ready() -> void:
	if this_slot_id == -1 or this_slot_type == -1:
		print("WARNING! Default equipped inventory slot")
	
	var texture_path: String = "res://assets/sprites/unknown.png"
	if this_slot_type == Enums.InventoryType.ARTIFACT:
		texture_path = "res://assets/sprites/items/slots/artifact_slot.png"
	elif this_slot_type == Enums.InventoryType.CHEST:
		texture_path = "res://assets/sprites/items/slots/chest_slot.png"
		
	$SlotTexture.texture_normal = load(texture_path)

func focus() -> void:
	$Border.color = Color(0.38, 0.38, 0.38)
	$Background.color = Color(0.30, 0.30, 0.30)

func unfocus() -> void:
	$Border.color = Color(0.30, 0.30, 0.30)
	$Background.color = Color(0.21, 0.21, 0.21)

func _on_slot_texture_pressed() -> void:
	Global.inventory_filter = this_slot_type
	$"../../..".select_artifact_slot(this_slot_id)
	$"../../..".update_inventory()
