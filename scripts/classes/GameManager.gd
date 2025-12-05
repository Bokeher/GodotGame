extends Node
#class_name GameManager
# AUTOLOAD

var stage: StageInstance = StageInstance.new()
@onready var stage_visual: StageVisual = get_node("/root/Game/StageVisual")

func _ready() -> void:
	stage.set_stage(Global.player.max_stage_reached)
	stage_visual.update(stage)
