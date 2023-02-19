extends Node2D

# What if we create a KinematicBody2D node in the editor but we attach a regular
# Node2D derived script to it? Can we still access the items from KinematicBody2D
# somehow?

# 1. Does Godot throw an error or warning on just attaching the script? No, it launches just fine.
# 2. Can we use move_and_slide without casting? No, it lets us know the method isn't in the current class.
# 3. Can we use move_and_slide with casting? No, weq cannot conver from self to KinematicBody2D.
# 4. Can we use move_and_slide via duck-typing a reference to self? Yes.
# 5. Can we use move_and_slide and a reference via get_node which is casted? Yes.

func _physics_process(delta):
	var velocity = Vector2(0,10)
	# var kinematic_body_2d = self as KinematicBody2D # not OK
	# var kinematic_body_2d = self # yes OK
	var kinematic_body_2d = get_node(".") as KinematicBody2D # yes OK
	
	velocity = kinematic_body_2d.move_and_slide(velocity)
	pass
