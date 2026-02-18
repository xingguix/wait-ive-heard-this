class_name Card extends Panel

static var scene_file = preload("res://card.tscn")
static var line_file = preload("res://line.tscn")


@onready var line_container: VBoxContainer = $VBoxContainer/LineContainer

@export var title: String
@export var artist: String
@export var lines: Array[String]
@export var line_ids: Array[int]
@export var start_times: Array[int]
@export var end_times: Array[int] # 太乱了 有时间改成数据class

signal request_line_ogg(_line_id: int)

func _process(_delta: float) -> void:
	var new_minimize_size_y: float = 0.
	for child in $VBoxContainer.get_children():
		if child is Control:
			new_minimize_size_y += child.size.y
	custom_minimum_size.y = new_minimize_size_y + 60
	$VBoxContainer/SongName/Song.text = title
	$VBoxContainer/Artist/Artist.text = artist
	var line_labels: Array[Node] = line_container.get_children()
	if len(line_labels) < len(lines):
		for _i in range(len(lines)-len(line_labels)):
			var new_line: LineLabel = line_file.instantiate()
			new_line.on_line_pressed.connect(_on_line_pressed)
			line_container.add_child(new_line)
			line_labels.append(new_line)
			
	elif len(line_labels) > len(lines):
		for i in range(len(line_labels) - len(lines)):
			line_container.remove_child(line_labels.pop_front())
	
	for i in range(len(lines)):
		if line_labels[i] is LineLabel:
			line_labels[i].set_line_text(lines[i])
			line_labels[i].line_id = line_ids[i]
			# 确保id和line顺序一致!
			line_labels[i].start_time = start_times[i]
			line_labels[i].end_time = end_times[i]


static func new_card(new_title: String, new_artist: String, new_line: String, new_line_id: int, new_start_time: float, new_end_time: float) -> Card:
	var card: Card = scene_file.instantiate()
	card.title = new_title
	card.artist = new_artist
	card.lines = [new_line]
	card.line_ids = [new_line_id]
	card.start_times = [new_start_time]
	card.end_times = [new_end_time]
	return card


func _on_line_pressed(line_id: int) -> void:
	emit_signal("request_line_ogg", line_id)
