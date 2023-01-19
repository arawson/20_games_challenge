extends FactionMember

var speed_max = 60.0
var turn_max = 3.0

var turn = 0.0
var velocity = Vector2()

onready var projectiles = $Projectiles
onready var proc_pools = $ProcPools
# these are kept up to date
onready var current_proc_pool = $CurrentProcPool
onready var basic_bullet_scene = load("res://entities/bullets/BasicBullet.tscn")

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
		
		bullet.faction_id = self.faction_id
		bullet.global_position = self.global_position + 20*Vector2(0,-1).rotated(turn)
		bullet.rotation = self.rotation
		bullet.linear_velocity = bullet.linear_velocity.rotated(turn)
		pass
