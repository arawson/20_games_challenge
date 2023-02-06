extends FactionMember
class_name BaseUnit

enum ABILITY_SLOT {LMB, SPACE, F}

# TODO is the seperation between BaseUnit and FactionMember necessary?

# TODO move to typed scripted resources in Godot 4
# TODO move into a type dictionary, assuming that's coming in Godot 4 (I shoudl probably check)
export(Resource) var ability_f_base
export(Resource) var ability_space_base
export(Resource) var ability_lmb_base
onready var ability_f: FactionAbility = ability_f_base
onready var ability_space: FactionAbility = ability_space_base
onready var ability_lmb: FactionAbility = ability_lmb_base

# Each of the next 3 functions are the same:
# Create 1 or more projectiles, then return them in the array.
# The controller is responsible for setting up the proc pools and extra effects

# A medium, but aimed, ability that has a medium cooldown and goes over walls
func trigger_ability_f() -> Array:
    # TODO make resource-driven projectile creation abilities
    # do the stuff we need to do to notify our dependants, then return
    return []

# A strong, but un-aimed, ability that generally has a long cool down
func trigger_ability_space() -> Array:
    return []

# A weak, but aimed, ability that generally has a short cool down
func trigger_ability_lmb() -> Array:
    return []

# Movement is handled with just a vector for now
func set_input_direction(_input: Vector2):
    pass

# _ready is sued to perform asserts on the preconditions of the unit
func _ready():
    ._ready()
    assert(ability_f != null)
    assert(ability_space != null)
    assert(ability_lmb != null)
