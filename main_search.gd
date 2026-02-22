extends Control

@onready var card_control: CardControl = $ScrollContainer/VBoxContainer/CardControl
@export var player: AudioStreamPlayer
@onready var double_click_timer: Timer = $DoubleClickTimer

const stared_icon: Texture2D = preload("res://resources/已收藏.svg")
const unstared_icon: Texture2D = preload("res://resources/未收藏.svg")

var searched_word: String = ""



func play_player(audio: AudioStream):
	player.stream = audio
	player.play()


func search_and_add(word: String):
	searched_word = word
	Connector.search_word(word)
	var result = await Connector.request_completed
	card_control.popup_search_word = word
	card_control.resolve_search_result(result)
