extends Node
#class_name GameManager
# AUTOLOAD

var stage: StageInstance

signal stage_changed(stage: StageInstance)
signal enemy_death(enemy: EnemyInstance)
signal player_death(player: PlayerInstance)

func _ready() -> void:
	stage = StageInstance.new()

func change_stage(stage_id: int) -> void:
	if stage.stage_data.id == stage_id:
		return
	
	stage.set_stage(stage_id)
	stage_changed.emit(stage)
