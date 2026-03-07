extends Control

@onready var name_ := $Popup/MarginContainer/VBoxContainer/Name
@onready var description := $Popup/MarginContainer/VBoxContainer/Description
@onready var popup_panel := $Popup

var show_timer := Timer.new()
var hide_timer := Timer.new()
var pending_name := ""
var pending_description := ""

enum PopupPosition {
	INVENTORY,
	STATUS_BAR
}

const POSITIONS := {
	PopupPosition.INVENTORY: Vector2i(200, 30),
	PopupPosition.STATUS_BAR: Vector2i(125, 30)
}

func get_popup_position(position_: PopupPosition) -> Vector2i:
	return POSITIONS[position_]

func _ready():
 # Add timers for delayed actions to prevent hiding after showing (happening when elements are really close to each other)
	add_child(show_timer)
	show_timer.one_shot = true
	show_timer.wait_time = 0.05
	show_timer.timeout.connect(_show_popup)
	
	add_child(hide_timer)
	hide_timer.one_shot = true
	hide_timer.wait_time = 0.1
	hide_timer.timeout.connect(_hide_popup)

func popup(popup_name: String, popup_description: String, new_pos: Vector2i = POSITIONS[PopupPosition.INVENTORY]) -> void:
	pending_name = popup_name
	pending_description = popup_description
	$Popup.position = new_pos
	
	$Popup/MarginContainer/VBoxContainer/Description.visible = true
	if popup_description == "":
		$Popup/MarginContainer/VBoxContainer/Description.visible = false
	
	hide_timer.stop()
	show_timer.start()

func hide_() -> void:
	show_timer.stop()
	hide_timer.start()

func _show_popup():
	name_.text = pending_name
	description.text = pending_description
	popup_panel.visible = true

func _hide_popup():
	popup_panel.hide()
