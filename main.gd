extends Control

@onready var card_control: CardControl = $ScrollContainer/VBoxContainer/CardControl
@onready var player: AudioStreamPlayer = $AudioStreamPlayer

func search_and_add(word: String):
	Connector.search_word(word)
	var result = await Connector.request_completed
	card_control.clear()
	for i in result:
		var card = Card.new_card(i["title"], i["artist"], i["line"], i["line_id"], i["start_time"], i["end_time"])
		card_control.add_card(card)
		card.request_line_ogg.connect(request_and_play_line_ogg)

func request_and_play_line_ogg(line_id: int):
	Connector.get_line_ogg(line_id)
	var result = await Connector.request_completed
	if result is not AudioStreamOggVorbis:
		return
	player.stream = result
	player.play()
	
