extends KinematicFactionProjectile

# A missile projectile travels in a straight line until its Homing Area2D
# picks up a FactionMember to track.

# TODO can this be moved to some armable projectile class?
export(float) var arm_time: float = 0.1
export(float) var lifetime_max: float = 3
export(float) var angle_speed = 0.5
export(float) var speed = 2.0
export(float) var angle = 0.0

onready var homing : Area2D = $Homing

func _ready():
	pass

func _physics_process(delta):
	rotation = angle
	# do movement always
	# do our "AI" to seek towards the nearest FactionMember not matching our FactionID
	var current_target: FactionMember = null
	var current_distance2: float = 0.0
	for b in homing.get_overlapping_bodies():
		var faction_member: FactionMember = b as FactionMember
		if faction_member == null:
			continue
		if faction_member.faction_id == faction_id:
			continue
		if current_target == null:
			current_target = faction_member
			current_distance2 = position.distance_squared_to(current_target.position)
			continue
		var distance2 = position.distance_squared_to(faction_member.position)
		if (distance2 < current_distance2):
			current_target = faction_member
			current_distance2 = distance2
			continue
		pass
	
	# turn to face current target
	if current_target != null:
		var angle_to_t = current_target.position.angle_to_point(position)
		# var angle_to_t = position.angle_to_point(current_target.position)
		if (angle < angle_to_t):
			angle += angle_speed * delta
		if (angle > angle_to_t):
			angle -= angle_speed * delta
	
	var vel: Vector2 = Vector2(speed * cos(angle), speed * sin(angle))

	var collision: KinematicCollision2D = move_and_collide(vel)
	
	# skip collisions unless we are armed
	if (arm_time >= 0):
		arm_time -= delta
		return

	# skip collisions if we are deleting ourself
	lifetime_max -= delta
	if lifetime_max <= 0:
		Util.delete_node(self)
		return

	if collision != null:
		if do_proc_on(collision.collider):
			Util.delete_node(self)
