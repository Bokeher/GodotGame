extends Node2D

func upgrade(cost: int, damage_increase: int):
	if Global.gold < cost:
		# TODO: Show to user
		print("Not enough gold")
		return
		
	Global.gold -= cost
	Global.damage += damage_increase
	
	$Info/GoldAmount.update_gold()
	$Info/DamageInfo.update_damage()
