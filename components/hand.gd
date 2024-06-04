extends Control

class_name Hand



@onready var card_root : Control = $CardRoot

var deck : Array[CardBase]
var hand : Array[CardHand]

var card_hand = load("res://components/card_hand.tscn")


func _ready() -> void:
	for i in 20: deck.append(CardBuilder.get_random_card()) # For testing.
	draw_king()
	for i in 3:
		draw_card()


func draw_king() -> void:
	var card_data : CardBase = CardBuilder.get_random_card("king")
	var card : CardHand = card_hand.instantiate()
	card.card_base = card_data
	card_root.add_child(card)
	update_hand_visual()

func draw_card() -> void:
	var card_data : CardBase = deck.pop_front()
	var card : CardHand = card_hand.instantiate()
	card.card_base = card_data
	card_root.add_child(card)
	update_hand_visual()

func place_card_on_field(card : CardActive) -> void:
	hand.erase(card)
	pass

func update_hand_visual() -> void:
	for child in card_root.get_children():
		# The math for this is terrible and doesn't work well with even numbers, going to have to improve this some other time, I am tired.
		child.position.x = ( child.get_index() - float(card_root.get_child_count()) / 2 ) * 250 / card_root.get_child_count()
		child.rotation_degrees = ( child.get_index() - float(card_root.get_child_count()) / 2 ) * 15 / card_root.get_child_count()
	card_root.position.y -= 25
