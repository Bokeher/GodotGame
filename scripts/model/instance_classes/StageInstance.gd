extends Object
class_name StageInstance

@export var stage_data: StageData

func _init(stage_data_: StageData) -> void:
	stage_data = stage_data_

func get_next_enemy() -> EnemyData:
	var cumulitive: float = 0
	var roll: float = randf()
	
	for spawn_entry in stage_data.spawn_entries:
		cumulitive += spawn_entry.spawn_chance
		
		if cumulitive >= roll:
			return spawn_entry.enemy
	
	print("Failed to get next enemy")
	return null

func get_stage_name() -> String:
	return stage_data.name
