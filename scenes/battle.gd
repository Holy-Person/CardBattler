extends Node

class_name Battle



## Container for the field and all cards on it.
## TODO: Make it resize better, centercontainers only allow minimum size.
@onready var center_field : AspectRatioContainer = %CenterField
@onready var card_root : Control = %Cards
@onready var hand : Hand = $InteractiveRegion/UserUI/Hand

var field : Field

var is_turn : bool

var selected_card



func _ready() -> void:
	# Temporary, set minimum size of window, current approximate to remain interactable.
	DisplayServer.window_set_min_size(Vector2i(340, 620))
	field = Field.new()
	center_field.add_child(field)



func next_turn() -> void:
	selected_card = null
	for card in card_root.get_children():
		card.has_moved = false
		card.has_attacked = false

func select_card(card : CardActive) -> void:
	field.clear_highlights()
	selected_card = card
	if !card: return
	field.highlight_from_position(card.pos)

func on_field_clicked(pos : Vector2i) -> void:
	var selected_field : FieldPanel = field.field_list[pos.y][pos.x]

	match selected_field.get_type():
		FieldPanel.PanelType.CARD:
			# Check if card is your own here.
			if selected_card == selected_field.get_card():
				select_card(null)
				return
			select_card(selected_field.get_card())
		FieldPanel.PanelType.MOVE:
			if !selected_card: return
			selected_card.has_moved = true
			field.move_card_to(selected_card, pos)
			select_card(null)
		FieldPanel.PanelType.ATTACK:
			if !selected_card: return
			selected_card.has_attacked = true
			field.attack_card_at(selected_card, pos)
			select_card(null)
		FieldPanel.PanelType.DEPLOY:
			# Might need to migrate the paneltype into a fieldtype/paneltype system next time.
			# - Otherwise cards can still be selected while deploying a card.
			# - Other solution could be to make selecting a card clear any focus in the hand as well.

			pass


func _on_hand_card_selected(card) -> void:
	pass # Replace with function body.
