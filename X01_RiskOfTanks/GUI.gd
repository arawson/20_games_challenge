extends Control
class_name GUI

# TODO this seems like an OK practice, have a GUI object to front for the entire
# UI and then if I need to change anything I can just change the methods

onready var pickup_label = $CenterContainer/VBoxContainer/PickupLabel

onready var health_bar = $HealthBar

onready var ability_button_f: AbilityButton = $HFlowContainer/SlotF
onready var ability_button_lmb: AbilityButton = $HFlowContainer/SlotLMB
onready var ability_button_space: AbilityButton = $HFlowContainer/SlotSpace

onready var ability_buttons: Array = [ability_button_lmb, ability_button_space, ability_button_f]

onready var inventory_display = $InventoryDisplay

func _set_and_show_pickup_label(item: ProcItem):
	if item == null:
		pickup_label.visible = false
		return

	pickup_label.text = "Press E to Pick Up %s" % item.pickup_name
	pickup_label.visible = true

func _ready():
	# $HFlowContainer/AbilityButton.set_ability(load("res://entities/abilities/gun_tank.tres"))
	pass

func _set_ability_button(slot: int, ability: FactionAbility):
	if not slot in BaseUnit.ABILITY_SLOT.values():
		return
	ability_buttons[slot].set_ability(ability)

func _clear_ability_buttons():
	for s in BaseUnit.ABILITY_SLOT.values():
		_set_ability_button(s, FactionUtil.ABILITY_NOTHING)

func _activate_ability(slot: int, cooldown: float):
	if not slot in BaseUnit.ABILITY_SLOT.values():
		return
	ability_buttons[slot].start_cooldown(cooldown)

func _reset_ability(slot: int):
	# TODO should these all be asserts? for performance on release builds?
	if not slot in BaseUnit.ABILITY_SLOT.values():
		return
	ability_buttons[slot].reset_cooldown()

# new signal + "interface" approach for handling this

func disconnect_health_bar():
	NodeUtil.disconnect_incoming_connections_for($HealthBar, "set_health")

func connect_health_bar(faction_member: FactionMember):
	disconnect_health_bar()
	if faction_member == null:
		return
	var _x = faction_member.connect("health_changed", $HealthBar, "set_health")

func disconnect_abilities():
	ability_button_f.clear_ability()
	ability_button_space.clear_ability()
	ability_button_lmb.clear_ability()
	NodeUtil.disconnect_incoming_connections_for(self, "_activate_ability")
	NodeUtil.disconnect_incoming_connections_for(self, "_reset_ability")

func connect_abilities(unit: BaseUnit):
	disconnect_abilities()
	if unit == null:
		return
	var _x
	_x = unit.connect("ability_fired", self, "_activate_ability")
	_x = unit.connect("ability_off_cooldown", self, "_reset_ability")
	ability_button_f.set_ability(unit.ability_f)
	ability_button_lmb.set_ability(unit.ability_lmb)
	ability_button_space.set_ability(unit.ability_space)

func connect_player_controller(controller):
	# this is where interfaces shine, preventing these cyclic dependancies
	# but also giving a scaffold to the contracts classes present
	# whether the Godot devs like it or not
	# but I guess we can just guess at which signals are available...
	NodeUtil.disconnect_incoming_connections_for(self, "_set_and_show_pickup_label")
	controller.connect("pickup_in_range", self, "_set_and_show_pickup_label")

func connect_inventory(inventory):
	NodeUtil.disconnect_incoming_connections(inventory_display)
	inventory.connect("added_item", inventory_display, "add_item")
	inventory.connect("removed_item", inventory_display, "remove_item")
