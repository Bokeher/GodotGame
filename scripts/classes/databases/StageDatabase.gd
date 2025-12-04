extends Node
#class_name StageDatabase 
# THIS IS AUTOLOAD

var _stages: Dictionary = {}
const _STAGE_DIR_PATH = "res://assets/resources/stages/"

func _ready() -> void:
	read()

func read() -> void:
	_stages = ResourceLoaderHelper.load_folder_to_dict(_STAGE_DIR_PATH)

func get_stage(id: int) -> StageData:
	return _stages.get(id, null)

func get_all_stages() -> Dictionary:
	return _stages
