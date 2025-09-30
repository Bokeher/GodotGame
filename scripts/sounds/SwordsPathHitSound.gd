extends AudioStreamPlayer

func play_with_random_pitch() -> void:
	pitch_scale = randf_range(0.8, 1.2)
	play()
