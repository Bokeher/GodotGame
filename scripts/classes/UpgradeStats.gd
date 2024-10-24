class_name UpgradeStats

var id: int
var cost: int
var cost_multiplier: float
var level: int

func _init(_id: int, _cost: int, _cost_multiplier: float, _level: int = 0):
	id = _id
	cost = _cost
	cost_multiplier = _cost_multiplier
	level = _level

# used in saving
func to_dict() -> Dictionary:
	return {
		"id": id,
		"cost": cost,
		"cost_multiplier": cost_multiplier,
		"level": level
	}

# used in reading from savefile
static func from_dict(data: Dictionary) -> UpgradeStats:
	var instance = UpgradeStats.new(
		data.get("id", -1),
		data.get("cost", -1),
		data.get("cost_multiplier", -1),
		data.get("level", -1)
	)
	
	return instance
