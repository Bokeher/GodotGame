extends Control

var bestiary = null
var entries = null
const bestiary_list_item_scene = preload("res://scenes/bestiary/BestiaryListItem.tscn")

func _ready() -> void:
	entries = Global.bestiary.enemyEntries
	
	for enemy_id in entries:
		var new_list_item = bestiary_list_item_scene.instantiate()
		new_list_item.set_enemy(enemy_id)
		
		$ScrollContainer/BestiaryList.add_child(new_list_item)
	
	

func update_selected_bestiary(old_selected_enemy_id: int = -1) -> void:
	if (
		old_selected_enemy_id == Global.curr_bestiary_enemy_id
	): return
	
	var childs = $ScrollContainer/BestiaryList.get_children()
	
	if(old_selected_enemy_id != -1): 
		childs[old_selected_enemy_id - 1].unfocus()
	childs[Global.curr_bestiary_enemy_id - 1].focus()

	$BestiaryItem.update_bestiary_item()
