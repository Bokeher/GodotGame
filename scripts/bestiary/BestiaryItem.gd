extends Control

const loot_item_scene = preload("res://scenes/bestiary/BestiaryLootItem.tscn")

func update_bestiary_item() -> void:
	var enemy: Enemy = Global.enemies[Global.curr_bestiary_enemy_id - 1]
	var bestiary_entry: BestiaryEntry = Global.bestiary.get_entry(enemy.id)
	
	if !bestiary_entry:
		return
	
	$EnemyName.text = enemy.name
	$EnemyImage.texture = load(enemy.image_path)
	$DefeatCount.text = "Times defeated: " + str(bestiary_entry.times_slayed)
	$EnemyStats/Health.text = "Health: " + str(enemy.health)
	$EnemyStats/Damage.text = "Damage: " + str(enemy.damage)
	$EnemyStats/XpReward.text = "Xp reward: " + str(enemy.xp_reward)
	$EnemyStats/GoldReward.text = "Gold reward: " + str(enemy.gold_reward)
	
	# Empty loot table
	for child in $Drops/LootTable.get_children():
		$Drops/LootTable.remove_child(child)
		child.queue_free()
	
	# Add drops
	for loot_table_item in enemy.loot_table:
		var item_id: int = loot_table_item.item_id
		
		var new_loot_item = loot_item_scene.instantiate()
		new_loot_item.set_meta("item_id", item_id)
		new_loot_item.set_meta("enemy_id", enemy.id)
		
		$Drops/LootTable.add_child(new_loot_item)
		
	
