extends Control


func _ready():
	update_stats()


func update_stats():
	var damage = Global.player_stats.damage
	var crit =  Global.player_stats.crit * 100
	var respawn_time = 1.01 - Global.player_stats.speed * 0.01
	var gold_mult = Global.player_stats.luck + 99
	var xp_mult = Global.player_stats.wisdom + 99
	
	$ColorRect/StatsContainer/Damage.text = "Damage: " + str(damage)
	$ColorRect/StatsContainer/Crit.text = "Crit chance: " + str(crit) + "%"
	$ColorRect/StatsContainer/RespawnTime.text = "Enemy find time: " + str(respawn_time) + "s"
	$ColorRect/StatsContainer/GoldMult.text = "Gold multiplier: " + str(gold_mult) + "%"
	$ColorRect/StatsContainer/XpMult.text = "Xp multiplier: " + str(xp_mult) + "%"
	
