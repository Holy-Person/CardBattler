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

var kings : Dictionary

## A panel on the field, used for interactions and visuals.
var field_panel = load("res://components/field_panel.tscn")

## The currently selected card, used with InteractionType.CARD to control the card.
var selected_card : CardActive

signal field_clicked(pos : Vector2i)



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



func field_click(pos : Vector2i) -> void:
	field_clicked.emit(pos)



func highlight_from_hand(id : String) -> void:
	var card_base : CardBase = CardBuilder.get_card(id)
	match card_base.type:
		"king":
			for i in field_size * field_size:
				@warning_ignore("integer_division")
				var pos : Vector2i = Vector2i( i % field_size, i / field_size )
				if field_list[pos.y][pos.x].has_card(): continue
				field_list[pos.y][pos.x].set_highlight(Highlight.HighlightType.DEPLOY)
		_:
			if !kings.has(multiplayer.get_remote_sender_id()): return
			for i in field_size * field_size:
				@warning_ignore("integer_division")
				var pos : Vector2i = Vector2i( i % field_size, i / field_size )
				if abs(pos - kings[multiplayer.get_remote_sender_id()].pos).x + abs(pos - kings[multiplayer.get_remote_sender_id()].pos).y  <= 2 && !field_list[pos.y][pos.x].has_card():
					field_list[pos.y][pos.x].set_highlight(Highlight.HighlightType.DEPLOY)



func highlight_from_position(pos : Vector2i) -> void:
	if !field_list[pos.y][pos.x].has_card(): return
	var card : CardActive = field_list[pos.y][pos.x].get_card()
	for i in field_size * field_size:
		@warning_ignore("integer_division")
		var loop_pos : Vector2i = Vector2i( i % field_size, i / field_size )
		var loop_panel : FieldPanel = field_list[loop_pos.y][loop_pos.x]
		if abs(loop_pos - pos).x + abs(loop_pos - pos).y  <= card.movement_range && !loop_panel.has_card() && card.can_move():
			loop_panel.set_highlight(Highlight.HighlightType.MOVE)
		elif abs(loop_pos - pos).x + abs(loop_pos - pos).y  <= card.attack_range && loop_panel.has_card() && card.can_attack():
			if loop_pos == pos: continue
			loop_panel.set_highlight(Highlight.HighlightType.ATTACK)

func clear_highlights() -> void:
	for i in field_size * field_size:
		@warning_ignore("integer_division")
		var pos : Vector2i = Vector2i( i % field_size, i / field_size )
		field_list[pos.y][pos.x].clear_highlight()



func set_card_to(card : CardActive, pos : Vector2i) -> void:
	card.owner_id = multiplayer.get_remote_sender_id()
	if card.card_base.type == "king":
		kings[multiplayer.get_remote_sender_id()] = card
	cards.append(card)
	field_list[pos.y][pos.x].set_card(card)
	card.pos = pos
	card.size = field_list[pos.y][pos.x].size
	card.global_position = field_list[pos.y][pos.x].global_position

func move_card_to(card : CardActive, pos : Vector2i) -> void:
	if card.pos != null: field_list[card.pos.y][card.pos.x].set_card(null)
	field_list[pos.y][pos.x].set_card(card)
	card.pos = pos
	var tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", field_list[pos.y][pos.x].global_position, 0.225).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func attack_card_at(card : CardActive, pos : Vector2i) -> void:
	var attacked_card : CardActive = field_list[pos.y][pos.x].get_card()
	var tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", field_list[pos.y][pos.x].global_position, 0.125).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished
	attacked_card.damage(card.attack)
	card.damage(attacked_card.attack)
	if card.is_queued_for_deletion(): return
	tween = get_tree().create_tween()
	tween.tween_property(card, "global_position", field_list[card.pos.y][card.pos.x].global_position, 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
