extends Panel

var dragging = false
var last_mouse_position = Vector2()

var zoom_level = 1.0
var zoom_min = 0.3
var zoom_max = 1.5

const skillNode_scene = preload("res://scenes/skills/SkillNode.tscn")

func _ready() -> void:
	var gap: int = 0
	for skill in Global.skills:
		var new_skill = skillNode_scene.instantiate()
		new_skill.set_meta("id", skill.id)
		new_skill.position = Vector2i(gap, 20)
		
		$".".add_child(new_skill)
		
		gap += 150

func _input(event) -> void:
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
