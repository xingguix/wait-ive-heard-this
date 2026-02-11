class_name Card extends Panel

@export var title: String
@export var artist: String
@export var line: String
@export var line_id: int

func _process(_delta: float) -> void:
	var new_minimize_size_y: float = 0.
	for child in $VBoxContainer.get_children():
		if child is Control:
			new_minimize_size_y += child.size.y
	custom_minimum_size.y = new_minimize_size_y + 20
	$VBoxContainer/SongName/Song.text = title
	$VBoxContainer/Artist/Artist.text = artist
	$VBoxContainer/Line.text = line
