extends Node

class StaredLine:
	var line_id: int = -1

var favorites: Array[StaredLine]
var favorites_file_path: String = "user://favorites.txt" # 一行一个line_id



func load_favorites() -> void:
	var file: FileAccess = FileAccess.open(favorites_file_path, FileAccess.READ)
	favorites.clear()
	if not file:
		return
	while not file.eof_reached():
		var csv_row: PackedStringArray = file.get_csv_line()
		# 若添加了东西,别忘改这!⬇️
		if csv_row.size() != 1 or csv_row[0].is_empty():
			continue
		var stared_line: StaredLine = StaredLine.new()
		stared_line.line_id = int(csv_row[0])
		favorites.append(stared_line)
	file.close()

func write_favorites() -> void:
	var file: FileAccess = FileAccess.open(favorites_file_path, FileAccess.WRITE)
	file.store_line("line_id")
	for stared_line in favorites:
		var row: PackedStringArray = [str(stared_line.line_id)]
		file.store_csv_line(row)
	file.close()

func _ready() -> void:
	load_favorites()
