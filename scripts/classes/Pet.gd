class_name Pet

var id: int
var name: String
var skin_name: String
var image_path: String
# TODO: add pet skills

func _init(_id: int, _name: String, _skin_name: String, _image_path: String):
	id = _id
	name = _name
	skin_name = _skin_name
	image_path = _image_path

# Convert instance to dictionary for saving
func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"skin_name": skin_name,
		"image_path": image_path
	}

# Static method to create a Pet instance from a dictionary
static func from_dict(data: Dictionary) -> Pet:
	return Pet.new(
		data.get("id", -1),
		data.get("name", ""),
		data.get("skin_name", ""),
		data.get("image_path", "")
	)

static func generate_random_pet() -> Pet:
	var names = ["Jhin", "Jin", "Dhjin", "Jin", "Jinn", "Djiin"]
	var pet_skins = ["Stone", "Rock", "Boulder", "Pebble", "Flint"]
	
	# Choose random values
	var pet_name = names[randi() % names.size()]
	var pet_skin = pet_skins[randi() % pet_skins.size()]
	
	return Pet.new(1, pet_name, pet_skin, "image_path")
