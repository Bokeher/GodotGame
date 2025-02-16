extends Control

func _ready() -> void:
	update_pet_name()
	update_pet_skin()

func update_pet_name() -> void:
	$PetName.text = Global.pet.name

func update_pet_skin() -> void:
	$PetSkin.text = Global.pet.skin_name
