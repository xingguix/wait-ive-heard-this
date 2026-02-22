extends Control

@export var player: AudioStreamPlayer
@onready var card_control: CardControl = $ScrollContainer/CardControl

func _ready() -> void:
	FavoriteManager.favorite_changed.connect(_on_changed)

func play_player(audio: AudioStream):
	player.stream = audio
	player.play()

func _on_changed():
	var favorites: Array[int] = []
	for i in FavoriteManager.favorites:
		favorites.append(i.line_id)
	Connector.get_lines(favorites)
	var result = await Connector.request_completed
	if result is not Array:
		Connector.emit_signal("request_completed", result)
		result = await Connector.request_completed
	card_control.resolve_search_result(result)
