extends Control

@onready var slot_id: int = $".".get_meta("id")
@onready var slot_type: int = $".".get_meta("slot_type")
@onready var selected_item_id: int = $".".get_meta("selected_item_id")

func _ready() -> void:
	update() # Update to show empty slot textures
	
	if Global.equipped_items.is_empty():
		return
	
	selected_item_id = Global.equipped_items[slot_id - 1]
	update()

func focus() -> void:
	$Border.color = Color(0.6, 0.6, 0.6)
	$Background.color = Color(0.3, 0.3, 0.3)

func unfocus() -> void:
	$Border.color = Color(0.30, 0.30, 0.30)
	$Background.color = Color(0.21, 0.21, 0.21)

func _on_slot_texture_pressed() -> void:
	Global.inventory_filter = slot_type
	Global.selected_equip_slot_id = slot_id
	$"../..".select_artifact_slot()
	$"../..".update_inventory()

func update():
	if slot_id == -1 or slot_type == -1:
		print("WARNING! Default equipped inventory slot")
	
	var texture_path: String = "res://assets/sprites/unknown.png"
	if selected_item_id == -1:
		texture_path = Enums.get_inventory_type_texture(slot_type)
	else:
		texture_path = Global.items[selected_item_id - 1].image_path
	
	$SlotTexture.texture_normal = load(texture_path)

func change_item(item_id) -> void:
	# Give back previously equipped item if needed
	if selected_item_id != -1:
		Global.inventory[selected_item_id] += 1
		var index = Global.equipped_items.find(selected_item_id)
		Global.equipped_items[index] = -1
	
	# Remove item from equipment unless this is an empty slot used for unequipping
	if !(item_id == -1 and !Global.inventory.has(item_id)):
		Global.inventory[item_id] -= 1
	
	# Change equipped item on this slot
	Global.equipped_items[slot_id - 1] = item_id
	
	selected_item_id = item_id
	
	$"../../".update_inventory()
	update()
