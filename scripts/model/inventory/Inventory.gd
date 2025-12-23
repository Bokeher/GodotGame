extends Resource
class_name Inventory

# <id, amount>
var items: Dictionary = {}
var equipment: Equipment = Equipment.new()

func add_item(itemData: ItemData) -> void:
	items[itemData.id] = items.get(itemData.id, 0) + 1

func add_items(items_: Array[ItemData]) -> void:
	for item in items_:
		add_item(item)

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
	
