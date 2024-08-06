extends Node

var clicks: int = 0;
const save_path: String = "user://save"

func _ready():
	load_clicks();

func load_clicks():
	if !FileAccess.file_exists(save_path): 
		print("File not found")
		return
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	clicks = file.get_var()

func save_clicks():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(clicks)
	
	print("saved")
	
func _notification(notification):
	if notification == NOTIFICATION_WM_CLOSE_REQUEST:
		save_clicks();
