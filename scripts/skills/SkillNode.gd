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
	
	var skill_description: String = get_formatted_description(skill)
	
	var description := skill_description + "\n\nLevel " + str(skill.level) + " / " + str(skill.max_level)
	
	popup.popup(skill.name, description)

func get_formatted_description(skill: Skill) -> String:
	var raw_description: String = skill.description
	
	if not skill.description.contains("%"):
		return raw_description
	
	var regex = RegEx.new()
	regex.compile(r" \d+%") # " 10% "

	var matches = regex.search_all(raw_description)

	# Lopp backwards to not shift indexes
	for i in range(matches.size() - 1, -1, -1):
		var match = matches[i]
		var value = match.get_string()

		var color: String = Enums.ColorsHex.SKILL_DESCRIPTION_SUB
		var formatted_value: String = value

		if i + 1 == skill.level: # if current level
			color = Enums.ColorsHex.SKILL_DESCRIPTION_MAIN
			formatted_value = "[b]" + value + "[/b]"

		raw_description = raw_description.substr(0, match.get_start()) \
			+ "[color=" + color + "]" + formatted_value + "[/color]" \
			+ raw_description.substr(match.get_end())
	
	return raw_description

func _on_texture_button_mouse_exited() -> void:
	$Background.color = Enums.Colors["BG_UNFOCUS_HOVER"]
	$Border.color = Enums.Colors["BORDER_UNFOCUS_HOVER"]
	
	popup.hide_()

func _on_texture_button_pressed() -> void:
	level_up_skill()

func level_up_skill() -> void:
	if(skill.level >= skill.max_level || Global.player_stats.skill_points <= 0):
		return
	
	skill.level += 1
	Global.player_stats.skill_points -= 1
	$"../../..".update_skill_points()
	
	update_level_label()

func update_level_label() -> void:
	$SkillLevelLabel.text = str(skill.level) + " / " + str(skill.max_level)

func update_skill_image() -> void:
	$SkillButton.texture_normal = load(skill.image_path)
