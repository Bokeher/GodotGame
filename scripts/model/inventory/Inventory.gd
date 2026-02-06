extends Resource
class_name Inventory

signal item_added(item_data: ItemData, delta: int, total: int)
signal item_removed(item_data: ItemData, delta: int, total: int)
signal inventory_changed

# <id, amount>
var items: Dictionary[int, int] = {}
var equipment: Equipment = Equipment.new()

func add_item(itemData: ItemData) -> void:
	items[itemData.id] = items.get(itemData.id, 0) + 1
	item_added.emit(itemData, 1, items[itemData.id])
	inventory_changed.emit()

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
	
	item_removed.emit(itemData, items[itemData.id])
	inventory_changed.emit()

func get_sorted() -> Dictionary[int, int]:
	var sorted_dict: Dictionary[int, int] = {}
	var keys: Array[int] = items.keys()
	keys.sort()
	
	for key: int in keys:
		sorted_dict[key] = items[key]
	
	return sorted_dict
