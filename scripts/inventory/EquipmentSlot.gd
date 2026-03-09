extends Control
class_name EquipmentSlot

@export var item: ItemData = null
@export var equipment_slot_id: Equipment.EquipmentSlotId
var is_selected: bool

signal pressed(slot: Equipment.EquipmentSlotId)
signal hovered(slot: Equipment.EquipmentSlotId)
signal hover_exited()

func setup(slot_id: Equipment.EquipmentSlotId, selected_slot_changed_signal: Signal, is_selected_ = false) -> void:
	equipment_slot_id = slot_id
	is_selected = is_selected_
	selected_slot_changed_signal.connect(on_selected_slot_changed)
	GameManager.player.inventory.equipment.equipment_changed.connect(_on_equipment_change)
	
	update_ui()

func on_selected_slot_changed(slot_id: Equipment.EquipmentSlotId)  -> void:
	is_selected = slot_id == equipment_slot_id
	
	update_ui()

func _on_equipment_change(slot_id: Equipment.EquipmentSlotId) -> void:
	if slot_id != equipment_slot_id:
		return
	
	item = GameManager.player.inventory.equipment.get_item(slot_id)
	
	update_ui()

func update_ui() -> void:
	$Background.color = Enums.get_background_color(is_selected)
	
	if item == null:
		$SlotTexture.texture_normal = load(Enums.get_equipment_slot_id_texture(equipment_slot_id))
		return
	
	$SlotTexture.texture_normal = item.texture

func _on_slot_texture_pressed() -> void:
	pressed.emit(equipment_slot_id)
	hover_exited.emit()
	hovered.emit(equipment_slot_id)

func _on_mouse_entered() -> void:
	$Border.color = Enums.get_border_color(true)
	hovered.emit(equipment_slot_id)

func _on_mouse_exited() -> void:
	$Border.color = Enums.get_border_color(false)
	hover_exited.emit()
