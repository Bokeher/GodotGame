extends AudioStreamPlayer

func change_pitch():
	var pitch = randf_range(1.5, 2)
	$".".pitch_scale = pitch
