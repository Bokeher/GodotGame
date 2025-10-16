extends Control

@onready var children = $EquipSlots.get_children()
@onready var ItemContainer = $ItemContainer
const inventory_item_scene = preload("res://scenes/inventory/InventoryItem.tscn")

func _ready() -> void:
	update_inventory()

func update_inventory() -> void:
	# Remove all children
	for child in ItemContainer.get_children():
		ItemContainer.remove_child(child)
	
	# Prevent items from being added
	if Global.inventory.is_empty() or !ItemContainer or Global.selected_equip_slot_id == -1:
		return
	
	# Add empty slot
	var empty_item_scene = inventory_item_scene.instantiate()
	empty_item_scene.set_meta("item_id", -1)
	ItemContainer.add_child(empty_item_scene)
	
	# Add items
	for item_id in Global.inventory:
		var item = Global.items[item_id - 1]
		var type = item.type
		
		# Skip this iteration if item type is different than filter
		if type != Global.inventory_filter or Global.inventory_filter == Enums.InventoryType.NONE:
			continue
		
		var count = Global.inventory[item_id]
		if count <= 0:
			continue
		
		var item_scene = inventory_item_scene.instantiate()
		item_scene.set_meta("item_id", item.id)
		item_scene.set_count(count)
		
		ItemContainer.add_child(item_scene)

func select_slot() -> void:
	var current_slot := Global.selected_equip_slot_id
	var last_slot := Global.last_selected_equip_slot_id
	
	# If the same slot is clicked again → deselect it
	if current_slot == last_slot:
		Global.selected_equip_slot_id = -1
		Global.inventory_filter = Enums.InventoryType.NONE
	else:
		# Unfocus the previously selected slot (if valid)
		if last_slot != -1:
			children[last_slot - 1].unfocus()
		
		# Focus the newly selected slot (if valid)
		if current_slot != -1:
			children[current_slot - 1].focus()
	
	# Update last selected slot
	Global.last_selected_equip_slot_id = Global.selected_equip_slot_id

func _on_unequip_all_button_pressed() -> void:
	for equip_slot in $EquipSlots.get_children():
		equip_slot.change_item(-1)
	
	update_inventory()
