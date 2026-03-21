extends Control

const skillView_scene := preload("res://scenes/skills/SkillView.tscn")

@onready var player_skills: PlayerSkills = GameManager.player.player_skills 
var skill_views: Dictionary[int, SkillView] = {}
# <skill_id, SkillView>

func _ready() -> void:
	player_skills.skill_points_changed.connect(_on_skill_points_changed)
	player_skills.skill_level_changed.connect(_on_skill_level_changed)
	
	update_skill_points()

func _on_skill_level_changed(skill: SkillData, level: int) -> void:
	var skill_view: SkillView = skill_views.get(skill.id)
	skill_view.update_level_label(level)

func _on_skill_points_changed(points: int) -> void:
	$SkillPointsAmount.text = "Skill points: " + str(points)

func update_skill_points() -> void:
	var skillTreePanel := $SkillScrollContainer/SkillTreePanel
	
	for skill in skillTreePanel.get_children():
		skill.queue_free()
	
	var skills: Dictionary[int, SkillData] = SkillDatabase.get_all()
	# Might need to sort this in the future
	
	for skill: SkillData in skills.values():
		var new_skillView := skillView_scene.instantiate()
		new_skillView.setup(skill)
		new_skillView.position = get_vector_from_grid_position(skill.grid_position)
		
		new_skillView.hovered.connect(_on_skill_hovered)
		new_skillView.hover_exited.connect(_on_skill_hover_exited)
		new_skillView.pressed.connect(_on_skill_pressed)
		
		skill_views.set(skill.id, new_skillView)
		
		for req_skill: SkillData in skill.requirements:
			var bottom_point_offset := Vector2(34, 0)
			var top_point_offset := Vector2(34, 34)
			
			var line := Line2D.new()
			line.add_point(new_skillView.position + bottom_point_offset)
			line.add_point(get_vector_from_grid_position(req_skill.grid_position) + top_point_offset)
			line.width = 2
			
			skillTreePanel.add_child(line)
		skillTreePanel.add_child(new_skillView)
	
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
	var skillView_width := 68
	var skillView_height := 68
	var skills_offset := 20
	
	return Vector2(
		left_offset + (skillView_width + skills_offset) * x_pos,
		top_offset + (skillView_height + skills_offset) * y_pos
	)

func _on_reset_skills_button_pressed() -> void:
	player_skills.refund_all_skills()
