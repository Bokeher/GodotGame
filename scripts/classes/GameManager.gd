extends Node
#class_name GameManager
# AUTOLOAD

var stage: StageInstance
@onready var stage_node: StageNode = get_node("/root/Game/StageNode")

signal stage_changed(stage)

func _ready() -> void:
	stage = StageInstance.new()
	
	stage_changed.connect(stage_node.on_stage_changed)
	
	stage_changed.emit(stage)
