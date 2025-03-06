extends Control

func set_enemy(enemy_id: int):
	$".".set_meta("enemy_id", enemy_id)
	
	# Set texture
	var image_path = Global.enemies[enemy_id - 1].image_path
	$TextureButton.texture_normal = load(image_path)

func _on_texture_button_pressed():
	var enemy_id = $".".get_meta("enemy_id")
	
	Global.curr_bestiary_enemy_id = enemy_id
	$"../../..".update_selected_bestiary()
