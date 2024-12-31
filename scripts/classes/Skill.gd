class_name Skill

var id: int
var name: String
var description: String
var image_url: String
var max_level: int

func _init(_id: int, _name: String, _description: String, _image_url: String, _max_level: int):
	id = _id
	name = _name
	description = _description
	image_url = _image_url
	max_level = _max_level

# Convert instance to dictionary for saving
func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"image_url": image_url,
		"max_level": max_level
	}

# Static method to create an instance from a dictionary (used when reading from a save file)
static func from_dict(data: Dictionary) -> Skill:
	return Skill.new(
		data.get("id", -1),
		data.get("name", ""),
		data.get("description", ""),
		data.get("image_url", ""),
		data.get("max_level", -1)
	)

