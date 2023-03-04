extends Node


# Randomly picks up to how_many items from the inputs array.
func pick(how_many: int, inputs: Array) -> Array:
	# just going with a dumb implementation because I want to get this working
	# no seriously, this will be really slow if picking from a huge array
	var results: Array = []
	while how_many > 0 and inputs.size() > 0:
		var i: int = randi() % inputs.size()
		results.append(inputs[i])
		inputs.remove(i)
		how_many -= 1
	return results


# Returns a random angle in radians.
func angle() -> float:
	return randf() * TAU