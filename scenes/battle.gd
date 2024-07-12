extends Node

class_name Battle



## Container for the field and all cards on it.
## TODO: Make it resize better, centercontainers only allow minimum size.
@onready var center_field : AspectRatioContainer = %CenterField
@onready var card_root : Control = %Cards
@onready var hand : Hand = $InteractiveRegion/UserUI/Hand

var card_active = preload("res://components/card_active.tscn")

var field : Field

var is_turn : bool

var field_selected_card : CardActive



func _ready() -> void:
	# Temporary, set minimum size of window, current approximate to remain interactable.
	DisplayServer.window_set_min_size(Vector2i(340, 620))
	field = Field.new()
	center_field.add_child(field)
	center_field.move_child(field, 0)

	field.field_clicked.connect(on_field_clicked)
	hand.card_selected.connect(select_card)



func next_turn() -> void:
	field_selected_card = null
	for card in card_root.get_children():
		card.has_moved = false
		card.has_attacked = false

func select_card(card) -> void:
	field.clear_highlights()
	if card is CardActive:
		hand.deselect_card()
		field_selected_card = card
		field.highlight_from_position(card.pos)
	elif card is CardHand:
		field.highlight_from_hand(card.card_base.id)
	else:
		return

func on_field_clicked(pos : Vector2i) -> void:
	var selected_field : FieldPanel = field.field_list[pos.y][pos.x]

	match selected_field.get_type():
		FieldPanel.PanelType.CARD:
			# Check if card is your own here.
			if field_selected_card == selected_field.get_card():
				select_card(null)
				return
			select_card(selected_field.get_card())
		FieldPanel.PanelType.MOVE:
			if !field_selected_card: return
			field_selected_card.has_moved = true
			field.move_card_to(field_selected_card, pos)
			select_card(null)
		FieldPanel.PanelType.ATTACK:
			if !field_selected_card: return
			field_selected_card.has_attacked = true
			field.attack_card_at(field_selected_card, pos)
			select_card(null)
		FieldPanel.PanelType.DEPLOY:
			var card : CardActive = card_active.instantiate()
			card.card_base = hand.selected_card.card_base
			card_root.add_child(card)
			field.set_card_to(card, pos)
			hand.deploy_selected_card()
			select_card(null)

	hand.deselect_card()
