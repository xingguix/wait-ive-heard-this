class_name Card extends Panel

func _process(_delta: float) -> void:
	var new_minimize_size_y: float = 0.
	for child in $VBoxContainer.get_children():
		if child is Control:
			new_minimize_size_y += child.size
	custom_minimum_size.y = new_minimize_size_y + 10
