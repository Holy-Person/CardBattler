extends GridContainer

class_name Field



## The size of the field in both directions.
@export var field_size : int = 4
## The fields sorted as [pos.y][pos.x]
var field_list : Array[Array]
## Contains all currently active cards, used to iterate over them.
var cards : Array

## A panel on the field, used for interactions and visuals.
var field_panel = load("res://components/field_panel.tscn")
## A card on the field.
var card_field = load("res://components/card_field.tscn")

var interaction_type : int = 1 :
	set(val):
		interaction_type = val
		$"../Label".text = str(InteractionType.keys()[val])

enum InteractionType {
	NONE,
	SELECT,
	CARD
}

## The currently selected card, used with InteractionType.CARD to control the card.
var selected_card : CardField



func _ready() -> void:
	for i in field_size * field_size:
		@warning_ignore("integer_division")
		var pos : Vector2i = Vector2i( i % field_size, i / field_size )
		columns = field_size
		for x in field_size:
			field_list.append([])
		var panel : FieldPanel = field_panel.instantiate()
		add_child(panel)
		panel.button.pressed.connect(field_click.bind(pos))
		field_list[pos.y].append(panel)

	# Add some test cards.
	test.call_deferred()



## Temporary function for testing.
func test() -> void:
	var card_test : CardBase = CardBase.new()
	card_test.name = "Cylinder"
	card_test.image = load("res://Cylinder.png")
	card_test.health_points = 1
	card_test.attack_points = 1
	var card_active : CardField = card_field.instantiate()
	card_active.card_base = card_test
	card_active.owner_id = 1
	$"../Cards".add_child(card_active)
	set_card_to(card_active, Vector2i(1,2))

	card_test = CardBase.new()
	card_test.name = "Torus"
	card_test.image = load("res://Torus.png")
	card_test.health_points = 2
	card_test.attack_points = 0
	card_active = card_field.instantiate()
	card_active.card_base = card_test
	card_active.owner_id = 2
	$"../Cards".add_child(card_active)
	set_card_to(card_active, Vector2i(2,1))



func field_click(pos : Vector2i) -> void:
	var selected_field : FieldPanel = field_list[pos.y][pos.x]

	match interaction_type:
		InteractionType.SELECT:
			if selected_field.has_card():
				selected_card = selected_field.get_card()
				interaction_type = InteractionType.CARD
		InteractionType.CARD:
			interaction_type = InteractionType.SELECT
			if !selected_card: return

			if !selected_field.has_card(): move_card_to(selected_card, pos)
			elif selected_field.get_card() == selected_card: pass
			elif selected_field.has_card(): attack_card_at(selected_card, pos)
			selected_card = null
			return



func set_card_to(card: CardField, pos : Vector2i) -> void:
	#card.owner_id = multiplayer.get_remote_sender_id() # No multiplayer yet.
	cards.append(card)
	field_list[pos.y][pos.x].set_card(card)
	card.pos = pos
	card.global_position = field_list[pos.y][pos.x].global_position

func move_card_to(card : CardField, pos : Vector2i) -> void:
	if card.pos != null: field_list[card.pos.y][card.pos.x].set_card(null)
	field_list[pos.y][pos.x].set_card(card)
	card.pos = pos
	var tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", field_list[pos.y][pos.x].global_position, 0.225).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func attack_card_at(card: CardField, pos : Vector2i) -> void:
	var attacked_card : CardField = field_list[pos.y][pos.x].get_card()
	attacked_card.damage(card.attack)
	card.damage(attacked_card.attack)
	var tween = get_tree().create_tween().set_parallel(false)
	tween.tween_property(card, "global_position", field_list[pos.y][pos.x].global_position, 0.125).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "global_position", field_list[card.pos.y][card.pos.x].global_position, 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	# Deal damage during tween, lock interactions until done.
