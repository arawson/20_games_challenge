extends FactionMember

var speed_max = 60.0
var turn_max = 3.0

var turn = 0.0
var velocity = Vector2()

onready var projectiles = $Projectiles
# these are kept up to date
onready var current_proc_pool = $CurrentProcPool
onready var basic_bullet_scene = load("res://entities/bullets/BasicBullet.tscn")
onready var missile_scene = load("res://entities/bullets/Missile.tscn")

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity = Vector2()
	if Input.is_action_pressed("left"):
		turn -= turn_max * delta
	if Input.is_action_pressed("right"):
		turn += turn_max * delta
	
	if Input.is_action_pressed("forward"):
		velocity.y = -speed_max
	if Input.is_action_pressed("backward"):
		velocity.y = +speed_max
	
	velocity = velocity.rotated(turn)
		
	rotation = turn
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("fire"):
		var bullet = basic_bullet_scene.instance()
		projectiles.add_child(bullet)
		
		bullet.global_position = self.global_position + 20*Vector2(0,-1).rotated(turn)
		bullet.rotation = self.rotation
		bullet.linear_velocity = bullet.linear_velocity.rotated(turn)

		_setup_projectile(bullet)
		# bullet.proc_pool.visible = true # THIS CALLS THE SETTER?
		# bullet.get_proc_pool().visible = true # explicitly use the getter to work around the above
		pass

	if Input.is_action_just_pressed("special"):
		var missile = missile_scene.instance()
		projectiles.add_child(missile)

		missile.global_position = self.global_position + 20*Vector2(0,-1).rotated(turn)
		missile.angle = self.rotation - (PI/2) # crud, I've mixed up this terminology
		_setup_projectile(missile)
		# missile.get_proc_pool().visible = true
