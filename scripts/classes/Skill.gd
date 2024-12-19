class_name Skill

var id: int
var name: String
var description: String
var max_level: int
var curr_level: int
var img_url: String

func _init(_id: int, _name: String, _description: String, _max_level: int, _curr_level: int, _img_url: String):
	id = _id
	name = _name
	description = _description
	max_level = _max_level
	curr_level = _curr_level
	img_url = _img_url
