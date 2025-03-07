extends Control

func _ready():
	update_bestiary_item()

func update_bestiary_item():
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
			var item_rect = TextureRect.new()
			var image_path = Global.items[item_id - 1].image_path
			item_rect.texture = load(image_path)
			$Drops/LootTable.add_child(item_rect)
			# TODO: make this TextureRect a seperate scene and add popup
	
