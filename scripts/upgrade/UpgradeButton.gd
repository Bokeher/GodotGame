extends Button

func _pressed() -> void:
	$"../..".performUpgrade()

func update_cost(cost: int) -> void:
	$".".text = str(cost)
