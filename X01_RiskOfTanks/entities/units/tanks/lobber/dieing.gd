extends UnitState

# TODO can this just be a generic dieing state?

func enter():
	# TODO yield to the death animation
	yield(get_tree().create_timer(0.25), "timeout")
	NodeUtil.delete(unit)
