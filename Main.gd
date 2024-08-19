extends Node2D

func upgrade(cost: int, damage_increase: int):
	if Global.gold < cost:
		# TODO: Show to user
		print("Not enough gold")
		return
		
	Global.gold -= cost
	Global.damage += damage_increase
	
	$GoldAmount.update_gold()
	$Upgrades/DamageInfo.update_damage()
