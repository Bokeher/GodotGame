extends Node2D

func click():
	Global.clicks += Global.damage
	
	$Main/ClicksInfo.update_clicks()

func upgrade(cost: int, damage_increase: int):
	Global.clicks -= cost
	Global.damage += damage_increase
	
	$Main/ClicksInfo.update_clicks()
	$Upgrades/DamageInfo.update_damage()
