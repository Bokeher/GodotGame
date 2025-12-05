extends Node
class_name StageVisual

func update(stage_instance: StageInstance) -> void:
	$BiomeInfo.text = stage_instance.get_stage_name()
