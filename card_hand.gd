extends Control

class_name CardHand



@onready var visual : CardVisual = $CardVisual

@export var card_base : CardBase

var index : int



func _ready() -> void:
	if !card_base: return
	visual.set_card_base(card_base)
	index = get_index()



var tween : Tween
func _on_mouse_entered() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.075)
	move_to_front()
	z_index = 5

func _on_mouse_exited() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.075)
	get_parent().move_child(self, index)
	z_index = 0
