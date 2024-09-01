extends Node

# file paths
const PATH_SAVE: String = "user://save"
const PATH_ENEMIES: String = "res://assets/enemies/enemies.json"
const PATH_STAGES: String = "res://assets/stages.json"
const PATH_UPGRADES: String = "res://assets/upgrades.json"

# saved vars
var damage: int = 1
var gold: int = 0
var max_stage_reached: int = 1

# vars to use in other files
var curr_enemy = null
var curr_stage = null
var enemy_pool = []

# private vars - use getters to get them
var _enemies = []
var _stages = []
var _upgrades = []

# TODO: decide if need to save curr_enemy
# TODO: decide if need get_upgrade and get_stage

func _ready():
	read_stages()
	read_enemies()
	read_upgrades()
	
	read_savefile()
	
	curr_stage = get_stage(max_stage_reached)
	enemy_pool = curr_stage.enemies
	
	if(!curr_enemy):
		curr_enemy = get_enemy(0)

func read_savefile():
	if !FileAccess.file_exists(PATH_SAVE): 
		print("File not found")
		return
	
	var file = FileAccess.open(PATH_SAVE, FileAccess.READ)
	
	var data = file.get_var()
	damage = data[0]
	gold = data[1]
	max_stage_reached = data[2]
	curr_enemy = data[3]

func save_savefile():
	var file = FileAccess.open(PATH_SAVE, FileAccess.WRITE)
	
	var save_data = [damage, gold, max_stage_reached, curr_enemy]
	
	file.store_var(save_data)
	
	print("Saved")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_savefile()

func read_enemies():
	if(!FileAccess.file_exists(PATH_ENEMIES)): 
		print("Enemies file not found")
		return
	
	var json_to_read = FileAccess.open(PATH_ENEMIES, FileAccess.READ)
	_enemies = JSON.parse_string(json_to_read.get_as_text()).enemies

func get_enemy(id: int):
	return _enemies[id - 1].duplicate()

func read_stages():
	if(!FileAccess.file_exists(PATH_STAGES)): 
		print("Stages file not found")
		return
	
	var json_to_read = FileAccess.open(PATH_STAGES, FileAccess.READ)
	_stages = JSON.parse_string(json_to_read.get_as_text()).stages

func get_stage(id: int):
	return _stages[id - 1].duplicate()

func read_upgrades():
	if(!FileAccess.file_exists(PATH_UPGRADES)): 
		print("Upgrades file not found")
		return
	
	var json_to_read = FileAccess.open(PATH_UPGRADES, FileAccess.READ)
	_upgrades = JSON.parse_string(json_to_read.get_as_text()).upgrades

func get_upgrade(id: int):
	return _upgrades[id - 1].duplicate()
