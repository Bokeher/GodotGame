extends Control

var stats_texts := {
	"Damage": "Damage",
	"CritChance": "Crit chance",
	"RespawnTime": "Time to find enemy",
	"GoldMultiplier": "Gold multiplier",
	"XpMultiplier": "XP multiplier",
	"XpAmount": "XP",
	"Level": "Level"
}

func _ready() -> void:
	update_stats()

func update_stats() -> void:
	var damage := Global.player.damage
	var crit := Global.player.calc_crit_chance()
	var respawn_time := Global.player.calc_respawn_time()
	var gold_mult := Global.player.calc_gold_mult()
	var xp_mult := Global.player.calc_xp_mult()
	var xp := Global.player.xp
	var level := Global.player.level
	
	update_stat_text("Damage", damage)
	update_stat_text("CritChance", crit, "%")
	update_stat_text("RespawnTime", respawn_time, "s")
	update_stat_text("GoldMultiplier", gold_mult, "%")
	update_stat_text("XpMultiplier", xp_mult, "%")
	update_stat_text("XpAmount", xp, " / 100") #TODO: remove this hardcoded text
	update_stat_text("Level", level)

func update_stat_text(stat_name: String, value: Variant, suffix: String = "") -> void:
	var text_node := $ColorRect/StatsContainer.get_node(stat_name)
	text_node.text = stats_texts[stat_name] + ": " + str(value) + suffix
