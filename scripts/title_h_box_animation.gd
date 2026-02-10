extends HBoxContainer

@onready var grand_parent: Control = $"../.."

func play_h_box_animation() -> Tween:
	var children_copies: Array[Label] = []

	# ===== 复制并脱离布局 =====
	for i in get_children():
		if i is Label:
			var new_control: Label = i.duplicate()
			children_copies.append(new_control)

			new_control.position = grand_parent.make_canvas_position_local(i.global_position)
			grand_parent.call_deferred("add_child", new_control)

			i.hide()
			new_control.hide()

	assert(children_copies.size() > 0)

	var tween = create_tween()

	# ===== 基础节奏：逐字淡入 =====
	for label: Label in children_copies:
		label.modulate.a = 0
		label.scale = Vector2(0.92, 0.92)

		tween.tween_callback(label.show)

		tween.parallel().tween_property(label, "modulate:a", 1.0, 0.12)
		tween.parallel().tween_property(label, "scale", Vector2.ONE, 0.12)\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_OUT)

		# ===== 问号专属效果 =====
		if label.text == "？" or label.text == "?":
			label.pivot_offset = label.size / 2
			label.rotation = -0.18

			tween.tween_property(label, "rotation", 0.12, 0.10)
			tween.tween_property(label, "rotation", -0.06, 0.10)
			tween.tween_property(label, "rotation", 0.0, 0.10)

		# 字符之间的节奏间隔
		tween.tween_interval(0.045)

	# ===== 收尾：还原原始节点 =====
	tween.tween_callback(func():
		for i in get_children():
			if i is Label:
				if (i.text == "啊"):
					i.pivot_offset = i.size/2
					i.tween.play()
				i.show()
		for c in children_copies:
			c.queue_free()
	)

	return tween
