class_name Enemy

var id: int
var name: String
var health: int
var gold_reward: int
var image_url: String
var damage: int

func _init(_id: int, _name: String, _health: int, _gold_reward: int, _image_url: String, _damage: int):
	id = _id
	name = _name
	health = _health
	gold_reward = _gold_reward
	image_url = _image_url
	damage = _damage

# used in saving
func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"health": health,
		"gold_reward": gold_reward,
		"image_url": image_url,
		"damage": damage
	}

# used in reading from savefile
static func from_dict(data: Dictionary) -> Enemy:
	var instance = Enemy.new(
		data.get("id", -1),
		data.get("name", ""),
		data.get("health", 0),
		data.get("gold_reward", 0),
		data.get("image_url", ""),
		data.get("damage", 0)
	)
	
	return instance

func duplicate() -> Enemy:
	return Enemy.new(id, name, health, gold_reward, image_url, damage)
