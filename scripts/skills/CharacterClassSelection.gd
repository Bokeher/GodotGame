extends Control

@onready var char_selection_view :CharacterClassSelectionView = $CharSelectionPanel/CharacterClassSelectionView

var current_char_id: int = Enums.CharacterClass.WARRIOR

func _ready() -> void:
	update_char(current_char_id)

func update_char(id: int) -> void:
	current_char_id = id
	char_selection_view.set_char_class(CharacterClassDatabase.get_by_id(id))

func _on_previous_button_pressed() -> void:
	print(current_char_id)
	print(Enums.CharacterClass.has(current_char_id))
	
	current_char_id -= 1
	
	if !(current_char_id in Enums.CharacterClass.values()) or current_char_id == -1:
		current_char_id = Enums.CharacterClass.values().max()
	
	update_char(current_char_id)

func _on_next_button_pressed() -> void:
	current_char_id += 1
	
	if !(current_char_id in Enums.CharacterClass.values()) or current_char_id == -1:
		current_char_id = 0
	
	update_char(current_char_id)
