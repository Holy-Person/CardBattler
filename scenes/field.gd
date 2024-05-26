extends GridContainer

class_name Field



## The fields sorted as [pos.y][pos.x]
var fields : Array[Array] = [ [], [], [], [] ]
var cards : Array

var card_field = load("res://components/card_field.tscn")
var field_panel = load("res://components/field_panel.tscn")

var interaction_type : int = 1 :
	set(val):
		interaction_type = val
		$"../Label".text = str(InteractionType.keys()[val])

enum InteractionType {
	NONE,
	SELECT,
	CARD
}

var selected_card : CardField


func _ready() -> void:
	for i in 16:
		@warning_ignore("integer_division")
		var pos : Vector2i = Vector2i(i % 4, i / 4)
		var panel : FieldPanel = field_panel.instantiate()
		add_child(panel)
		panel.button.text = str(pos)
		panel.button.pressed.connect(field_click.bind(pos))
		fields[pos.y].append(panel)

	test.call_deferred()



func test() -> void:
	var card_test : CardBase = CardBase.new()
	card_test.name = "Cylinder"
	card_test.image = load("res://Cylinder.png")
	card_test.health_points = 1
	card_test.attack_points = 0
	var card_active : CardField = card_field.instantiate()
	card_active.card_base = card_test
	$"../Cards".add_child(card_active)
	set_card_to(card_active, Vector2i(1,2))



func field_click(pos : Vector2i) -> void:
	var selected_field : FieldPanel = fields[pos.y][pos.x]

	match interaction_type:
		InteractionType.NONE:
			return
		InteractionType.SELECT:
			if fields[pos.y][pos.x].has_card():
				selected_card = selected_field.get_card()
				interaction_type = InteractionType.CARD
		InteractionType.CARD:
			if !selected_card:
				interaction_type = InteractionType.SELECT
				return
			if !selected_field.has_card():
				interaction_type = InteractionType.SELECT
				move_card_to(selected_card, pos)
				selected_card = null
				return
			if selected_field.get_card() == selected_card:
				selected_card = null
				interaction_type = InteractionType.SELECT
				return
		_:
			pass



func set_card_to(card: CardField, pos : Vector2i) -> void:
	card.owner_id = multiplayer.get_remote_sender_id()
	cards.append(card)
	fields[pos.y][pos.x].set_card(card)
	card.pos = pos
	card.global_position = fields[pos.y][pos.x].global_position

func move_card_to(card : CardField, pos : Vector2i) -> void:
	if card.pos != null: fields[card.pos.y][card.pos.x].set_card(null)
	fields[pos.y][pos.x].set_card(card)
	card.pos = pos
	var tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", fields[pos.y][pos.x].global_position, 0.225).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
