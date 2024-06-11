extends PanelContainer

class_name ManaBar



## Container with 10 children to represent mana gauge.
@onready var visual_bar : HBoxContainer = %ManaBar
## Label to display mana_curent/mana_max in numbers.
@onready var visual_label : Label = %ManaLabel

## Maximum amount of mana, capped at 10 and increases by 1 each round.
var mana_max : int = 0
## Current amount of mana, used for various actions during a turn.
var mana_current : int = 0



## Mostly temporary-ish for now. The idea is to replace the texturerects with a custom node and/or auto-generate them.
func _ready() -> void:
	for child in visual_bar.get_children():
		child.self_modulate = Color.TRANSPARENT

	_update_visual()

## Increase mana max by one and reset current mana.
func round_start() -> void:
	if mana_max < 10: mana_max += 1
	mana_current = mana_max
	_update_visual()

## Check if enough mana is available and reduce that amount of mana.
func use_mana(amount : int) -> bool:
	if mana_current >= amount:
		mana_current -= amount
		_update_visual()
		return true
	return false

## Add extra current mana, does not carry over to other rounds.
func add_mana(amount : int) -> void:
	mana_current += amount
	_update_visual()



## Call to sync the visual to the actual values.
func _update_visual() -> void:
	visual_label.text = '%s/%s' % [mana_current, mana_max]
	for i in maxi(visual_bar.get_child_count(), mana_current):
		if i > visual_bar.get_child_count() - 1:
			visual_bar.get_child(i - visual_bar.get_child_count()).self_modulate = Color.CYAN
			continue
		if i < mana_current: visual_bar.get_child(i).self_modulate = Color.WHITE_SMOKE
		elif i < mana_max: visual_bar.get_child(i).self_modulate = Color.WEB_GRAY
		else: visual_bar.get_child(i).self_modulate = Color.TRANSPARENT
