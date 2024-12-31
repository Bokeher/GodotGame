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
