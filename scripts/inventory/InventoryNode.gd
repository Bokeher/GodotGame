extends Control

@onready var inventory: Inventory = GameManager.player.inventory
const inventory_item_scene = preload("res://scenes/inventory/InventoryItem.tscn")
const equipment_scene = preload("res://scenes/inventory/EquippedInventorySlot.tscn")

var selected_slot: Equipment.EquipmentSlotId
var item_views: Dictionary[int, InventoryItemView] = {}

var current_filter: ItemData.ItemType = ItemData.ItemType.NONE

signal selected_slot_changed(slot: Equipment.EquipmentSlotId)

func _ready() -> void:
	inventory.item_added.connect(_on_item_added)
	inventory.item_removed.connect(_on_item_removed)
	_build_inventory_ui()
	_build_equipment_ui()

func _build_equipment_ui() -> void:
	for slot_id in inventory.equipment.get_slots():
		var scene: EquipmentSlot = equipment_scene.instantiate()
		scene.setup(slot_id, selected_slot_changed)
		scene.pressed.connect(on_equipment_slot_selected)
		$EquipSlots.add_child(scene)

func set_filter(item_type: ItemData.ItemType) -> void:
	current_filter = item_type
	_build_inventory_ui()

func on_equipment_slot_selected(slot_id: Equipment.EquipmentSlotId) -> void:
	selected_slot = slot_id
	selected_slot_changed.emit(selected_slot)
	set_filter(Equipment.get_item_type_for_slot(slot_id))

func _on_item_added(item_data: ItemData, _delta: int, total: int) -> void:
	_update_item_view(item_data, total)

func _on_item_removed(item_data: ItemData, _delta: int, total: int) -> void:
	_update_item_view(item_data, total)

func _update_item_view(item_data: ItemData, total: int) -> void:
	if !check_filter(item_data.type):
		return
	
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
		
		if !check_filter(item.type):
			continue
		
		_create_inventory_slot(item, count)

func check_filter(item_type: ItemData.ItemType) -> bool:
	return current_filter == ItemData.ItemType.NONE or current_filter == item_type

func _clear_ui() -> void:
	for item_view: InventoryItemView in item_views.values():
		item_view.queue_free()
	
	item_views = {}

func on_item_pressed(item: ItemData) -> void:
	if Equipment.slot_accepts_item(selected_slot, item.type):
		inventory.equipment.equip_item(selected_slot, item)

func _create_inventory_slot(item: ItemData, count: int) -> void:
	var inventory_item_view: InventoryItemView = inventory_item_scene.instantiate()
	inventory_item_view.setup(item, count)
	inventory_item_view.pressed.connect(on_item_pressed)
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
