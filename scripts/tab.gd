@tool
class_name Tab extends Button

@export var tab_name: String = "测试"
@export var tab_texture: Texture = preload("res://icon.svg")

func _process(_delta: float) -> void:
	$Tab/TextureRect.texture = tab_texture
	$Tab/Label.text = tab_name
