extends Node



var card_data : Dictionary



func _ready() -> void:
	card_data = JSON.parse_string( FileAccess.get_file_as_string("res://resources/cards.json") )



func get_random_card(type : String = '') -> CardBase:
	var pickable_data : Dictionary = card_data.duplicate()
	match type:
		"king":
			for data in pickable_data.keys():
				if !pickable_data[data].has("type"):
					pickable_data.erase(data)
					continue
				if pickable_data[data].type != type:
					pickable_data.erase(data)
		_:
			for data in pickable_data.keys():
				if pickable_data[data].has("type"):
					pickable_data.erase(data)
	if pickable_data.is_empty(): return
	var index = randi() % pickable_data.size()
	return _get_card_from_id(pickable_data.keys()[index])

func get_card(id : String) -> CardBase:
	if card_data.has(id): return _get_card_from_id(id)
	return null



func _get_card_from_id(id : String) -> CardBase:
	var card_base = CardBase.new()
	card_base.id = id
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
