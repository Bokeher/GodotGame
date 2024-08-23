extends Label

func _ready():
	update_biome_info()

func update_biome_info():
	$".".text = Global.get_stage(Global.curr_stage).name
