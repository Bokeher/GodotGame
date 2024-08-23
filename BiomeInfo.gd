extends Label

func _ready():
	update_biome_name()

func update_biome_name():
	$".".text = Global.curr_stage.name
