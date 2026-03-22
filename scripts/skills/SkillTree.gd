extends Control

const skillView_scene := preload("res://scenes/skills/SkillView.tscn")

@onready var player_skills: PlayerSkills = GameManager.player.player_skills 
var skill_views: Dictionary[int, SkillView] = {}
# <skill_id, SkillView>

func _ready() -> void:
	player_skills.skill_points_changed.connect(_on_skill_points_changed)
	player_skills.skill_level_changed.connect(_on_skill_level_changed)
	player_skills.skills_refunded.connect(_on_skills_refunded)
	
	update_skills()

func _on_skills_refunded() -> void:
	for view: SkillView in skill_views.values():
		view.update_level_label(0)

func _on_skill_level_changed(skill: SkillData, level: int) -> void:
	var skill_view: SkillView = skill_views.get(skill.id)
	skill_view.update_level_label(level)

func _on_skill_points_changed(points: int) -> void:
	$SkillPointsAmount.text = "Skill points: " + str(points)

func update_skills() -> void:
	var skillTreePanel := $SkillScrollContainer/SkillTreePanel
	
	for skill in skillTreePanel.get_children():
		skill.queue_free()
	
	var skills: Dictionary[int, SkillData] = SkillDatabase.get_all()
	# Might need to sort this in the future
	
	for skill: SkillData in skills.values():
		var new_skillView := build_skill_view(skill)
		
		for req_skill: SkillData in skill.requirements:
			var line: Line2D = create_line(
				new_skillView.position, 
				grid_position_to_vector(req_skill.grid_position)
			)
			
			skillTreePanel.add_child(line)
		skillTreePanel.add_child(new_skillView)
	

func update_skill_points(points: int) -> void:
	$SkillPointsAmount.text = "Skill points: " + str(points)

func build_skill_view(skill: SkillData) -> SkillView:
	var skill_view: SkillView = skillView_scene.instantiate()
	
	skill_view.setup(skill)
	skill_view.position = grid_position_to_vector(skill.grid_position)
	
	skill_view.hovered.connect(_on_skill_hovered)
	skill_view.hover_exited.connect(_on_skill_hover_exited)
	skill_view.pressed.connect(_on_skill_pressed)
	
	skill_views.set(skill.id, skill_view)
	
	return skill_view

func create_line(pos1: Vector2i, pos2: Vector2i) -> Line2D:
	var bottom_point_offset := Vector2i(34, 0)
	var top_point_offset := Vector2i(34, 34)
	
	var line := Line2D.new()
	line.width = 2
	line.add_point(pos1 + bottom_point_offset)
	line.add_point(pos2 + top_point_offset)
	
	return line

func _on_skill_hovered(skill: SkillData) -> void:
	GlobalPopup.popup(skill.name, skill.description)

func _on_skill_hover_exited() -> void:
	GlobalPopup.hide_()

func _on_skill_pressed(skill: SkillData) -> void:
	player_skills.level_up(skill.id)

func grid_position_to_vector(grid_position: Vector2i) -> Vector2:
	var x_pos := grid_position.x
	var y_pos := grid_position.y
	
	if x_pos > 5:
		print("WARNING! skill grid x_pos > 5 (skill out of screen)")
	
	var left_offset := 16
	var top_offset := 16
	var skillView_width := 68
	var skillView_height := 68
	var skills_offset := 20
	
	return Vector2(
		left_offset + (skillView_width + skills_offset) * x_pos,
		top_offset + (skillView_height + skills_offset) * y_pos
	)

func _on_reset_skills_button_pressed() -> void:
	player_skills.refund_all_skills()
