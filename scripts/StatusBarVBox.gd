extends VBoxContainer

const status_effect_scene = preload("res://scenes/StatusEffect.tscn")

func remove_status(status_id: int) -> void:
	var childs: Array = get_children()
	
	for child: StatusNode in childs:
		if child.status.id == status_id:
			remove_child(child)
			child.queue_free()
	
	# Hide when 0 statuses
	if get_children().is_empty():
		$"..".visible = false

func add_status(status_id: int) -> void:
	$"..".visible = true
	var status: StatusEffect = StatusEffect.get_status(status_id)
	
	var new_status_scene := status_effect_scene.instantiate()
	new_status_scene.status = status
	
	add_child(new_status_scene)

func update_statuses_view() -> void:
	remove_all_statuses()
	
	for status_id: int in Global.statuses:
		add_status(status_id)

func remove_all_statuses() -> void:
	for status: StatusNode in get_children():
		remove_child(status)
		status.queue_free()
