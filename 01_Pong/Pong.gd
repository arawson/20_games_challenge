extends Node2D

signal game_started
signal game_reset
signal round_reset

# everything here is essentially a global variable
export var score_left = 0
export var score_right = 0
export var score_thresh = 1

onready var splash = get_node("SplashScreen")
onready var spawn_ball = get_node("BallSpawn")

onready var right_win_label = get_node("SplashScreen/PlayerWinLabel")
onready var left_win_label = get_node("SplashScreen/PlayerLoseLabel")

onready var score_left_display = get_node("GameGUI/LeftScore")
onready var score_right_display = get_node("GameGUI/RightScore")

enum player { LEFT, RIGHT }

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.

# it may be possible to do this with signals, but that would be more gucci than
# I want to go
func _set_score_left(s):
	score_left = s
	score_left_display.text = "%d" % score_left
	
func _set_score_right(s):
	score_right = s
	score_right_display.text = "%d" % score_right

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _start_game():
	_set_score_left(0)
	_set_score_right(0)
	left_win_label.visible = false
	right_win_label.visible = false
	splash.visible = false
	emit_signal("game_started")

# I know there's only 1 body that could enter this, the ball
func _on_PlayerGoal_body_entered(body):
	if (body.get_parent() == spawn_ball):
		_set_score_left(score_left + 1)
		emit_signal("round_reset")
		if (score_left >= score_thresh):
			_game_over(player.LEFT)

func _on_CPUGoal_body_entered(body):
	if (body.get_parent() == spawn_ball):
		_set_score_right(score_right + 1)
		emit_signal("round_reset")
		if (score_right >= score_thresh):
			_game_over(player.RIGHT)

func _game_over(side):
	splash.visible = true
	if side == player.LEFT:
		left_win_label.visible = true
		pass
	if side == player.RIGHT:
		right_win_label.visible = true
		pass
	emit_signal("game_reset")
