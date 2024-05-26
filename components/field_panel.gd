extends PanelContainer

class_name FieldPanel



@onready var button : Button = $Button

var card : CardField



func has_card() -> bool:
	if card: return true
	return false

func get_card() -> CardField:
	return card

func set_card(new_card : CardField) -> void:
	card = new_card
