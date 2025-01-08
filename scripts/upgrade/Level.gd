extends Label

func update_level(level: int, max_level: int) -> void:
	var level_text = "Level " + str(level)
	
	if(max_level > 0):
		level_text += " / " + str(max_level) 
	
	$".".text = level_text
