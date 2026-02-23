@tool
extends Control

@export var separator_array: Array[float]
@export var line_height: float
@export var artist_box: HBoxContainer
@export var entire_box: VBoxContainer

func _ready() -> void:
	separator_array.clear()
	await create_tween().tween_interval(0.01).finished
	var artist_position: float = artist_box.position.y + artist_box.size.y + entire_box.position.y + 1
	separator_array.append(artist_position)
	queue_redraw()

func _draw() -> void:
	for i in range(len(separator_array)):
		for x in range(self.size.x):
			var alpha_rate: float = float(x) / float(self.size.x)
			if alpha_rate > 0.5:
				alpha_rate = 1 - alpha_rate
			alpha_rate = clampf(alpha_rate, 0., 0.1)
			var color: Color = Color.DIM_GRAY
			color.a = alpha_rate
			draw_rect(Rect2(x, separator_array[i], 1, line_height), color)
