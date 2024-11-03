class_name Upgrade

var id: int
var name: String
var description: String
var cost: int
var value: int
var cost_multiplier: float
var max_level: int

func _init(_id: int, _name: String, _description: String, _cost: int, _value: int, _cost_multiplier: float, _max_level: int):
	id = _id
	name = _name
	description = _description
	cost = _cost
	value = _value
	cost_multiplier = _cost_multiplier
	max_level = _max_level

# Convert instance to dictionary for saving
func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"cost": cost,
		"value": value,
		"cost_multiplier": cost_multiplier,
		"max_level": max_level
	}

# Static method to create an instance from a dictionary (used when reading from a save file)
static func from_dict(data: Dictionary) -> Upgrade:
	return Upgrade.new(
		data.get("id", -1),
		data.get("name", ""),
		data.get("description", ""),
		data.get("cost", 0),
		data.get("value", 0),
		data.get("cost_multiplier", 1.0),
		data.get("max_level", -1)
	)

func duplicate() -> Upgrade:
	return Upgrade.new(id, name, description, cost, value, cost_multiplier, max_level)
