class_name Item

var id: int
var name: String
var type: int
var description: String
var image_path: String

func _init(_id: int, _name: String, _type: int, _description: String, _image_path: String):
	id = _id
	name = _name
	type = _type
	description = _description
	image_path = _image_path

# Convert instance to dictionary for saving
func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"type": type,
		"description": description,
		"image_path": image_path
	}

static func from_dict(data: Dictionary) -> Item:
	return Item.new(
		data.get("id", -1),
		data.get("name", ""),
		data.get("type", 0),
		data.get("description", ""),
		data.get("image_path", "")
	)
