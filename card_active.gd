extends Control

class_name CardActive



@onready var visual : CardVisual = $CardVisual

@export var card_base : CardBase
@export var owner_id : int

var health : int
var attack : int

var has_moved : bool
var has_attacked : bool

var movement_range : int = 1
var attack_range : int = 1

var was_damaged : bool = false

## The current position of the card.
var pos : Vector2i



func _ready() -> void:
	if !card_base: return

	health = card_base.health_points
	attack = card_base.attack_points

	visual.set_card_base(card_base)



func damage(value : int) -> void:
	if value > 0: was_damaged = true
	health -= value
	visual.refresh()
	if health <= 0:
		die()

func die() -> void:
	queue_free()
