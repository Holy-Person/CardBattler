extends Panel

class_name CardField



@export var card_base : CardBase
@export var owner_id : int

var health : int
var attack : int

var has_moved : bool
var has_attacked : bool

var movement_range : int = 1
var attack_range : int = 1

## The current position of the card.
var pos : Vector2i



func _ready() -> void:
	_set_data_from_card_base()
	_update_visual()



func _set_data_from_card_base() -> void:
	if !card_base: queue_free()

	$Name.text = card_base.name
	$Image.texture = card_base.image
	$OwnerIndicator.color = Color(0, 0.73, 0.89, 1) if owner_id == 1 else Color(0.78, 0, 0.31, 1)

	health = card_base.health_points
	attack = card_base.attack_points

func _update_visual() -> void:
	$HP/Label.text = str(health)
	if health > card_base.health_points:
		$HP/Label.self_modulate = Color(0, 0.95, 0.47)
	elif health < card_base.health_points:
		$HP/Label.self_modulate = Color(0.99, 0, 0.2)

	$AP/Label.text = str(attack)
	if attack > card_base.attack_points:
		$AP/Label.self_modulate = Color(0, 0.95, 0.47)
	elif attack < card_base.attack_points:
		$AP/Label.self_modulate = Color(0.99, 0, 0.2)

func damage(value : int) -> void:
	health -= value
	_update_visual()
	if health <= 0:
		die()

func die() -> void:
	queue_free()
