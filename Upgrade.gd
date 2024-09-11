extends Control

func _ready():
	$".".set_custom_minimum_size($Background.size)

func upgrade(curr_upgrade):
	if(Global.player_stats.gold < curr_upgrade.cost):
		# TODO: Show to user
		print("Not enough gold")
		return
		
	Global.player_stats.gold -= curr_upgrade.cost
	
	var id = curr_upgrade.id
	if(id == 1):
		Global.player_stats.damage += curr_upgrade.value
	#elif(id == 2):
		
	
	$"../../../../Info/GoldAmount".update_gold()
	$"../../../../Info/DamageInfo".update_damage()
