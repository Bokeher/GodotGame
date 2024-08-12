extends Node

var clicks: int = 0
var damage: int = 1
const save_path: String = "user://save"
var enemy_health: int = 100

func _ready():
	load_clicks()

func load_clicks():
	if !FileAccess.file_exists(save_path): 
		print("File not found")
		return
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	var data = file.get_var()
	clicks = data[0]
	damage = data[1]

func save_clicks():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	var save_data = [clicks, damage]
	
	file.store_var(save_data)
	
	print("Saved")
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_clicks()
