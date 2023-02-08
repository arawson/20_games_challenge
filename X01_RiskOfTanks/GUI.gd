extends Control
class_name GUI

# TODO this seems like an OK practice, have a GUI object to front for the entire
# UI and then if I need to change anything I can just change the methods

onready var pickup_label = $CenterContainer/VBoxContainer/PickupLabel

onready var health_bar = $HealthBar
onready var health_text = $HealthBar/HealthLabel

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
	var target: AbilityButton = null
	if slot == BaseUnit.ABILITY_SLOT.LMB:
		target = $HFlowContainer/SlotLMB
	elif slot == BaseUnit.ABILITY_SLOT.SPACE:
		target = $HFlowContainer/SlotSpace
	elif slot == BaseUnit.ABILITY_SLOT.F:
		target = $HFlowContainer/SlotF
	else:
		return

	target.set_ability(ability)

func clear_ability_buttons():
	set_ability_button(BaseUnit.ABILITY_SLOT.F, FactionUtil.ABILITY_NOTHING)
	set_ability_button(BaseUnit.ABILITY_SLOT.SPACE, FactionUtil.ABILITY_NOTHING)
	set_ability_button(BaseUnit.ABILITY_SLOT.LMB, FactionUtil.ABILITY_NOTHING)

func set_health(health: float, max_health: float, precision: int):
	var format = "%%2.%df/%%2.%df" % [precision, precision]
	health_text.text = format % [health, max_health]
	health_bar.max_value = max_health
	health_bar.value = health
