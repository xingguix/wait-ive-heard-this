extends Control

@onready var scene_control: Control = $VBoxContainer/MainSceneControl


func change_to_id(id: int) -> void:
	var children: Array[Node] = scene_control.get_children()
	if id >= children.size():
		return
	for i in range(children.size()):
		if children[i] is not Control:
			return
		if i == id:
			children[i].show()
		else:
			children[i].hide()
	
