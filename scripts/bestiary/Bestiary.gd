extends Control

@onready var entries: Dictionary = Global.bestiary.enemyEntries
const bestiary_list_item_scene = preload("res://scenes/bestiary/BestiaryListItem.tscn")
var old_selected_enemy_id: int = -1

func _ready() -> void:
	load_bestiary_list()
	update_bestiary()

func update_bestiary() -> void:
	if entries.is_empty():
		$BestiaryItem.visible = false
		return
		
	load_bestiary_list()
	update_selected_bestiary()
	

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

func update_selected_bestiary() -> void:
	var childs = $ScrollContainer/BestiaryList.get_children()
	if childs.is_empty() || Global.curr_bestiary_enemy_id == -1:
		return
	
	for child in childs:
		var id = child.get_meta("enemy_id")
		if id == Global.curr_bestiary_enemy_id:
			child.focus()
		elif id == old_selected_enemy_id:
			child.unfocus()
	
	old_selected_enemy_id = Global.curr_bestiary_enemy_id
	
	$BestiaryItem.update_bestiary_item()
	$BestiaryItem.visible = true
