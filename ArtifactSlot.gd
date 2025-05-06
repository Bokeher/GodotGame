extends Control

@onready var this_artifact_slot_id = $".".get_meta("id")

func focus() -> void:
	$Background.color = Color(0.30, 0.30, 0.30)

func unfocus() -> void:
	$Background.color = Color(0.21, 0.21, 0.21)

func _on_artifact_texture_pressed() -> void:
	$"../..".select_artifact_slot(this_artifact_slot_id)
