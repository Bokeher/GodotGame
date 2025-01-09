extends Label

func _ready() -> void:
	update_skill_points()

func update_skill_points() -> void:
	var skillTreePanel = $"../SkilTree/SubViewportContainer/SubViewport/SkillTreePanel"
	for skillNode in skillTreePanel.get_children():
		skillNode.update_skill()
	
	$".".text = "Skill points: " + str(Global.player_stats.skill_points)
