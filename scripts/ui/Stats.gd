extends Control

var stats_texts := {
	"Damage": "Damage",
	"CritChance": "Crit chance",
	"RespawnTime": "Time to find enemy",
	"XpAmount": "XP",
	"Level": "Level"
}

func _ready() -> void:
	GameManager.player.stats_changed.connect(update_stats)
	
	update_stats()

func update_stats() -> void:
	var player: PlayerInstance = GameManager.player
	
	var damage := player.damage
	var crit := player.crit_chance
	var xp := player.xp
	var level := player.level
	var xp_needed := player.calc_xp_needed(level)
	
	update_stat_text("Damage", damage)
	update_stat_text("CritChance", crit, "%")
	update_stat_text("RespawnTime", "1", "s")
	update_stat_text("XpAmount", xp, " / " + str(xp_needed))
	update_stat_text("Level", level)

func update_stat_text(stat_name: String, value: Variant, suffix: String = "") -> void:
	var text_node := $ColorRect/StatsContainer.get_node(stat_name)
	text_node.text = stats_texts[stat_name] + ": " + str(value) + suffix
