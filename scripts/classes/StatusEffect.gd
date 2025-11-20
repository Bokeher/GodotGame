extends Resource

class_name StatusEffect

@export var id: int
@export var name: String
@export var description: String
@export var duration: float
@export var img_path: String
@export var stacks: int = 1

static func get_status(id_: int) -> StatusEffect:
	return Global.statuses.get(id_)
