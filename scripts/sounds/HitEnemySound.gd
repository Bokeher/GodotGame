extends AudioStreamPlayer

func change_pitch():
	var pitch = randf_range(0.8, 3)
	$".".pitch_scale = pitch

func change_crit_pitch():
	# TODO: custom sound for this
	var pitch = randf_range(10, 12)
	$".".pitch_scale = pitch
