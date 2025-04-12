extends Node2D

var rotation_duration = 0.5  # Duration to complete one full rotation (in seconds)
var rotation_timer = 0.0  # Timer to track elapsed time
var is_rotating = false  # Flag to check if rotation is in progress
var was_mouse_click_last_frame = false # Used to prevent mouse hold

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	# Follow the mouse position
	$".".position = get_viewport().get_mouse_position()
	
	var cursor_pos = $".".position
	var enemy_size = $"../Enemy/EnemyBody".size
	var enemy_pos = $"../Enemy/EnemyBody".position + $"../Enemy".position
	var enemy_scale = $"../Enemy/EnemyBody".scale
	
	# Rotate the cursor sprite if it's in rotation mode
	if is_rotating:
		rotation_timer += delta
		# Calculate the rotation angle based on the elapsed time
		var rotation_amount = (rotation_timer / rotation_duration) * 360
		$".".rotation_degrees = rotation_amount
		
		# Stop the rotation after the set duration
		if rotation_timer >= rotation_duration:
			is_rotating = false
	
	if (
		cursor_pos.x > (enemy_pos + (enemy_size * enemy_scale)).x ||
		cursor_pos.x < enemy_pos.x ||
		cursor_pos.y < enemy_pos.y ||
		cursor_pos.y > (enemy_pos + (enemy_size * enemy_scale)).y
	):
		$".".visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		return
	
	$".".visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Start rotation when the left mouse button is pressed
	var mouse_clicked = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if mouse_clicked and !is_rotating and !was_mouse_click_last_frame:
		is_rotating = true
		rotation_timer = 0.0  # Reset the timer at the start of the rotation
	
	was_mouse_click_last_frame = mouse_clicked
