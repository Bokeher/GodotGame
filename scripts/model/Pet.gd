class_name Pet

var id: int
var name: String
var skin_name: String
var image_path: String

func _init(_id: int = -1, _name: String = "", _skin_name: String = "", _image_path: String = "") -> void:
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
	var names: Array[String] = ["Jhin", "Jin", "Dhjin", "Jin", "Jinn", "Djiin"]
	var pet_skins: Array[String] = ["Stone", "Rock", "Boulder", "Pebble", "Flint"]
	
	# Choose random values
	var pet_name: String = names[randi() % names.size()]
	var pet_skin: String = pet_skins[randi() % pet_skins.size()]
	
	return Pet.new(1, pet_name, pet_skin, "image_path")
