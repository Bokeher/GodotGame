class_name Skill

var id: int
var name: String
var description: String
var image_path: String
var level: int
var max_level: int
var requirement_ids: Array[int]
var grid_position: Array[int]

func _init(_id: int, _name: String, _description: String, _image_path: String, _level: int, _max_level: int, _requirement_ids: Array[int], _grid_position: Array[int]):
	id = _id
	name = _name
	description = _description
	image_path = _image_path
	level = _level
	max_level = _max_level
	requirement_ids = _requirement_ids
	grid_position = _grid_position

# Convert instance to dictionary for saving
func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"image_path": image_path,
		"level": level,
		"max_level": max_level,
		"requirement_ids": requirement_ids,
		"grid_position": grid_position
	}

# Static method to create an instance from a dictionary (used when reading from a save file)
static func from_dict(data: Dictionary) -> Skill:
	#	Numbers in arrays are stored as float (godot thing)
	var requirement_ids_float: Array = data.get("requirement_ids", [])

	var requirement_ids_int: Array[int] = []
	for requirement_id in requirement_ids_float:
		requirement_ids_int.append(int(requirement_id))
	
	var grid_position_float: Array = data.get("grid_position", [0, 0])
	var grid_position_int: Array[int] = [0, 0]
	if grid_position_float.size() == 2:
		grid_position_int = [
			int(grid_position_float[0]),
			int(grid_position_float[1])
		]
	
	return Skill.new(
		data.get("id", -1),
		data.get("name", ""),
		data.get("description", ""),
		data.get("image_path", ""),
		data.get("level", -1),
		data.get("max_level", -1),
		requirement_ids_int,
		grid_position_int,
	)


func get_formatted_description() -> String:
	var formatted_description: String = description
	
	formatted_description = format_skill_levels(formatted_description)
	formatted_description = format_percentage_values(formatted_description)
	
	return formatted_description

func format_skill_levels(text: String) -> String:
	var regex := RegEx.new()
	regex.compile(r"\d+(?:/\d+)+") # 1/2 || 1/2/3 || 1/2/3/4/5 || 1/2/.../9
	
	var matches := regex.search_all(text)
	
	# Loop backwards to not shift indexes
	for i in range(matches.size() - 1, -1, -1):
		var result := matches[i]
		var values := result.get_string().split("/")
		
		var result_text := ""
		for j in range(values.size()):
			if j + 1 == level: # if this is current skill level
				result_text += "[b][color=" + Enums.ColorsHex.SKILL_DESCRIPTION_MAIN + "]" + values[j] + "[/color][/b]"
			else:
				result_text += "[color=" + Enums.ColorsHex.SKILL_DESCRIPTION_SUB + "]" + values[j] + "[/color]"
			
			if j < values.size() - 1:
				result_text += "/"
		
		text = text.substr(0, result.get_start()) + result_text + text.substr(result.get_end())
	
	return text

func format_percentage_values(text: String) -> String:
	var regex := RegEx.new()
	regex.compile(r"\d+%")
	
	var matches := regex.search_all(text)
	for i in range(matches.size() - 1, -1, -1):
		var result := matches[i]
		text = text.substr(0, result.get_start()) + "[color=#6495ED]" + result.get_string() + "[/color]" + text.substr(result.get_end())
	
	return text
