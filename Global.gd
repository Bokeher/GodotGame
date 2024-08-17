extends Node

var clicks: int = 0
var damage: int = 1
const save_path: String = "user://save"
var gold: int = 0
var curr_stage: int = 1
var curr_enemy = null

var json_file = "res://assets/enemies/enemies.json"
var all_enemies = [];

func _ready():
	load_save()
	loadAllEnemies()

func load_save():
	if !FileAccess.file_exists(save_path): 
		print("File not found")
		return
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	
	var data = file.get_var()
	clicks = data[0]
	damage = data[1]
	gold = data[2]
	curr_stage = data[3]
	curr_enemy = data[4]

func save_clicks():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	var save_data = [clicks, damage, gold, curr_stage, curr_enemy]
	
	file.store_var(save_data)
	
	print("Saved")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_clicks()

func loadAllEnemies():
	# TODO: do this with resources ?
	
	if(!FileAccess.file_exists(json_file)): 
		print("Enemies file not found")
		return
	
	var json_to_read = FileAccess.open(json_file, FileAccess.READ)
	all_enemies = JSON.parse_string(json_to_read.get_as_text()).enemies
	
	if(Global.curr_stage == 1):
		Global.curr_enemy = Global.get_enemy(0)

func get_enemy(id):
	return all_enemies[id].duplicate();
