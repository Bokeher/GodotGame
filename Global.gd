extends Node

var damage: int = 1
const save_path: String = "user://save"
var gold: int = 0
var curr_stage: int = 1
var curr_enemy = null

var enemies_file = "res://assets/enemies/enemies.json"
var enemies = []

var stages_file = "res://assets/stages.json"
var stages = []

func _ready():
	load_game()
	load_stages()
	load_enemies()
	
	if(!curr_enemy):
		curr_enemy = get_enemy(0)

func load_game():
	if !FileAccess.file_exists(save_path): 
		print("File not found")
		return
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	
	var data = file.get_var()
	damage = data[0]
	gold = data[1]
	curr_stage = data[2]
	curr_enemy = data[3]

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	var save_data = [damage, gold, curr_stage, curr_enemy]
	
	file.store_var(save_data)
	
	print("Saved")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()

func load_enemies():
	if(!FileAccess.file_exists(enemies_file)): 
		print("Enemies file not found")
		return
	
	var json_to_read = FileAccess.open(enemies_file, FileAccess.READ)
	enemies = JSON.parse_string(json_to_read.get_as_text()).enemies
	
	#if(Global.curr_stage == 1):
		#Global.curr_enemy = Global.get_enemy(0)

func get_enemy(id: int):
	return enemies[id].duplicate()

func load_stages():
	if(!FileAccess.file_exists(stages_file)): 
		print("Stages file not found")
		return
	
	var json_to_read = FileAccess.open(stages_file, FileAccess.READ)
	stages = JSON.parse_string(json_to_read.get_as_text()).stages

func get_stage(id: int):
	return stages[id].duplicate()
