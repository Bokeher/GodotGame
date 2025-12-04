extends Node
#class_name ItemDatabase 
# THIS IS AUTOLOAD

var _items: Dictionary = {}
const _ITEMS_DIR_PATH = "res://assets/resources/items/"

func _ready() -> void:
	read()

func read() -> void:
	_items = ResourceLoaderHelper.load_folder_to_dict(_ITEMS_DIR_PATH)

func get_item(id: int) -> ItemData:
	return _items.get(id, null)

func get_all_items() -> Dictionary:
	return _items
