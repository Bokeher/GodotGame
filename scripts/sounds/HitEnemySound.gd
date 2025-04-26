extends AudioStreamPlayer

func change_pitch(is_crit: bool = false) -> void:
	var pitch = randf_range(0.8, 3)
	if is_crit:
		pitch = randf_range(10, 12)
	
	$".".pitch_scale = pitch
