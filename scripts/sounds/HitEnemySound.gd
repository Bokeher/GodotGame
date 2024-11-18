extends AudioStreamPlayer

func change_pitch(isCrit: bool = false) -> void:
	var pitch = randf_range(10, 12) if isCrit else randf_range(0.8, 3)
	
	$".".pitch_scale = pitch
