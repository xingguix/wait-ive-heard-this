extends LineEdit

@onready var search_box: Control = $SearchControl
@export var control: Control

func _on_text_submitted(new_text: String) -> void:
	search(new_text)

func _on_button_pressed() -> void:
	search(self.text)
	
func search(value: String) -> void:
	if value == "":
		return
	search_box.loading = true
	await control.search_and_add(value)
	search_box.loading = false
