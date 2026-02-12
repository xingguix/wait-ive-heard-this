class_name CardControl extends Control

@onready var card_box: VBoxContainer = $CardVBox


func add_card(card: Card):
	# TODO 特效
	card_box.add_child(card)
	
func clear() -> void:
	for i in card_box.get_children():
		# TODO 特效
		i.queue_free()

func _process(_delta: float) -> void:
	self.custom_minimum_size = card_box.get_minimum_size()
