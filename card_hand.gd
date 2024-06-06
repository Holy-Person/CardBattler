extends Button

class_name CardHand



@onready var visual : CardVisual = $CardVisual

@export var card_base : CardBase

var hovered : bool = false
var index : int



func _ready() -> void:
	if !card_base: return
	visual.set_card_base(card_base)
	index = get_index()



func _on_mouse_entered() -> void:
	hovered = true
	_highlight()

func _on_mouse_exited() -> void:
	hovered = false
	if button_pressed: return
	_highlight(false)

func _on_toggled(state : bool) -> void:
	if state || hovered: return
	_highlight(false)



var tween : Tween
func _highlight(state : bool = true) -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	if state:
		tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.075)
		move_to_front()
		z_index = 5
	else:
		tween.tween_property(self, "scale", Vector2(1, 1), 0.075)
		get_parent().move_child(self, index)
		z_index = 0
