extends VBoxContainer

func remove_status(status_id: int) -> void:
	var childs: Array = get_children()
	
	for child: StatusNode in childs:
		if child.status.id == status_id:
			remove_child(child)
			child.queue_free()
