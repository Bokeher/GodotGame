class_name Enemy

var id: int
var name: String
var health: int
var gold_reward: int
var image_path: String
var damage: int
var xp_reward: int

func _init(_id: int, _name: String, _health: int, _gold_reward: int, _image_path: String, _damage: int, _xp_reward: int):
	id = _id
	name = _name
	health = _health
	gold_reward = _gold_reward
	image_path = _image_path
	damage = _damage
	xp_reward = _xp_reward

# Used in saving
func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"health": health,
		"gold_reward": gold_reward,
		"image_path": image_path,
		"damage": damage,
		"xp_reward": xp_reward
	}

# Used in reading from savefile
static func from_dict(data: Dictionary) -> Enemy:
	var instance = Enemy.new(
		data.get("id", -1),
		data.get("name", ""),
		data.get("health", 0),
		data.get("gold_reward", 0),
		data.get("image_path", ""),
		data.get("damage", 0),
		data.get("xp_reward", 1)
	)
	
	return instance

func duplicate() -> Enemy:
	return Enemy.new(id, name, health, gold_reward, image_path, damage, xp_reward)

static func set_new_random_enemy() -> void:
	var cumulative_chance = 0.0
	
	var random_value = randf()
	
	for enemy in Global.curr_stage.enemies:
		cumulative_chance += enemy["spawn_chance"]
		if random_value < cumulative_chance:
			var new_enemy_id = enemy["enemy_id"]
			Global.curr_enemy = Global.get_enemy(new_enemy_id)
			return
	
	print("failed to pick new enemy")
	return
