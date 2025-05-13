extends Control

@onready var this_slot_id: int = $".".get_meta("id")
@onready var this_slot_type: String = $".".get_meta("slot_type")

func focus() -> void:
	$Background.color = Color(0.30, 0.30, 0.30)

func unfocus() -> void:
	$Background.color = Color(0.21, 0.21, 0.21)

func _on_slot_texture_pressed() -> void:
	$"../../../..".select_artifact_slot(this_slot_id)
