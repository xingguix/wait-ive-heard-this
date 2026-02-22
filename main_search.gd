extends Control

@onready var card_control: CardControl = $ScrollContainer/VBoxContainer/CardControl
@onready var player: AudioStreamPlayer = $AudioStreamPlayer

class Song:
	var title: String
	var artist: String

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
		card_control.add_card(card)
		var song: Song = Song.new()
		song.title = card.title
		song.artist = card.artist
		song_and_card[song] = card

func search_and_add(word: String):
	Connector.search_word(word)
	var result = await Connector.request_completed
	card_control.clear()
	resolve_search_result(result)
	

func request_and_play_line_ogg(line_id: int):
	Connector.get_line_ogg(line_id)
	var result = await Connector.request_completed
	if result is not AudioStreamOggVorbis:
		return
	player.stream = result
	player.play()
	
