extends Control

@onready var slot_id: int = $".".get_meta("id")
@onready var slot_type: int = $".".get_meta("slot_type")
@onready var selected_item_id: int = $".".get_meta("selected_item_id")
@onready var popup: GlobalPopup = get_node("/root/Game/Popup")

func _ready() -> void:
	update() # Update to show empty slot textures
	
	if Global.equipped_items.is_empty():
		return
	
	selected_item_id = Global.equipped_items[slot_id - 1]
	update()

func focus() -> void:
	$Border.color = Enums.Colors["BORDER_FOCUS_HOVER"]
	$Background.color = Enums.Colors["BG_FOCUS_HOVER"]

func unfocus() -> void:
	$Border.color = Enums.Colors["BORDER_UNFOCUS_HOVER"]
	$Background.color = Enums.Colors["BG_UNFOCUS_HOVER"]

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
	if !Global.inventory.has(item_id) && item_id != -1:
		print("WARNING! Somehow tried to equip not owned item")
		return
	
	# Give back previously equipped item if needed
	if selected_item_id != -1:
		Global.inventory[selected_item_id] = Global.inventory.get(selected_item_id, 0) + 1
		Global.equipped_items[Global.last_selected_equip_slot_id - 1] = -1
	
	# Remove item from equipment unless this is an empty slot used for unequipping
	if !(item_id == -1 and !Global.inventory.has(item_id)):
		Global.inventory[item_id] -= 1
	
	# Change equipped item on this slot
	Global.equipped_items[slot_id - 1] = item_id
	
	selected_item_id = item_id
	
	$"../../".update_inventory()
	update()

func _on_slot_texture_mouse_entered() -> void:
	var id: int = Global.equipped_items[slot_id - 1]
	
	if id == -1:
		popup.popup("Empty slot", "Press to change")
		return
	
	var item: Item = Global.items[id - 1]
	popup.popup(item.name, item.description)

func _on_slot_texture_mouse_exited() -> void:
	popup.hide_()
