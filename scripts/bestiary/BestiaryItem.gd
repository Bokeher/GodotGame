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
	# TODO: update drops
	#for item_id in drops:
		#if(drops[item_id]):
			#
	
