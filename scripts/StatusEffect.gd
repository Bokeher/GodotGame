extends Control
class_name StatusNode

@onready var status: StatusEffect = $".".get_meta("status")
var popupRect2i := Rect2i(175, 31, 0, 0)

func _ready() -> void:
	$Background/Image.texture = load(status.img_path)
	
	if status.duration > 0:
		$Timer.wait_time = status.duration
		
		$Timer.start()

func update_stack_count() -> void:
	$Background/Image/StackCount.text = ""
	if status.stacks > 1:
		$Background/Image/StackCount.text = str(status.stacks)
	

func increase_stack() -> void:
	status.stacks += 1
	update_stack_count()

func decrease_stack() -> void:
	if status.stacks > 1:
		status.stacks -= 1
		update_stack_count()
		return
	
	get_parent().remove_status(status.id)

func _on_timer_timeout() -> void:
	decrease_stack()

func _on_background_mouse_entered() -> void:
	GlobalPopup.popup(status.name, status.description, popupRect2i)

func _on_background_mouse_exited() -> void:
	GlobalPopup.hide_()
