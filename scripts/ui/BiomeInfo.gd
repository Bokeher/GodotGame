extends Label

func _ready() -> void:
	update_biome_name()

func update_biome_name() -> void:
	$".".text = Global.curr_stage.name
