extends Procable

func _ready():
	pass

func is_on_hit() -> bool:
	return true
	
func is_on_kill() -> bool:
	return false

func roll_on_hit(_faction_member: FactionMember, _proc_pool) -> bool:
	# Normally, you would want a probability to roll here
	return true

func do_on_hit(_faction_member: FactionMember, _new_proc_pool) -> void:
	# reveal the dynamo's collision to start a new proc pool
	print("dynamo effect")
	pass
