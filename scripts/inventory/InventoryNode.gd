extends Control

@onready var inventory: Inventory = GameManager.player.inventory
const inventory_item_scene = preload("res://scenes/inventory/InventoryItem.tscn")

func _ready() -> void:
	inventory.inventory_changed.connect(_on_inventory_changed)
	_build_inventory_ui()

func _on_inventory_changed() -> void:
	_build_inventory_ui()

func _build_inventory_ui() -> void:
	_clear_ui()
	
	for item_id: int in inventory.items:
		var count = inventory.items[item_id]
		if count <= 0:
			continue
		
		var item: ItemData = ItemDatabase.get_by_id(item_id)
		_create_inventory_slot(item, count)

func _clear_ui() -> void:
	for inventory_item_view in $ItemContainer.get_children():
		$ItemContainer.remove_child(inventory_item_view)

func _create_inventory_slot(item: ItemData, count: int) -> void:
	var inventory_item_view: InventoryItemView = inventory_item_scene.instantiate()
	inventory_item_view.setup(item, count)
	
	$ItemContainer.add_child(inventory_item_view)
