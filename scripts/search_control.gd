extends Control


var loading: bool = false
var tween: Tween

@onready var loading_icon: TextureRect = $Loading
@onready var button: Button = $Button

func _ready() -> void:
	loading_icon.pivot_offset = loading_icon.size/2
	tween = create_tween()
	tween.set_loops()
	tween.tween_property(loading_icon, "rotation", 2*PI, 1.5)
	tween.tween_callback(func ():
		loading_icon.rotation = 0
		)
	tween.pause()

func _process(_delta: float) -> void:
	if loading:
		loading_icon.show()
		button.hide()
		tween.play()
	else:
		loading_icon.hide()
		button.show()
		tween.pause()
