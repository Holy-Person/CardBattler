extends Node



var card_data : Dictionary



func _ready() -> void:
	card_data = JSON.parse_string( FileAccess.get_file_as_string("res://resources/cards.json") )



func get_random_card() -> CardBase:
	var index = randi() % card_data.size()
	return get_card_from_id(card_data.keys()[index])

func get_card(id : String) -> CardBase:
	if card_data.has(id): return get_card_from_id(id)
	return null



func get_card_from_id(id : String) -> CardBase:
	var card_base = CardBase.new()
	var data : Dictionary = card_data[id]
	for field in data:
		match field:
			"image":
				data[field] = load(data[field])
		card_base.set(field, data[field])

	if !card_base.image:
		if FileAccess.file_exists('res://images/%s.png' % [id]): card_base.image = load('res://images/%s.png' % [id])
		else:
			card_base.image = load('res://images/error.png')
			card_base.tint = Color.RED
	return card_base
