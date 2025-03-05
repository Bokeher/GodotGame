extends Control

var bestiary = null
var entries = null

func _ready():
	entries = Global.bestiary.enemyEntries
	
	for enemy_id in entries:
		var entryButton = TextureButton.new()
		var image_path = Global.enemies[enemy_id - 1].image_path
		entryButton.texture_normal = load(image_path)
		
		$ScrollContainer/BestiaryList.add_child(entryButton)
