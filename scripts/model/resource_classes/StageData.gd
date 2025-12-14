extends Resource
class_name StageData

@export var id: int
@export var name: String
@export var texture: Texture2D
@export var spawn_entries: Array[SpawnEntry]

func are_spawn_entries_valid() -> bool:
	var sum: float = 0.0
	for entry in spawn_entries:
		sum += entry.spawn_chance
	
	return abs(sum - 1.0) <= 0.001
