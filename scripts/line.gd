class_name LineLabel extends Label

signal line_pressed(line_id: int)
signal line_double_pressed(line_id: int)

@onready var button = $Button
var line_id: int = -1
var start_time: float
var end_time: float

func format_time(seconds: float) -> String:
	@warning_ignore("integer_division")
	var mins := int(seconds) / 60
	var secs := int(seconds) % 60
	return "%s:%02d" % [mins, secs]

func set_line_text(_text: String):
	text = "· " + _text + "    🕐%s ~ %s" % [format_time(start_time), format_time(end_time)]

func _ready():
	button.gui_input.connect(_on_button_gui_input)

func _on_button_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if event.double_click:
			emit_signal("line_double_pressed", line_id)
		else:
			emit_signal("line_pressed", line_id)
	
