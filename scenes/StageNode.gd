extends Node
class_name StageNode

func on_stage_changed(stage_instance: StageInstance) -> void:
	$BiomeInfo.text = stage_instance.get_stage_name()
