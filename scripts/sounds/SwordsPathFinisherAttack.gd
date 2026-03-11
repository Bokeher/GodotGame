extends AudioStreamPlayer

func reset_pitch() -> void:
	pitch_scale = 1

func play_with_increased_pitch() -> void:
	pitch_scale += 0.02
	play()
