extends Control

@onready var childs = $ArtifactSlots.get_children()
var last_selected_artifact_slot_id = -1

func _ready() -> void:
	update_inventory()

func update_inventory() -> void:
	# Remove all children
	for child in $VBoxContainer.get_children():
		if(child.text == "Empty inventory"): continue
		
		$VBoxContainer.remove_child(child)
	
	# Add items
	for item_id in Global.inventory:
		var label = Label.new()
		var item_name = Global.items[item_id - 1].name
		
		label.text = item_name + ": " + str(Global.inventory[item_id])
		$VBoxContainer.add_child(label)
	
	var isEmptyInventoryInfoShown: bool = true
	if($VBoxContainer.get_children().size() > 1):
		isEmptyInventoryInfoShown = false
		
	$VBoxContainer/EmptyInventoryInfo.visible = isEmptyInventoryInfoShown

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
