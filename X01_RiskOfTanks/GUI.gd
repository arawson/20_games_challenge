extends Control
class_name GUI

# TODO this seems like an OK practice, have a GUI object to front for the entire
# UI and then if I need to change anything I can just change the methods

onready var pickup_label = $CenterContainer/VBoxContainer/PickupLabel

onready var health_bar = $HealthBar
onready var health_text = $HealthBar/HealthLabel

onready var ability_button_f: AbilityButton = $HFlowContainer/SlotF
onready var ability_button_lmb: AbilityButton = $HFlowContainer/SlotLMB
onready var ability_button_space: AbilityButton = $HFlowContainer/SlotSpace

onready var ability_buttons: Array = [ability_button_lmb, ability_button_space, ability_button_f]

func set_and_show_pickup_label(item: Item):
	pickup_label.text = "Press E to Pick Up %s" % item.pickup_name
	pickup_label.visible = true
	pass

func hide_pickup_label():
	pickup_label.visible = false
	pass

func _ready():
	# $HFlowContainer/AbilityButton.set_ability(load("res://entities/abilities/gun_tank.tres"))
	pass

func set_ability_button(slot: int, ability: FactionAbility):
	if not slot in BaseUnit.ABILITY_SLOT.values():
		return
	ability_buttons[slot].set_ability(ability)

func clear_ability_buttons():
	for s in BaseUnit.ABILITY_SLOT.values():
		set_ability_button(s, FactionUtil.ABILITY_NOTHING)

func activate_ability(slot: int, cooldown: float):
	if not slot in BaseUnit.ABILITY_SLOT.values():
		return
	ability_buttons[slot].start_cooldown(cooldown)

func reset_ability(slot: int):
	# TODO should these all be asserts? for performance on release builds?
	if not slot in BaseUnit.ABILITY_SLOT.values():
		return
	ability_buttons[slot].reset_cooldown()

func set_health(health: float, max_health: float, precision: int):
	var format = "%%2.%df/%%2.%df" % [precision, precision]
	health_text.text = format % [health, max_health]
	health_bar.max_value = max_health
	health_bar.value = health
