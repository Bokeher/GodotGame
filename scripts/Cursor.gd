extends Node2D

@onready var cursor_sprite = $"."  # Reference to the cursor sprite
var rotation_duration = 0.5  # Duration to complete one full rotation (in seconds)
var rotation_timer = 0.0  # Timer to track elapsed time
var is_rotating = false  # Flag to check if rotation is in progress

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Hide default cursor

func _process(delta):
	# Follow the mouse position
	cursor_sprite.position = get_viewport().get_mouse_position()

	# Start rotation when the left mouse button is pressed
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !is_rotating:
		is_rotating = true
		rotation_timer = 0.0  # Reset the timer at the start of the rotation

	# Rotate the cursor sprite if it's in rotation mode
	if is_rotating:
		rotation_timer += delta
		# Calculate the rotation angle based on the elapsed time
		var rotation_amount = (rotation_timer / rotation_duration) * 360
		cursor_sprite.rotation_degrees = rotation_amount
		
		# Stop the rotation after the set duration
		if rotation_timer >= rotation_duration:
			is_rotating = false
