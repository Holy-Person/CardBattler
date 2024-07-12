extends PanelContainer

class_name FieldPanel



@onready var button : Button = $Button
@onready var highlight : Highlight = $Highlight

var card : CardActive

enum PanelType {
	NONE,
	CARD,
	MOVE,
	ATTACK,
	DEPLOY
}

func has_card() -> bool:
	if is_instance_valid(card): return true
	return false

func get_card() -> CardActive:
	return card

func set_card(new_card : CardActive) -> void:
	card = new_card



func get_type() -> PanelType:
	if highlight.type == Highlight.HighlightType.DEPLOY:
		return PanelType.DEPLOY
	if highlight.type == Highlight.HighlightType.MOVE:
		return PanelType.MOVE
	elif highlight.type == Highlight.HighlightType.ATTACK:
		return PanelType.ATTACK
	elif has_card():
		return PanelType.CARD
	return PanelType.NONE


func set_highlight(type : Highlight.HighlightType) -> void:
	highlight.type = type

func clear_highlight() -> void:
	highlight.type = Highlight.HighlightType.NONE



func _draw() -> void:
	if !card: return
	card.set_size(size)
	card.set_global_position(global_position)
