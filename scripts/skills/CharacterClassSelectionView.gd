extends Control
class_name CharacterClassSelectionView

@export var character_class: CharacterClassData

signal selected(char_class: CharacterClassData)

func set_char_class(char_class: CharacterClassData) -> void:
	character_class = char_class
	update_view()

func update_view() -> void:
	if character_class == null:
		print("WARNING! Somehow CharacterClass is null")
		return
	
	$Background/Image.texture = character_class.texture
	$Background/Description.text = character_class.description
	$Background/Name.text = character_class.display_name

func _on_choose_button_pressed() -> void:
	# TODO: confirmation popup or hold to confirm
	selected.emit(character_class)
