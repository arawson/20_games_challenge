class_name FactionMember
extends KinematicBody2D

export(int) var faction_id = 0

export(Resource) var unit_stats_base
onready var unit_stats: UnitStats = unit_stats_base

var health: float

# Returns if the damage would kill the unit
func do_damage(damage: float) -> bool:
	health -= damage
	if health < 0:
		health = 0
		print("%s died" % self)
		return true
	return false

# _ready is used to enforce the preconditions on the member
func _ready():
	assert(unit_stats != null)
	assert(faction_id != 0)
	health = unit_stats.base_health
