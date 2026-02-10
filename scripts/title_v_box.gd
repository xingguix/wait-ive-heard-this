extends VBoxContainer

@onready var title_h_box: HBoxContainer = $TitleHBox

func _ready() -> void:
	await create_tween().tween_interval(0.01).finished
	play_animation()
	
func play_animation() -> void:
	var tween: Tween = title_h_box.play_h_box_animation()
	$"在歌曲中".self_modulate.a = 0
	tween.tween_property($"在歌曲中", "self_modulate", Color(1, 1, 1, 1), 0.3)
