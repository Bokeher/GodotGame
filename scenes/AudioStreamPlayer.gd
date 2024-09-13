extends AudioStreamPlayer

func change_pitch():
	var pitch = randf_range(0.8, 3)
	$".".pitch_scale = pitch
