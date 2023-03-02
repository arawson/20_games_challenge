class_name FactionMember
extends KinematicBody2D

export(int) var faction_id = 0

export(Resource) var unit_stats_base
onready var unit_stats: UnitStats = unit_stats_base

var health_max: float
var health: float
signal health_changed(old_value, new_value)

# Returns if the damage would kill the unit
func do_damage(damage: float) -> bool:
	var starting_health = health
	health = clamp(health - damage, 0, health_max)
	if health != starting_health:
		emit_signal("health_changed", health, health_max)
	if health <= 0:
		health = 0
		return true
	return false

func _ready():
	assert(unit_stats != null)
	# TODO do I even need this assert?
	#assert(faction_id != 0)
	health = unit_stats.base_health
	health_max = unit_stats.base_health
	call_deferred("emit_signal", "health_changed", health_max, health_max)
