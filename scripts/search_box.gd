extends LineEdit

@onready var search_control: Control = $SearchControl
@export var audio_player: AudioStreamPlayer

func _on_text_submitted(new_text: String) -> void:
	search(new_text)

func _on_button_pressed() -> void:
	search(self.text)
	
func search(value: String) -> void:
	if value == "":
		return
	Connector.search_word(value)
	search_control.loading = true
	var result = await Connector.request_completed
	if len(result) <= 0:
		return
	Connector.get_line_ogg(int(result[0]["line_id"]))
	var result2 = await Connector.request_completed
	audio_player.stream = result2
	audio_player.play()
	search_control.loading = false
