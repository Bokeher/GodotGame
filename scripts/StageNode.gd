extends Node
class_name StageNode

func _ready() -> void:
	GameManager.stage_changed.connect(on_stage_changed)
	
	GameManager.sync()

func on_stage_changed(stage_instance: StageInstance) -> void:
	$BiomeInfo.text = stage_instance.get_stage_name()
