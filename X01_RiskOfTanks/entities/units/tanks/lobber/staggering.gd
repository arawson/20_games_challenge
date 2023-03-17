extends UnitState

# TODO can this be a generic stagger state?
# TODO can this, spawning, and dieing be a generic delaying state?

onready var searching: UnitState = $"../Searching"

func enter():
	yield(get_tree().create_timer(unit.unit_stats.stagger_delay_base), "timeout")
	_signal_next_state(searching, true)
