extends Control
class_name EquipmentSlot

@export var item: ItemData = null
@export var equipment_slot_id: Equipment.EquipmentSlotId
var is_selected: bool

signal pressed(equipment_slot_id: Equipment.EquipmentSlotId)

func setup(slot_id: Equipment.EquipmentSlotId, is_selected_ = false) -> void:
	equipment_slot_id = slot_id
	is_selected = is_selected_
	
	GameManager.player.inventory.equipment.equipment_changed.connect(_on_equipment_change)
	
	update_ui()

func _on_equipment_change(slot_id: Equipment.EquipmentSlotId) -> void:
	if slot_id != equipment_slot_id:
		return
	
	item = GameManager.player.inventory.equipment.get_item(slot_id)
	
	update_ui()

func update_ui() -> void:
	if item == null:
		$SlotTexture.texture_normal = load(Enums.get_equipment_slot_id_texture(equipment_slot_id))
		return
	
	$SlotTexture.texture_normal = item.texture

func _on_slot_texture_pressed() -> void:
	pressed.emit(equipment_slot_id)
