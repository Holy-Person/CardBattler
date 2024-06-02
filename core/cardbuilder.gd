extends Node



var card_data : Dictionary



func _ready() -> void:
	card_data = JSON.parse_string( FileAccess.get_file_as_string("res://resources/cards.json") )



func get_random_card() -> CardBase:
	var index = randi() % card_data.size()
	return data_to_card(card_data.values()[index])

func get_card(id : String) -> CardBase:
	if card_data.has(id): return data_to_card(card_data[id])
	return null



func data_to_card(data : Dictionary) -> CardBase:
	var card_base = CardBase.new()
	for field in data:
		if field == "image": data[field] = load("res://Cylinder.png")
		card_base.set(field, data[field])
	return card_base
