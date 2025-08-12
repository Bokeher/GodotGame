extends Control

const skillNode_scene = preload("res://scenes/skills/SkillNode.tscn")

func _ready() -> void:
	update_skill_points()

func update_skill_points() -> void:
	var skillTreePanel := $SkillScrollContainer/SkillTreePanel
	var i := 0
	
	for skill: Skill in Global.skills:
		var new_skillNode := skillNode_scene.instantiate()
		new_skillNode.set_meta("id", skill.id)
		new_skillNode.position = get_vector_from_grid_position(0, i)
		
		skillTreePanel.add_child(new_skillNode)
		i += 1
	
	$SkillPointsAmount.text = "Skill points: " + str(Global.player_stats.skill_points)

func get_vector_from_grid_position(x_pos: int, y_pos: int) -> Vector2i:
	if x_pos > 5:
		print("WARNING! skill grid x_pos > 5 (skill out of screen)")
	
	var left_offset := 16
	var top_offset := 16
	var skillNode_width := 68
	var skillNode_height := 68
	var skills_offset := 20
	
	return Vector2i(
		left_offset + (skillNode_width + skills_offset) * x_pos,
		top_offset + (skillNode_height + skills_offset) * y_pos
	)

func _on_reset_skills_button_pressed() -> void:
	for skill in Global.skills:
		Global.player_stats.skill_points += skill.level
		skill.level = 0
	
	update_skill_points()
