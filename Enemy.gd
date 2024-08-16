extends Node2D

var json_file = "res://assets/enemies/enemies.json"

func _ready():
	# TODO: do this with resources ?
	
	if(!FileAccess.file_exists(json_file)): 
		print("Enemies file not found")
		return
	
	var json_to_read = FileAccess.open(json_file, FileAccess.READ)
	var data = JSON.parse_string(json_to_read.get_as_text())
	
	if(Global.curr_stage == 1):
		loadEnemy(data.enemies[0])

func loadEnemy(enemy):
	# TODO: set values in global / set curr_enemy object in global and create func to load all this data
	$EnemyBody.texture_normal = load(enemy.image_url)
	$EnemyName.text = enemy.name
	$EnemyHealth.text = str(enemy.health) + " HP"
