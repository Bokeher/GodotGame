class_name Pet

var id: int
var name: String
var pet_skin_name: String
var image_path: String
# TODO: add pet skills

func _init(_id: int, _name: String, _pet_skin_name: String, _image_path: String):
	id = _id
	name = _name
	pet_skin_name = _pet_skin_name
	image_path = _image_path

# Convert instance to dictionary for saving
func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"pet_skin_name": pet_skin_name,
		"image_path": image_path
	}

# Static method to create a Pet instance from a dictionary
static func from_dict(data: Dictionary) -> Pet:
	return Pet.new(
		data.get("id", -1),
		data.get("name", ""),
		data.get("pet_skin_name", ""),
		data.get("image_path", "")
	)
