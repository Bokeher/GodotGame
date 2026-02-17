extends Control

@onready var inventory: Inventory = GameManager.player.inventory
const inventory_item_scene = preload("res://scenes/inventory/InventoryItem.tscn")
const equipment_scene = preload("res://scenes/inventory/EquippedInventorySlot.tscn")

var selected_slot: Equipment.EquipmentSlotId
var item_views: Dictionary[int, InventoryItemView] = {}

func _ready() -> void:
	inventory.item_added.connect(_on_item_added)
	inventory.item_removed.connect(_on_item_removed)
	_build_inventory_ui()
	_build_equipment_ui()

func _build_equipment_ui() -> void:
	for slot_id in inventory.equipment.get_slots():
		var scene: EquipmentSlot = equipment_scene.instantiate()
		scene.setup(slot_id)
		scene.pressed.connect(on_equiment_slot_selected)
		$EquipSlots.add_child(scene)

func on_equiment_slot_selected(slot_id: Equipment.EquipmentSlotId) -> void:
	selected_slot = slot_id

func _on_item_added(item_data: ItemData, _delta: int, total: int) -> void:
	_update_item_view(item_data, total)

func _on_item_removed(item_data: ItemData, _delta: int, total: int) -> void:
	_update_item_view(item_data, total)

func _update_item_view(item_data: ItemData, total: int) -> void:
	var id = item_data.id
	
	if item_views.has(id):
		var item_view = item_views[id]
		
		if total <= 0:
			item_view.queue_free()
			item_views.erase(id)
		else:
			item_view.update_count(total)
		
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
	for item_view: InventoryItemView in item_views.values():
		item_view.queue_free()
	
	item_views = {}

func _create_inventory_slot(item: ItemData, count: int) -> void:
	var inventory_item_view: InventoryItemView = inventory_item_scene.instantiate()
	inventory_item_view.setup(item, count)
	
	item_views[item.id] = inventory_item_view
	
	var index: int = _find_insert_index_binary(item.id)
	$ItemContainer.add_child(inventory_item_view)
	$ItemContainer.move_child(inventory_item_view, index)

func _find_insert_index_binary(new_id: int) -> int:
	var container: HBoxContainer = $ItemContainer
	var left: int = 0
	var right: int = container.get_child_count()
	
	while left < right:
		var mid: int = floor(float(left + right) / 2)
		var mid_view: InventoryItemView = container.get_child(mid)
		
		if mid_view.item.id < new_id:
			left = mid + 1
		else:
			right = mid
	
	return left

func select_equipment_slot(slot_id: Equipment.EquipmentSlotId) -> void:
	selected_slot = slot_id
