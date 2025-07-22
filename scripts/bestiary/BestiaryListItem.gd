extends Control

@onready var popup: GlobalPopup = get_node("/root/Game/Popup")

func set_enemy(enemy_id: int, discovered: bool = true) -> void:
	$".".set_meta("enemy_id", enemy_id)
	
	# Set texture
	var image_path = "res://assets/sprites/unknown.png"
	if discovered:
		image_path = Global.enemies[enemy_id - 1].image_path
	
	$ItemButton.texture_normal = load(image_path)

func _on_texture_button_pressed() -> void:
	var selected_id: int = $".".get_meta("enemy_id")
	
	if !Global.bestiary.enemyEntries.has(selected_id):
		return
	
	Global.curr_bestiary_enemy_id = selected_id
	
	$"../../..".update_bestiary()

func _on_texture_button_focus_entered() -> void:
	_on_texture_button_pressed()

func focus() -> void:
	$Background.color = Enums.Colors["BG_FOCUS_HOVER"]

func unfocus() -> void:
	$Background.color = Enums.Colors["BG_UNFOCUS_HOVER"]

func _on_item_button_mouse_entered() -> void:
	var enemy_id: int = $".".get_meta("enemy_id")
	if !Global.bestiary.enemyEntries.has(enemy_id):
		popup.popup("Unknown enemy", "")
		return
	
	var enemy := Global.enemies[$".".get_meta("enemy_id") - 1]
	popup.popup(enemy.name, "")

func _on_item_button_mouse_exited() -> void:
	popup.hide_()
