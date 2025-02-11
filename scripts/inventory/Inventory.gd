extends Control

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
