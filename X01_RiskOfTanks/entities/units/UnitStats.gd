extends Resource
class_name UnitStats

# The basic stats of a unit, granted not every unit type
# will use all the stats, but that's true of every resource
# and every node type in Godot.

export(float) var speed_max = 300.0
export(float) var turn_max = 3.0
export(float) var base_health = 100.0
export(float) var spawn_delay_base = 0.50
export(float) var stagger_delay_base = 0.50
