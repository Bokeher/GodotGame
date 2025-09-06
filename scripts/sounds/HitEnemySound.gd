extends AudioStreamPlayer

func change_pitch(is_crit: bool = false) -> void:
	pitch_scale = randf_range(0.8, 3)
	if is_crit:
		pitch_scale = randf_range(10, 12)

func play_with_random_pitch():
	pitch_scale = randf_range(0.8, 3)
	play()
