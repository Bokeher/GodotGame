extends Control

@onready var status: StatusEffect = $".".get_meta("status")
@onready var popup: GlobalPopup = get_node("/root/Game/Popup")
var popupRect2i := Rect2i(175, 31, 0, 0)

func _ready() -> void:
	$Background/Image.texture = load(status.img_path)
	
	if status.duration > 0:
		$Timer.wait_time = status.duration
		
		$Timer.start()

func _on_timer_timeout() -> void:
	pass

func _on_background_mouse_entered() -> void:
	popup.popup(status.name, status.description, popupRect2i)

func _on_background_mouse_exited() -> void:
	popup.hide_()
