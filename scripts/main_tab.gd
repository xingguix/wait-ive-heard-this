extends Control

@onready var scene_control: Control = $VBoxContainer/MainSceneControl

func _ready() -> void:
	if OS.get_name() == "Android":
		get_tree().root.content_scale_factor = 1.5

func change_to_id(id: int) -> void:
	var children: Array[Node] = scene_control.get_children()
	if id >= children.size():
		return
	for i in range(children.size()):
		if children[i] is not Control:
			return
		if i == id:
			children[i].show()
			if children[i].has_method("_on_changed"):
				children[i]._on_changed()
		else:
			children[i].hide()
	
