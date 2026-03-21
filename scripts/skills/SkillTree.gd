extends Control

const skillNode_scene := preload("res://scenes/skills/SkillNode.tscn")

@onready var player_skills: PlayerSkills = GameManager.player.player_skills 
var skill_views: Dictionary[int, SkillNode] = {}
# <skill_id, SkillView>

func _ready() -> void:
	player_skills.skill_points_changed.connect(_on_skill_points_changed)
	
	update_skill_points()

func _on_skill_points_changed(points: int) -> void:
	$SkillPointsAmount.text = "Skill points: " + str(points)

func update_skill_points() -> void:
	var skillTreePanel := $SkillScrollContainer/SkillTreePanel
	
	for skill in skillTreePanel.get_children():
		skill.queue_free()
	
	var skills: Dictionary[int, SkillData] = SkillDatabase.get_all()
	# Might need to sort this in the future
	
	for skill: SkillData in skills.values():
		var new_skillNode := skillNode_scene.instantiate()
		new_skillNode.setup(skill, player_skills)
		new_skillNode.position = get_vector_from_grid_position(skill.grid_position)
		
		new_skillNode.hovered.connect(_on_skill_hovered)
		new_skillNode.hover_exited.connect(_on_skill_hover_exited)
		new_skillNode.pressed.connect(_on_skill_pressed)
		
		skill_views.set(skill.id, new_skillNode)
		
		for req_skill: SkillData in skill.requirements:
			var bottom_point_offset := Vector2(34, 0)
			var top_point_offset := Vector2(34, 34)
			
			var line := Line2D.new()
			line.add_point(new_skillNode.position + bottom_point_offset)
			line.add_point(get_vector_from_grid_position(req_skill.grid_position) + top_point_offset)
			line.width = 2
			
			skillTreePanel.add_child(line)
		skillTreePanel.add_child(new_skillNode)
	
	$SkillPointsAmount.text = "Skill points: " + str(Global.player.skill_points)

func _on_skill_hovered(skill: SkillData) -> void:
	GlobalPopup.popup(skill.name, skill.description)

func _on_skill_hover_exited() -> void:
	GlobalPopup.hide_()

func _on_skill_pressed(skill: SkillData) -> void:
	player_skills.level_up(skill.id)

func get_vector_from_grid_position(grid_position: Vector2i) -> Vector2:
	var x_pos := grid_position.x
	var y_pos := grid_position.y
	
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
	player_skills.refund_all_skills()
