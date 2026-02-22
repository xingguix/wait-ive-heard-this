extends HBoxContainer

@onready var grand_parent = $"../../.."
const search_scene: PackedScene = preload("res://main_search.tscn")

func _on_tab_pressed(tab_id: int) -> void:
	grand_parent.change_to_id(tab_id)
	

func _on_child_entered_tree(node: Node) -> void:
	if node is Tab:
		node.tab_pressed.connect(_on_tab_pressed)
