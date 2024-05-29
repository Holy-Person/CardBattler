extends Control

class_name Highlight



enum HighlightType {
	NONE,
	MOVE,
	ATTACK
}

var type : int = 0 :
	set(val):
		type = val
		match val:
			HighlightType.NONE:
				hide()
			HighlightType.MOVE:
				modulate = Color.CYAN
				show()
			HighlightType.ATTACK:
				modulate = Color.CRIMSON
				show()



func _draw():
	draw_set_transform(Vector2(0, 15), 0, Vector2(1, 0.75))
	draw_arc(Vector2(0,0), 20, 0, 360, 24, Color.WHITE, 4)
	draw_set_transform(Vector2.ZERO, 0, Vector2(1, 1))
	draw_polygon( ([Vector2(-10, -10), Vector2(0, 10), Vector2(10, -10)]), ([Color.WHITE, Color.SILVER, Color.WHITE]) )
