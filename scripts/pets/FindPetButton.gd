extends Button

func _pressed():
	Global.pet = Pet.generate_random_pet()
