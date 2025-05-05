extends Control

func focus() -> void:
	$Background.color = Color(0.30, 0.30, 0.30)

func unfocus() -> void:
	$Background.color = Color(0.21, 0.21, 0.21)

func _on_artifact_texture_pressed() -> void:
	# Handle communication with parent
	pass
