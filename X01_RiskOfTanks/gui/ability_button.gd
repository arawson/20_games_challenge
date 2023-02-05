extends Control

export(String) var key_helper = "F"

onready var countdown = $Panel/Countdown
onready var wiper = $Panel/Wiper
onready var dimmer = $Panel/AbilityIcon/Dimmer

onready var wiper_max_y: float = wiper.rect_position.y
onready var wiper_min_y: float = 0.0

var cooldown: float = 1.0
var cooldown_remaining: float = 0.0

func _ready():
	# TODO: is there a way to skip this set in the _ready?
	$TextureRect/Key.text = key_helper

func set_ability(ability: FactionAbility):
	$Panel/AbilityIcon.texture = ability.icon

# Trigger the cooldown
func start_cooldown(seconds: float):
	cooldown = seconds
	cooldown_remaining = seconds
	dimmer.visible = true
	wiper.visible = true
	countdown.visible = true

func reset_cooldown():
	# _process will take care of the rest
	cooldown_remaining = 0.01

func _process(delta):
	if (cooldown_remaining > 0.0):
		cooldown_remaining -= delta
		var frac: float = cooldown_remaining / cooldown

		# Mimic Risk of Rain 2:
		# Set the wiper's position based on the fraction passed in
		# as a part of the AbilityIcon's total vertical size.
		# Since the offsets are relative to the parent (Panel), we
		# shortcut this by using the starting position and 0.
		wiper.rect_position.y = frac * (wiper_max_y - wiper_min_y)

		# Display the seconds left in the cooldown, to the tenths place
		countdown.text = "%2.1f" % cooldown_remaining
		
		# yeah yeah, checking the cooldown again...
		if (cooldown_remaining <= 0):
			dimmer.visible = false
			wiper.visible = false
			countdown.visible = false
