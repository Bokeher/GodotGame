extends Control

@onready var childs = $ArtifactsPanel/ArtifactSlots.get_children()
var last_selected_artifact_slot_id = -1
const inventory_item_scene = preload("res://scenes/inventory/InventoryItem.tscn")
@onready var ItemContainer = $ArtifactsPanel/ItemContainer

func _ready() -> void:
	update_inventory()

func update_inventory() -> void:
	# Remove all children
	for child in ItemContainer.get_children():
		if(child.text == "Empty inventory"): continue
		
		ItemContainer.remove_child(child)
	
	# Add items
	for item_id in Global.inventory:
		var item_scene = inventory_item_scene.instantiate()
		var item_name = Global.items[item_id - 1].name
		
		item_scene.get_node("./Count")
		
		ItemContainer.add_child(item_scene)
	
	var isEmptyInventoryInfoShown: bool = true
	if(ItemContainer.get_children().size() > 1):
		isEmptyInventoryInfoShown = false
		
	ItemContainer.get_node("EmptyInventoryInfo").visible = isEmptyInventoryInfoShown

func select_artifact_slot(selected_slot_id: int) -> void:
	if last_selected_artifact_slot_id == selected_slot_id:
		last_selected_artifact_slot_id = selected_slot_id
		selected_slot_id = -1
	
	#TODO: here handle changing artifacts
	
	if selected_slot_id != -1: 
		childs[selected_slot_id - 1].focus()
	if last_selected_artifact_slot_id != -1:
		childs[last_selected_artifact_slot_id - 1].unfocus()
	
	last_selected_artifact_slot_id = selected_slot_id
