extends Label

func _ready() -> void:
	update_skill_points()

func update_skill_points() -> void:
	$".".text = "Skill points: " + str(Global.player_stats.skill_points)
