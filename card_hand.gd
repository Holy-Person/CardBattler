extends Control

class_name CardHand



@onready var visual : CardVisual = $CardVisual

@export var card_base : CardBase



func _ready() -> void:
	if !card_base: return
	visual.set_card_base(card_base)
