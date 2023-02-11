extends BaseUnit

var speed_max = 300.0
var speed_boost = 1.0
var turn_max = 3.0
var turn_boost = 1.0

var turn = 0.0
var velocity = Vector2()

var _input_direction: Vector2 = Vector2()

var _trigger_fns: Array = []

func _ready():
	._ready()
	_trigger_fns = [\
		funcref(self, "trigger_ability_lmb"),\
		funcref(self, "trigger_ability_space"),\
		funcref(self, "trigger_ability_f")
	]

func _trigger_ability(slot: int, aim_vector: Vector2) -> Array:
	return _trigger_fns[slot].call_func(aim_vector)

func trigger_ability_space(_aim_vector: Vector2) -> Array:
	# TODO move these to be resource driven
	var bullet = Projectiles.BULLET.instance() as FactionProjectile
	bullet.global_position = self.global_position + 20*Vector2(0,-1).rotated(turn)
	bullet.rotation = self.rotation
	bullet.linear_velocity = bullet.linear_velocity.rotated(turn)
	# _setup_projectile(bullet) TODO move _setup_projectile call to BaseCdontroller
	# TODO document this: bullet.proc_pool.visible = true # THIS CALLS THE SETTER?
	# bullet.get_proc_pool().visible = true # explicitly use the getter to work around the above
	return [bullet]
	
func trigger_ability_f(aim_vector: Vector2) -> Array:
	var missile = Projectiles.MISSILE.instance()
	missile.global_position = self.global_position + (40 * aim_vector)
	missile.rotation = Vector2.ZERO.angle_to_point(aim_vector) + PI
	#TODO this is where the resource-based setup would go
	return [missile]

func trigger_ability_lmb(_aim_vector: Vector2) -> Array:
	# TODO some lmb ability for TankA, like a little pew-pew gun
	return []

func set_input_direction(input: Vector2):
	# TankA uses forward/reverse with turning, like a car
	# (one that can turn in place)
	# TODO: can I skip this step of indirection and just call move_and_slide from the controller?
	_input_direction = input

func _physics_process(delta):
	#._physics_process(delta) this gets called automatically
	velocity = Vector2()

	turn += _input_direction.x * turn_max * delta * turn_boost
	velocity.y = _input_direction.y * speed_max * speed_boost
	turn = wrapf(turn, -PI, +PI)
	
	velocity = velocity.rotated(turn)
	rotation = turn
	velocity = move_and_slide(velocity)
