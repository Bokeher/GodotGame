extends Control

const loot_item_scene = preload("res://scenes/bestiary/BestiaryLootItem.tscn")

func _ready() -> void:
	update_bestiary_item()

func update_bestiary_item() -> void:
	var enemy: Enemy = Global.enemies[Global.curr_bestiary_enemy_id - 1]
	var bestiaryEntry: BestiaryEntry = Global.bestiary.get_entry(enemy.id)
	
	$EnemyName.text = enemy.name
	$EnemyImage.texture = load(enemy.image_path)
	$DefeatCount.text = "Times defeated: " + str(bestiaryEntry.times_slayed)
	$EnemyStats/Health.text = "Health: " + str(enemy.health)
	$EnemyStats/Damage.text = "Damage: " + str(enemy.damage)
	$EnemyStats/XpReward.text = "Xp reward: " + str(enemy.xp_reward)
	$EnemyStats/GoldReward.text = "Gold reward: " + str(enemy.gold_reward)
	
	# <id, has_dropped: bool>
	var drops = bestiaryEntry.items_dropped
	
	for child in $Drops/LootTable.get_children():
		$Drops/LootTable.remove_child(child)
	
	for item_id in drops:
		if(drops[item_id]):
			var new_loot_item = loot_item_scene.instantiate()
			
			var item_image = new_loot_item.get_node("./LootImage")
			var image_path = Global.items[item_id - 1].image_path
			item_image.texture = load(image_path)
			
			$Drops/LootTable.add_child(new_loot_item)
			#TODO: Add popups
	
	var childs = $Drops/LootTable.get_children()
	var loot_table = enemy.loot_table
	
	for loot_table_element in loot_table:
		if(loot_table.size() == childs.size()): 
			break
		
		if(drops.has(loot_table_element["item_id"])): 
			continue
		
		var new_loot_item = loot_item_scene.instantiate()
		
		var item_image = new_loot_item.get_node("./LootImage")
		var image_path = "res://assets/sprites/unknown.png"
		item_image.texture = load(image_path)
		
		$Drops/LootTable.add_child(new_loot_item)
