extends Control

# TODO this seems like an OK practice, have a GUI object to front for the entire
# UI and then if I need to change anything I can just change the methods

onready var pickup_label = $CenterContainer/VBoxContainer/PickupLabel

func set_and_show_pickup_label(item: Item):
	pickup_label.text = "Press E to Pick Up %s" % item.pickup_name
	pickup_label.visible = true
	pass

func hide_pickup_label():
	pickup_label.visible = false
	pass

func _ready():
	$HFlowContainer/AbilityButton.set_ability(load("res://entities/abilities/gun_tank.tres"))
