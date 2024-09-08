extends Control

func _ready():
	$".".set_custom_minimum_size($Background.size)

func upgrade(upgrade):
	if(Global.gold < upgrade.cost):
		# TODO: Show to user
		print("Not enough gold")
		return
		
	Global.gold -= upgrade.cost
	
	var id = upgrade.id
	if(id == 1):
		Global.damage += upgrade.value
	#elif(id == 2):
		
	
	$"../../../../Info/GoldAmount".update_gold()
	$"../../../../Info/DamageInfo".update_damage()
