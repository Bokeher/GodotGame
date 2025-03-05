extends Control

func _on_texture_button_pressed():
	var enemy_id = $".".get_meta("enemy_id")
	$"../../..".update_selected_bestiary(enemy_id)
