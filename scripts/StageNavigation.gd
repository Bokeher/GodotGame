extends Node

func _on_prev_stage_button_pressed() -> void:
		GameManager.change_to_prev_stage()


func _on_next_stage_button_pressed() -> void:
	GameManager.change_to_next_stage()
