extends CenterContainer

class_name Hand



@onready var card_root : Control = $CardRoot

var deck : Array[CardBase]

var card_hand = load("res://components/card_hand.tscn")
var card_group : ButtonGroup = ButtonGroup.new()


func _ready() -> void:
	card_group.set_allow_unpress(true)
	for i in 20: deck.append(CardBuilder.get_random_card()) # For testing.
	draw_king()
	for i in 3:
		draw_card()


func draw_king() -> void:
	var card_data : CardBase = CardBuilder.get_random_card("king")
	var card : CardHand = card_hand.instantiate()
	card.card_base = card_data
	card_root.add_child(card)
	card.button_group = card_group
	card.toggled.connect(select_card.bind(card))
	update_hand_visual()

func draw_card() -> void:
	var card_data : CardBase = deck.pop_front()
	var card : CardHand = card_hand.instantiate()
	card.card_base = card_data
	card_root.add_child(card)
	card.button_group = card_group
	card.toggled.connect(select_card.bind(card))
	update_hand_visual()

#func place_card_on_field(card : CardActive) -> void:
#	hand.erase(card)

func select_card(state : bool, card : CardHand) -> void:
	if !state:
		get_tree().current_scene.field.clear_highlights()
		return
	get_tree().current_scene.field.highlight_from_hand(card.card_base.id)

func update_hand_visual() -> void:
	for child in card_root.get_children():
		# The math for this is terrible and doesn't work well with even numbers, going to have to improve this some other time, I am tired.
		child.position.x = ( child.get_index() - float(card_root.get_child_count()) / 2 ) * 250 / card_root.get_child_count()
		child.rotation_degrees = ( child.get_index() - float(card_root.get_child_count()) / 2 ) * 15 / card_root.get_child_count()
