extends Panel

class_name CardField



@export var card_base : CardBase
@export var owner_id : int

## The current position of the card.
var pos : Vector2i



func _ready() -> void:
	if !card_base: return
	$Name.text = card_base.name
	$Image.texture = card_base.image
	$HP/Label.text = str(card_base.health_points)
	$AP/Label.text = str(card_base.attack_points)
