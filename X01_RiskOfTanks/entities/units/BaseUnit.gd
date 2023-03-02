extends FactionMember
class_name BaseUnit

enum ABILITY_SLOT {LMB, SPACE, F}

# F: A medium, but aimed, ability that has a medium cooldown and goes over walls
# SPACE: A strong, but un-aimed, ability that generally has a long cool down
# LMB: A weak, but aimed, ability that generally has a short cool down

# TODO is the seperation between BaseUnit and FactionMember necessary?

# TODO move to typed scripted resources in Godot 4
# TODO move into a type dictionary, assuming that's coming in Godot 4 (I should probably check)
export(Resource) var ability_f_base
export(Resource) var ability_space_base
export(Resource) var ability_lmb_base
onready var ability_f: FactionAbility = ability_f_base
onready var ability_space: FactionAbility = ability_space_base
onready var ability_lmb: FactionAbility = ability_lmb_base
var ability_f_time: float = 0.0
var ability_space_time: float = 0.0
var ability_lmb_time: float = 0.0

signal ability_off_cooldown(ability_slot)
signal ability_fired(ability_slot, cooldown)

var abilities: Array = []
var ability_cooldowns: Array = [0.0, 0.0, 0.0]

# Each of the next 3 functions are the same:
# Create 1 or more projectiles, then return them in the array.
# The controller is responsible for setting up the proc pools and extra effects
# ...even though literally everything will have a proc pool
# TODO rethink that

func trigger_ability(slot: int, aim_vector: Vector2) -> Array:
	if not slot in ABILITY_SLOT.values():
		return []
	if ability_cooldowns[slot] > 0:
		return []
	
	var cooldown_calc = abilities[slot].base_cooldown
	ability_cooldowns[slot] = cooldown_calc
	emit_signal("ability_fired", slot, cooldown_calc)

	return _trigger_ability(slot, aim_vector)


func _trigger_ability(_slot: int, _aim_vector: Vector2) -> Array:
	# TODO make resource-driven projectile creation abilities
	return []


# Movement is handled with just a vector for now
func set_input_direction(_input: Vector2):
	pass


# _ready is used to perform asserts on the preconditions of the unit
func _ready():
	._ready()
	assert(ability_f != null)
	assert(ability_space != null)
	assert(ability_lmb != null)
	abilities = [ability_lmb, ability_space, ability_f]


func _physics_process(delta):
	for slot in len(ability_cooldowns):
		if ability_cooldowns[slot] > 0:
			ability_cooldowns[slot] = clamp(ability_cooldowns[slot] - delta, 0, INF)
			# ugh not sure how to reduce this nesting
			if ability_cooldowns[slot] <= 0:
				emit_signal("ability_off_cooldown", slot)


func get_exclusion_radius() -> float:
	return 0.0


func get_velocity() -> Vector2:
	return Vector2.ZERO