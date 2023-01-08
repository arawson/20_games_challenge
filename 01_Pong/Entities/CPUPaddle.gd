extends KinematicBody2D

export(NodePath) var ball_spawn_path
export var max_velocity = 30000.0

onready var pos_start = position
onready var ball_spawn = get_node(ball_spawn_path)

var is_controllable = false

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if !is_controllable:
		return
		
	var balls = ball_spawn.get_children()
	var balls_nearest = null
	var balls_nearest_distance = INF
	var ball_pos = Vector2()
	var self_pos = self.global_transform.origin
	
	for ball in balls:
		ball_pos = ball.global_transform.origin
		var distance = self_pos.distance_to(ball_pos)
		if distance < balls_nearest_distance:
			balls_nearest = ball
			
	if balls_nearest == null:
		return
	
	var desired_yvel = 0
	if self_pos.y > ball_pos.y + 10:
		desired_yvel = -max_velocity
	if self_pos.y < ball_pos.y - 10:
		desired_yvel = +max_velocity
	
	move_and_slide(Vector2(0, desired_yvel * delta), Vector2(1, 0))
	position.x = pos_start.x

func _on_GameRoot_game_reset():
	position = pos_start
	is_controllable = false

func _on_GameRoot_game_started():
	is_controllable = true
