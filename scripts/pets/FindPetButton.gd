extends Button

func _pressed() -> void:
	Global.pet = Pet.generate_random_pet()
	
	$"..".update_pet_name()
	$"..".update_pet_skin()
