extends Control

var bestiary = null
var entries = null
const bestiary_list_item_scene = preload("res://scenes/bestiary/BestiaryListItem.tscn")

func _ready():
	entries = Global.bestiary.enemyEntries
	
	for enemy_id in entries:
		var new_list_item = bestiary_list_item_scene.instantiate()
		new_list_item.set_enemy(enemy_id)
		
		$ScrollContainer/BestiaryList.add_child(new_list_item)

func update_selected_bestiary():
	$BestiaryItem.update_bestiary_item()
