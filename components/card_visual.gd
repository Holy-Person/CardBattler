extends Panel

class_name CardVisual



@onready var image : TextureRect = $Image
@onready var owner_indicator : ColorRect = $OwnerIndicator
@onready var hp : Label = $HP/Label
@onready var ap : Label = $AP/Label
@onready var cost : Label = $Cost/Label
@onready var cost_icon : ColorRect = $Cost
@onready var shimmer : ColorRect = $Control/ColorRect

var card_base : CardBase



func set_card_base(base : CardBase) -> void:
	card_base = base
	update_initial()
	refresh()

func update_initial() -> void:
	$Name.text = card_base.name
	image.texture = card_base.image
	cost.text = str(card_base.cost)
	owner_indicator.color = Color(0, 0.73, 0.89, 1) if get_parent().owner_id == 1 else Color(0.78, 0, 0.31, 1)



func refresh() -> void:
	if get_parent() is CardActive:
		cost_icon.hide()
		update_active()
	#elif get_parent() is CardHand:
	#	pass



func update_active() -> void:
	var card : CardActive = get_parent()

	hp.text = str(card.health)
	ap.text = str(card.attack)
	if card.was_damaged: hp.self_modulate = Color(0.99, 0, 0.2)
	elif card.health > card_base.health_points: hp.self_modulate = Color(0, 0.95, 0.47)

	if card.attack > card_base.attack_points: ap.self_modulate = Color(0, 0.95, 0.47)

func update_hand() -> void:
	#var card : CardHand = get_parent()
	hp.text = str(card_base.health_points)
	ap.text = str(card_base.attack_points)



func _physics_process(delta: float) -> void:
	if !get_parent() is CardActive: return
	var card : CardActive = get_parent()
	self_modulate = Color(0.65, 0.65, 0.65) if card.has_attacked else Color.WHITE
	image.self_modulate = self_modulate
	shimmer.visible = false if card.has_moved || card.has_attacked else true
	if shimmer.position.y < -250: shimmer.position.y = 125
	shimmer.position.y -= delta * 350
