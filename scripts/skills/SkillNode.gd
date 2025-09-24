extends Control
class_name SkillNode

@onready var id: int = $".".get_meta("id")
@onready var skill := Global.skills[id - 1]
@onready var popup: GlobalPopup = get_node("/root/Game/Popup")

func _ready() -> void:
	update_level_label()
	update_skill_image()

func update_skill() -> void:
	if(skill == null): return
	
	skill = Global.skills[skill.id - 1]
	
	update_level_label()

func _on_texture_button_mouse_entered() -> void:
	if skill.level < skill.max_level:
		$Background.color = Enums.Colors["BG_FOCUS_HOVER"]
	$Border.color = Enums.Colors["BORDER_FOCUS_HOVER"]
	
	var skill_description: String = skill.get_formatted_description()
	
	var description := skill_description + "\n\nLevel " + str(skill.level) + " / " + str(skill.max_level)
	
	popup.popup(skill.name, description)

func _on_texture_button_mouse_exited() -> void:
	$Background.color = Enums.Colors["BG_UNFOCUS_HOVER"]
	$Border.color = Enums.Colors["BORDER_UNFOCUS_HOVER"]
	
	popup.hide_()

func _on_texture_button_pressed() -> void:
	level_up_skill()

func level_up_skill() -> void:
	# 0 skill points
	if Global.player_stats.skill_points <= 0:
		return
	
	# Max level
	if skill.level >= skill.max_level :
		return
	
	if !meets_skill_requirements(skill):
		# TODO: Add popup here about skill requirements and also show in skill description when reqs are not met
		return
	
	skill.level += 1
	Global.player_stats.skill_points -= 1
	$"../../..".update_skill_points()
	
	update_level_label()

func meets_skill_requirements(skill: Skill) -> bool:
	var required_ids: Array[int] = skill.requirement_ids
	
	for required_id in required_ids:
		var required_skill: Skill = Global.skills[required_id - 1]
		
		if required_skill.level < required_skill.max_level:
			return false
	
	return true

func update_level_label() -> void:
	$SkillLevelLabel.text = str(skill.level) + " / " + str(skill.max_level)

func update_skill_image() -> void:
	$SkillButton.texture_normal = load(skill.image_path)
