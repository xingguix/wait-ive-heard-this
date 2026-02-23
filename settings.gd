extends Node



func _ready() -> void:
	if OS.get_name() == "Android":
		get_tree().root.content_scale_factor = 1.5
