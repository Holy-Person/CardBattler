extends GridContainer

class_name Field



## The size of the field in both directions.
@export var field_size : int = 4
## The fields sorted as [pos.y][pos.x]
var field_list : Array[Array]
## Contains all currently active cards, used to iterate over them.
var cards : Array :
	get:
		cards = cards.filter(func(card): return is_instance_valid(card))
		return cards

## A panel on the field, used for interactions and visuals.
var field_panel = load("res://components/field_panel.tscn")
## A card on the field.
var card_field = load("res://components/card_field.tscn")

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
			move_card_to(selected_card, pos)
			select_card(null)
		FieldPanel.PanelType.ATTACK:
			if !selected_card: return
			selected_card.has_attacked = true
			attack_card_at(selected_card, pos)
			select_card(null)



func select_card(card : CardField) -> void:
	clear_highlights()
	selected_card = card
	if !card: return
	highlight_from_card(card)

func new_turn() -> void:
	selected_card = null
	for card in cards:
		card.has_moved = false
		card.has_attacked = false

func highlight_from_card(card : CardField) -> void:
	for i in field_size * field_size:
		@warning_ignore("integer_division")
		var pos : Vector2i = Vector2i( i % field_size, i / field_size )
		if abs(pos - card.pos).x + abs(pos - card.pos).y  <= card.movement_range && !field_list[pos.y][pos.x].has_card() && !card.has_moved && !card.has_attacked:
			field_list[pos.y][pos.x].set_highlight(Highlight.HighlightType.MOVE)
		elif abs(pos - card.pos).x + abs(pos - card.pos).y  <= card.attack_range && field_list[pos.y][pos.x].has_card() && !card.has_attacked:
			if field_list[pos.y][pos.x].get_card() == card: continue
			field_list[pos.y][pos.x].set_highlight(Highlight.HighlightType.ATTACK)

func clear_highlights() -> void:
	for i in field_size * field_size:
		@warning_ignore("integer_division")
		var pos : Vector2i = Vector2i( i % field_size, i / field_size )
		field_list[pos.y][pos.x].clear_highlight()



func set_card_to(card : CardField, pos : Vector2i) -> void:
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

func attack_card_at(card : CardField, pos : Vector2i) -> void:
	var attacked_card : CardField = field_list[pos.y][pos.x].get_card()
	var tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", field_list[pos.y][pos.x].global_position, 0.125).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished
	attacked_card.damage(card.attack)
	card.damage(attacked_card.attack)
	if card.is_queued_for_deletion(): return
	tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", field_list[card.pos.y][card.pos.x].global_position, 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
