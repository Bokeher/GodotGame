extends Control

@onready var slot_id: int = $".".get_meta("id")
@onready var slot_type: int = $".".get_meta("slot_type")
@onready var selected_item_id: int = $".".get_meta("selected_item_id")

func _ready() -> void:
	update()

func focus() -> void:
	$Border.color = Color(0.38, 0.38, 0.38)
	$Background.color = Color(0.30, 0.30, 0.30)

func unfocus() -> void:
	$Border.color = Color(0.30, 0.30, 0.30)
	$Background.color = Color(0.21, 0.21, 0.21)

func _on_slot_texture_pressed() -> void:
	Global.inventory_filter = slot_type
	Global.selected_equip_slot_id = slot_id
	$"../../..".select_artifact_slot()
	$"../../..".update_inventory()

func update():
	if slot_id == -1 or slot_type == -1:
		print("WARNING! Default equipped inventory slot")
	
	var texture_path: String = "res://assets/sprites/unknown.png"
	if slot_type == Enums.InventoryType.ARTIFACT:
		texture_path = "res://assets/sprites/items/slots/artifact_slot.png"
	elif slot_type == Enums.InventoryType.CHEST:
		texture_path = "res://assets/sprites/items/slots/chest_slot.png"
	
	$SlotTexture.texture_normal = load(texture_path)

func change_item(item_id) -> void:
	selected_item_id = item_id
	update()
