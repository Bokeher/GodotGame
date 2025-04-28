extends Control

func set_enemy(enemy_id: int, discovered: bool = true) -> void:
	$".".set_meta("enemy_id", enemy_id)
	
	# Set texture
	var image_path = "res://assets/sprites/unknown.png"
	if discovered:
		image_path = Global.enemies[enemy_id - 1].image_path
	
	$ItemButton.texture_normal = load(image_path)

func _on_texture_button_pressed() -> void:
	var old_enemy_id = Global.curr_bestiary_enemy_id
	
	Global.curr_bestiary_enemy_id = $".".get_meta("enemy_id")
	
	$"../../..".update_bestiary(old_enemy_id)

func _on_texture_button_focus_entered() -> void:
	_on_texture_button_pressed()

func focus() -> void:
	$Background.color = Color(0.30, 0.30, 0.30)

func unfocus() -> void:
	$Background.color = Color(0.21, 0.21, 0.21)
