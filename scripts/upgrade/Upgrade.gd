extends Control

func _ready() -> void:
	$".".set_custom_minimum_size($Background.size)
	$Background/Level.update_level()

func upgrade(curr_upgrade: Upgrade) -> void:
	var cost = curr_upgrade.cost
	
	if(Global.player_stats.gold < cost):
		# TODO: Show to user
		print("Not enough gold")
		return
	
	Global.player_stats.gold -= cost
	
	var id = curr_upgrade.id
	if(id == 1):
		Global.player_stats.damage += curr_upgrade.value
	elif(id == 2):
		Global.player_stats.crit_chance += (float(curr_upgrade.value) / 100)
	elif(id == 3):
		Global.player_stats.speed += curr_upgrade.value
	elif(id == 4):
		Global.player_stats.wisdom += curr_upgrade.value
	elif(id == 5):
		Global.player_stats.luck += curr_upgrade.value
	
	curr_upgrade.level += 1
	curr_upgrade.cost = int(curr_upgrade.cost * curr_upgrade.cost_multiplier)
	
	$Background/UpgradeButton.update_cost()
	$Background/Level.update_level()
	
	$"../../../GoldAmount".update_gold()
	$"../../../../StatsPanel/Stats".update_stats()
