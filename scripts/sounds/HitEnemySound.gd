extends AudioStreamPlayer

func change_pitch() -> void:
	var pitch = randf_range(0.8, 3)
	$".".pitch_scale = pitch

func change_crit_pitch() -> void:
	# TODO: custom sound for this
	var pitch = randf_range(10, 12)
	$".".pitch_scale = pitch
