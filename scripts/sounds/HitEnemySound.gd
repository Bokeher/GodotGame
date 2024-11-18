extends AudioStreamPlayer

func change_pitch(is_crit: bool = false) -> void:
	var pitch = randf_range(10, 12) if is_crit else randf_range(0.8, 3)
	
	$".".pitch_scale = pitch
