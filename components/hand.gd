extends Control

class_name Hand



@onready var card_root : Control = $CardRoot

var cards_in_hand : Array[CardActive]



func _ready() -> void:
	update_hand_visual()



func place_card_on_field(card : CardActive) -> void:
	cards_in_hand.erase(card)
	pass

func update_hand_visual() -> void:
	for child in card_root.get_children():
		# The math for this is terrible and doesn't work well with even numbers, going to have to improve this some other time, I am tired.
		child.position.x = ( child.get_index() - float(card_root.get_child_count()) / 2 ) * 100 / card_root.get_child_count()
		child.rotation_degrees = ( child.get_index() - float(card_root.get_child_count()) / 2 ) * 30 / card_root.get_child_count()
	card_root.position.x = size.x / 2 - 50
	card_root.position.y -= 25
