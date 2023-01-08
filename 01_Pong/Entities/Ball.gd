extends KinematicBody2D

var linear_velocity = Vector2()

onready var bounce_sound_player = get_node("BounceSoundPlayer")

func _ready():
	var x = 0
	if (randf() > 0.5):
		x = 300
	else:
		x = -300
	
	var y = (1 - 2*randf()) * 1000
	
	linear_velocity = Vector2(x, y)

func _physics_process(delta):
	# Welcome, to CHAOS PONG!
	var collision = move_and_collide(linear_velocity*delta)
	if (collision != null and collision.collider != null):
		linear_velocity = linear_velocity.bounce(collision.normal)
		linear_velocity *= 1.05
		bounce_sound_player.play()
	pass
