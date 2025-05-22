extends Control

@onready var children = $ArtifactsPanel/ArtifactSlots.get_children()
@onready var ItemContainer = $ArtifactsPanel/ItemContainer
var last_selected_artifact_slot_id = -1
const inventory_item_scene = preload("res://scenes/inventory/InventoryItem.tscn")

func _ready() -> void:
	update_inventory()

func update_inventory() -> void:
	# Remove all children
	for child in ItemContainer.get_children():
		ItemContainer.remove_child(child)
	
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

func select_artifact_slot() -> void:
	# Clicked the same slot second time [Deselect action]
	if last_selected_artifact_slot_id == Global.selected_equip_slot_id:
		last_selected_artifact_slot_id = Global.selected_equip_slot_id
		Global.selected_equip_slot_id = -1
		Global.inventory_filter = Enums.InventoryType.NONE
	
	#TODO: here handle changing artifacts
	
	# Focus / Unfocus if not default value (default value = -1)
	if Global.selected_equip_slot_id != -1: 
		children[Global.selected_equip_slot_id - 1].focus()
	if last_selected_artifact_slot_id != -1:
		children[last_selected_artifact_slot_id - 1].unfocus()
	
	last_selected_artifact_slot_id = Global.selected_equip_slot_id
