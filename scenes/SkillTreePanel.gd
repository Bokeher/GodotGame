extends Panel

var dragging = false
var last_mouse_position = Vector2()

var zoom_level = 1.0
var zoom_min = 0.5
var zoom_max = 2.0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				last_mouse_position = event.position
			else:
				dragging = false

	if event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_position
		position += delta
		last_mouse_position = event.position

	if event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_level = clamp(zoom_level * 1.1, zoom_min, zoom_max)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_level = clamp(zoom_level / 1.1, zoom_min, zoom_max)
		scale = Vector2(zoom_level, zoom_level)
