extends Control

const skillNode_scene := preload("res://scenes/skills/SkillNode.tscn")
var points_spent: int

func _ready() -> void:
	update_skill_points()

func update_skill_points() -> void:
	var skillTreePanel := $SkillScrollContainer/SkillTreePanel
	
	for skill in skillTreePanel.get_children():
		skillTreePanel.remove_child(skill)
		skill.queue_free()
	
	points_spent = 0
	
	# Sort skills to prevent node overlapping
	var sorted_skills: Array[Skill] = get_sorted_skills(Global.skills)
	
	for skill: Skill in sorted_skills:
		points_spent += skill.level
		
		var y: int = skill.grid_position[1]
		var skill_points_needed: int = 3 * y # y starts from 0
		if y == 1:
			skill_points_needed = 1
		
		if points_spent < skill_points_needed && !Global.debug_mode:
			continue
		
		var new_skillNode := skillNode_scene.instantiate()
		new_skillNode.set_meta("id", skill.id)
		new_skillNode.position = get_vector_from_grid_position(skill.grid_position)
		
		for id in skill.requirement_ids:
			var req_skill := Global.skills[id - 1]
			var bottom_point_offset := Vector2(34, 0)
			var top_point_offset := Vector2(34, 34)
			
			var line := Line2D.new()
			line.add_point(new_skillNode.position + bottom_point_offset)
			line.add_point(get_vector_from_grid_position(req_skill.grid_position) + top_point_offset)
			line.width = 2
			
			skillTreePanel.add_child(line)
		
		skillTreePanel.add_child(new_skillNode)
	
	$SkillPointsAmount.text = "Skill points: " + str(Global.player.skill_points)

func get_sorted_skills(skills: Array[Skill]) -> Array[Skill]:
	var sorted: Array[Skill] = skills.duplicate()
	
	sorted.sort_custom(func(a: Skill, b: Skill) -> bool:
		if a.grid_position[1] == b.grid_position[1]:
			return a.grid_position[0] < b.grid_position[0]
		return a.grid_position[1] < b.grid_position[1]
	)
	
	return sorted

func get_vector_from_grid_position(grid_position: Array[int]) -> Vector2:
	var x_pos := grid_position[0]
	var y_pos := grid_position[1]
	
	if x_pos > 5:
		print("WARNING! skill grid x_pos > 5 (skill out of screen)")
	
	var left_offset := 16
	var top_offset := 16
	var skillNode_width := 68
	var skillNode_height := 68
	var skills_offset := 20
	
	return Vector2(
		left_offset + (skillNode_width + skills_offset) * x_pos,
		top_offset + (skillNode_height + skills_offset) * y_pos
	)

func _on_reset_skills_button_pressed() -> void:
	for skill in Global.skills:
		Global.player.skill_points += skill.level
		points_spent = 0
		skill.level = 0
	
	update_skill_points()
