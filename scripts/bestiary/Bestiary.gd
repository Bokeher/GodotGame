extends Control

@onready var entries: Dictionary = Global.bestiary.enemyEntries
const bestiary_list_item_scene = preload("res://scenes/bestiary/BestiaryListItem.tscn")

func _ready() -> void:
	load_bestiary_list()
	update_bestiary()

func update_bestiary(old_enemy_id: int = -1) -> void:
	if entries.is_empty():
		$BestiaryItem.visible = false
		return
		
	load_bestiary_list()
	update_selected_bestiary(old_enemy_id)
	

func load_bestiary_list() -> void:
	for child in $ScrollContainer/BestiaryList.get_children():
		$ScrollContainer/BestiaryList.remove_child(child)
	
	for enemy_id in entries:
		var new_list_item = bestiary_list_item_scene.instantiate()
		new_list_item.set_enemy(enemy_id)
		
		$ScrollContainer/BestiaryList.add_child(new_list_item)
	
	for enemy in Global.enemies:
		if !entries.has(enemy.id):
			var new_list_item = bestiary_list_item_scene.instantiate()
			new_list_item.set_enemy(enemy.id, false)
			
			$ScrollContainer/BestiaryList.add_child(new_list_item)

func update_selected_bestiary(old_selected_enemy_id: int = -1) -> void:
	if (
		old_selected_enemy_id == Global.curr_bestiary_enemy_id
	): return
	
	var childs = $ScrollContainer/BestiaryList.get_children()
	if childs.is_empty():
		return
	
	if(old_selected_enemy_id != -1): 
		childs[old_selected_enemy_id - 1].unfocus()
	childs[Global.curr_bestiary_enemy_id - 1].focus()
	
	$BestiaryItem.update_bestiary_item()
