class_name Card extends Panel

static var scene_file = preload("res://card.tscn")

@export var title: String
@export var artist: String
@export var line: String
@export var line_id: int
@export var start_time: float
@export var end_time: float

signal request_line_ogg(_line_id: int)

func _process(_delta: float) -> void:
	var new_minimize_size_y: float = 0.
	for child in $VBoxContainer.get_children():
		if child is Control:
			new_minimize_size_y += child.size.y
	custom_minimum_size.y = new_minimize_size_y + 60
	$VBoxContainer/SongName/Song.text = title
	$VBoxContainer/Artist/Artist.text = artist
	$VBoxContainer/Line.set_line_text(line)

static func new_card(new_title: String, new_artist: String, new_line: String, new_line_id: int, new_start_time: float, new_end_time: float) -> Card:
	var card: Card = scene_file.instantiate()
	card.title = new_title
	card.artist = new_artist
	card.line = new_line
	card.line_id = new_line_id
	card.start_time = new_start_time
	card.end_time = new_end_time
	return card


func _on_play_button_pressed() -> void:
	emit_signal("request_line_ogg", line_id)
