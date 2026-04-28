extends Control

@onready var char_selection_view :CharacterClassSelectionView = $CharSelectionPanel/CharacterClassSelectionView

var current_char_id: int = Enums.CharacterClass.WARRIOR

@onready var classes: Array = Enums.CharacterClass.values().filter(func(c: int) -> int: return c >= 0 ) 

func _ready() -> void:
	update_char(current_char_id)

func update_char(id: int) -> void:
	current_char_id = id
	char_selection_view.set_char_class(CharacterClassDatabase.get_by_id(id))

func _on_previous_button_pressed() -> void:
	var index: int = classes.find(current_char_id)
	index = (index - 1 + classes.size()) % classes.size()
	current_char_id = classes[index]
	
	update_char(current_char_id)

func _on_next_button_pressed() -> void:
	var index: int = classes.find(current_char_id)
	index = (index + 1) % classes.size()
	current_char_id = classes[index]
	
	update_char(current_char_id)
