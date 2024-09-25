extends Control


func _ready():
	update_stats()


func update_stats():
	var damage = Global.player_stats.damage
	var crit = Global.player_stats.crit
	
	$ColorRect/StatsContainer/Damage.text = "Damage: " + str(damage)
	$ColorRect/StatsContainer/Crit.text = "Crit chance: " + str(crit * 100) + "%"
