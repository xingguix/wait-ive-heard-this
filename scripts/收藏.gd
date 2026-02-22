extends Control

@export var player: AudioStreamPlayer
@onready var double_click_timer: Timer = $DoubleClickTimer
@onready var menu: PopupMenu = $PopupMenu

class Song:
	var title: String
	var artist: String

var recently_double_clicked: bool = false:
	set(new_value):
		if new_value == true:
			recently_double_clicked = true
			double_click_timer.start()
			await double_click_timer.timeout
			recently_double_clicked = false
		else:
			recently_double_clicked = false
			double_click_timer.stop()

func play_player():
	if recently_double_clicked:
		return
	player.play()



func resolve_search_result(result: Array):
	#for i in result:
		#var card = Card.new_card(i["title"], i["artist"], i["line"], i["line_id"], i["start_time"], i["end_time"])
		#card_control.add_card(card)
		#card.request_line_ogg.connect(request_and_play_line_ogg)
	var song_and_card: Dictionary[Song, Card]
	for i in result:
		var song_card_existed: bool = false
		for j in song_and_card.keys():
			if i["title"] == j.title and i["artist"] == j.artist:
				song_card_existed = true
				song_and_card[j].lines.append(i["line"])
				song_and_card[j].line_ids.append(i["line_id"])
				song_and_card[j].start_times.append(i["start_time"])
				song_and_card[j].end_times.append(i["end_time"])
				break
		if song_card_existed:
			continue
		# 否则就是没有相应的卡片, 直接添加:
		var card = Card.new_card(i["title"], i["artist"], i["line"], i["line_id"], i["start_time"], i["end_time"])
		card.request_line_ogg.connect(request_and_play_line_ogg)
		card.line_double_pressed.connect(_on_line_double_clicked)
		add_card(card)
		var song: Song = Song.new()
		song.title = card.title
		song.artist = card.artist
		song_and_card[song] = card

func request_and_play_line_ogg(line_id: int):
	Connector.get_line_ogg(line_id)
	var result = await Connector.request_completed
	if result is not AudioStreamOggVorbis:
		return
	player.stream = result
	play_player()

func _on_line_double_clicked(line_id: int):
	recently_double_clicked = true
	menu.popup()
	menu.position = get_global_mouse_position()

func add_card(card: Card):
	pass


func refresh():
	pass


func _on_changed():
	pass
