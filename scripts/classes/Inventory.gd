extends Object
class_name Inventory

# <id, amount>
var items: Dictionary = {}

func add_item(itemData: ItemData) -> void:
	items[itemData.id] = items.get(itemData.id, 0) + 1

func remove_item(itemData: ItemData) -> void:
	if not items.has(itemData.id):
		print("WARNING! Item not found in inventory")
		return
	
	if items[itemData.id] < 1:
		print("WARNING! Tried to remove unowned item")
		return
	
	items[itemData.id] -= 1
	
	if items[itemData.id] == 0:
		items.erase(itemData.id)
	
