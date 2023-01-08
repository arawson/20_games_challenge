extends Node2D

var ball = null
onready var ball_scene = load("res://Entities/Ball.tscn")

func _ready():
	pass # Replace with function body.

func _destroy_ball():
	if (ball != null):
		remove_child(ball)
		ball.queue_free()
		ball = null

func _on_GameRoot_game_started():
	_destroy_ball()
	ball = ball_scene.instance()
	add_child(ball)
	pass # Replace with function body.


func _on_GameRoot_game_reset():
	_destroy_ball()
	pass # Replace with function body.


func _on_GameRoot_round_reset():
	_on_GameRoot_game_started()
	pass # Replace with function body.
