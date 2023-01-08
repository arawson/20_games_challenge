extends KinematicBody2D

# TODO understand what needs this number to be so large
export var max_velocity = 30000.0

onready var pos_start = position

var is_controllable = false

func _physics_process(delta):
	if (!is_controllable):
		return
	
	var velocity = 0.0
	if Input.is_action_pressed("down"):
		velocity = max_velocity
		pass
	if Input.is_action_pressed("up"):
		velocity = max_velocity * -1.0
		pass
		
	move_and_slide(Vector2(0, velocity * delta), Vector2(1, 0))
	# works around exploit: slide the paddle forward while hitting the ball
	position.x = pos_start.x

func _on_GameRoot_game_reset():
	position = pos_start
	is_controllable = false

func _on_GameRoot_game_started():
	is_controllable = true
