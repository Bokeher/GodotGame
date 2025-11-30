extends Node
#class_name EnemyDatabase 
# THIS IS AUTOLOAD

var _enemies: Dictionary = {}
const _ENEMY_DIR_PATH = "res://assets/resources/enemies/"

func _ready() -> void:
	read()

func read() -> void:
	_enemies = ResourceLoaderHelper.load_folder_to_dict(_ENEMY_DIR_PATH)

func get_enemy(id: int) -> EnemyData:
	return _enemies.get(id, null)

func get_all_enemies() -> Dictionary:
	return _enemies
