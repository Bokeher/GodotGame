extends Control

@onready var this_slot_id: int = $".".get_meta("id")

func focus() -> void:
	$Background.color = Color(0.30, 0.30, 0.30)

func unfocus() -> void:
	$Background.color = Color(0.21, 0.21, 0.21)

func _on_slot_texture_pressed() -> void:
	$"../../../..".select_artifact_slot(this_slot_id)
