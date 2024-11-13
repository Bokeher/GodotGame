extends Control

var stats_texts = {
	"Damage": "Damage",
	"CritChance": "Crit chance",
	"RespawnTime": "Time to find enemy",
	"GoldMultiplier": "Gold multiplier",
	"XpMultiplier": "XP multiplier"
}

func _ready() -> void:
	update_stats()

func update_stats() -> void:
	var damage = Global.player_stats.damage
	var crit = Global.player_stats.calc_crit_chance()
	var respawn_time = Global.player_stats.calc_respawn_time()
	var gold_mult = Global.player_stats.calc_gold_mult()
	var xp_mult = Global.player_stats.calc_xp_mult()
	
	update_stat_text("Damage", damage)
	update_stat_text("CritChance", crit, "%")
	update_stat_text("RespawnTime", respawn_time, "s")
	update_stat_text("GoldMultiplier", gold_mult, "%")
	update_stat_text("XpMultiplier", xp_mult, "%")

func update_stat_text(stat_name: String, value: Variant, suffix: String = "") -> void:
	var text_node = $ColorRect/StatsContainer.get_node(stat_name)
	text_node.text = stats_texts[stat_name] + ": " + str(value) + suffix
