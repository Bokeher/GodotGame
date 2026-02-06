extends Control

@onready var inventory: Inventory = GameManager.player.inventory
const inventory_item_scene = preload("res://scenes/inventory/InventoryItem.tscn")

func _ready() -> void:
	inventory.item_added.connect(_on_item_added)
	inventory.item_removed.connect(_on_item_removed)
	_build_inventory_ui()

func _on_item_added(item_data: ItemData, _delta: int, total: int) -> void:
	_update_item_view(item_data, total)

func _on_item_removed(item_data: ItemData, _delta: int, total: int) -> void:
	_update_item_view(item_data, total)

func _update_item_view(item_data: ItemData, total: int) -> void:
	for inventory_item_view: InventoryItemView in $ItemContainer.get_children():
		if inventory_item_view.item.id == item_data.id:
			if total <= 0:
				inventory_item_view.queue_free()
			else:
				inventory_item_view.update_count(total)
			
			return
	
	if total > 0:
		_create_inventory_slot(item_data, total)
		return
	
	print("INFO | Item not found => rebuilding entire inventory")
	_build_inventory_ui()

func _build_inventory_ui() -> void:
	_clear_ui()
	
	for item_id: int in inventory.get_sorted():
		var count = inventory.items[item_id]
		if count <= 0:
			continue
		
		var item: ItemData = ItemDatabase.get_by_id(item_id)
		_create_inventory_slot(item, count)

func _clear_ui() -> void:
	for inventory_item_view: InventoryItemView in $ItemContainer.get_children():
		$ItemContainer.remove_child(inventory_item_view)

func _create_inventory_slot(item: ItemData, count: int) -> void:
	var inventory_item_view: InventoryItemView = inventory_item_scene.instantiate()
	inventory_item_view.setup(item, count)
	
	$ItemContainer.add_child(inventory_item_view)
