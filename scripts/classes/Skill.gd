class_name Skill

var id: int
var name: String
var description: String
var image_path: String
var level: int
var max_level: int
var requirement_ids: Array[int]

func _init(_id: int, _name: String, _description: String, _image_path: String, _level: int, _max_level: int, _requirement_ids: Array[int]):
	id = _id
	name = _name
	description = _description
	image_path = _image_path
	level = _level
	max_level = _max_level
	requirement_ids = _requirement_ids

# Convert instance to dictionary for saving
func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"image_path": image_path,
		"level": level,
		"max_level": max_level,
		"requirement_ids": requirement_ids
	}

# Static method to create an instance from a dictionary (used when reading from a save file)
static func from_dict(data: Dictionary) -> Skill:
	#	Numbers in arrays are stored as float (godot thing)
	var requirement_ids_float: Array = data.get("requirement_ids", [])
	
	var requirement_ids_int: Array[int] = []
	for id in requirement_ids_float:
		requirement_ids_int.append(int(id))
	
	return Skill.new(
		data.get("id", -1),
		data.get("name", ""),
		data.get("description", ""),
		data.get("image_path", ""),
		data.get("level", -1),
		data.get("max_level", -1),
		requirement_ids_int
	)
