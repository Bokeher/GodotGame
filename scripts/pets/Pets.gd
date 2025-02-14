extends Control

func _ready():
	update_pet_name()
	update_pet_skin()

func update_pet_name():
	$PetName.text = Global.pet.name

func update_pet_skin():
	$PetSkin.text = Global.pet.pet_skin_name
