extends Label

var tween: Tween

func _ready() -> void:
	tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "rotation", PI/60, 3)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(
		func ():
			self.rotation = PI/60)
	tween.tween_property(self, "rotation", -PI/60, 3)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	tween.pause()
