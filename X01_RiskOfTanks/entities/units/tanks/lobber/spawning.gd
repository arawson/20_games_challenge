extends UnitState

# TODO can this just be a generic spawn stun state? it doesn't do much other than delay
onready var searching: UnitState = $"../Searching"

func enter():
	yield(get_tree().create_timer(unit.unit_stats.spawn_delay_base), "timeout")
	_signal_next_state(searching)
	
