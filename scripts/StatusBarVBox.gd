extends VBoxContainer

const status_effect_scene = preload("res://scenes/StatusEffect.tscn")

func remove_status(status_id: int) -> void:
	var childs: Array = get_children()
	
	for child: StatusNode in childs:
		if child.status.id == status_id:
			remove_child(child)
			child.queue_free()

func add_status(status_id: int) -> void:
	var status: StatusEffect = Global.get_status(status_id)
	
	var new_status_scene := status_effect_scene.instantiate()
	new_status_scene.status = status
	
	add_child(new_status_scene)
