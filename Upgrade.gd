extends Control

func _ready():
	$".".set_custom_minimum_size($Background.size)

func upgrade(curr_upgrade):
	if(Global.gold < curr_upgrade.cost):
		# TODO: Show to user
		print("Not enough gold")
		return
		
	Global.gold -= curr_upgrade.cost
	
	var id = curr_upgrade.id
	if(id == 1):
		Global.damage += curr_upgrade.value
	#elif(id == 2):
		
	
	$"../../../../Info/GoldAmount".update_gold()
	$"../../../../Info/DamageInfo".update_damage()
