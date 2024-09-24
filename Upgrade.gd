extends Control

func _ready():
	$".".set_custom_minimum_size($Background.size)
	$Background/Level.update_level()

func upgrade(curr_upgrade):
	var cost = Global.upgrade_stats_array[curr_upgrade.id - 1].cost
	
	if(Global.player_stats.gold < cost):
		# TODO: Show to user
		print("Not enough gold")
		return
	
	Global.player_stats.gold -= cost
	
	var id = curr_upgrade.id
	if(id == 1):
		Global.player_stats.damage += curr_upgrade.value
	elif(id == 2):
		Global.player_stats.crit += (curr_upgrade.value / 100)
	elif(id == 3):
		Global.player_stats.speed += curr_upgrade.value
	elif(id == 4):
		Global.player_stats.wisdom += curr_upgrade.value
	elif(id == 5):
		Global.player_stats.luck += curr_upgrade.value
	
	var upgrade_stats = Global.upgrade_stats_array[id - 1]
	upgrade_stats.level += 1
	upgrade_stats.cost = int(upgrade_stats.cost * upgrade_stats.cost_multiplier)
	
	$Background/UpgradeButton.update_cost()
	$Background/Level.update_level()
	$"../../../../Info/GoldAmount".update_gold()
	$"../../../../Info/DamageInfo".update_damage()
