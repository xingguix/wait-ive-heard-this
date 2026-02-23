@tool
class_name Tab extends Button

signal tab_pressed(id: int)

@export var tab_id: int = 0
@export var tab_name: String = "测试"
@export var tab_texture: Texture = preload("res://icon.png")

func _process(_delta: float) -> void:
	$Tab/TextureRect.texture = tab_texture
	$Tab/Label.text = tab_name

func _on_pressed() -> void:
	emit_signal("tab_pressed", tab_id)
