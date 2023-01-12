extends KinematicBody2D

export (float) var run_accel = 30.0
export (float) var run_friction = 30.0
export (float) var max_run_speed = 100.0
export (float) var jump_strength = 400.0
export (float) var gravity = 18.0
export (float) var bouyancy = 2.0
export (float) var water_friction_boost = 1.10
export (float) var water_vertical_friction = 1.10
export (float) var water_dive_accell = 3.0
export (float) var max_dive_speed = 100.0
export (float) var ladder_climb_speed = 100.0

var water_detector
var head_water_detector
var ladder_detector
var ladder_detector_upper
var ladder_detector_lower

var real_velocity = Vector2()
# TODO make this state machine less clunky
var is_in_water = false
var is_on_ladder = false
var is_laddering = false

var debug_check_ladder
var debug_check_ladder_up
var debug_check_ladder_down
var debug_check_ladder_active

var wanted_velocity = Vector2()

const UP = Vector2(0, -1)

# Called when the node enters the scene tree for the first time.
func _ready():
	water_detector = get_node("WaterDetector")
	head_water_detector = get_node("HeadWaterDetector")
	ladder_detector = get_node("LadderDetector")
	ladder_detector_upper = get_node("LadderDetectorUpper")
	ladder_detector_lower = get_node("LadderDetectorLower")

	debug_check_ladder = get_node("HUDGroup/LadderIndicator/CheckBox")
	debug_check_ladder_up = get_node("HUDGroup/LadderIndicatorUp/CheckBox")
	debug_check_ladder_down = get_node("HUDGroup/LadderIndicatorDown/CheckBox")
	debug_check_ladder_active = get_node("HUDGroup/LadderActiveIndicator/CheckBox")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
# What do I want to add?
	# DIMENSIONAL PHASE MECHANICS OOOooooOOO SPPPOOOOOKY GHGOSTY
		# drop through 1 wide tiles
		# rush through pipes

# TODO probably need delta
func _physics_process(_delta):
	var fric = true
	var is_head_in_water = false
	var is_head_on_ladder = false
	var is_ladder_below = false

	wanted_velocity = Vector2()

	# TODO there's probably a better way to collision check in the different layers

	is_in_water = (water_detector.move_and_collide(Vector2.ZERO, true, true, true) != null)
	is_head_in_water = (head_water_detector.move_and_collide(Vector2.ZERO, true, true, true) != null)
	is_on_ladder = (ladder_detector.move_and_collide(Vector2.ZERO, true, true, true) != null)
	is_head_on_ladder = (ladder_detector_upper.move_and_collide(Vector2.ZERO, true, true, true) != null)
	is_ladder_below = (ladder_detector_lower.move_and_collide(Vector2.ZERO, true, true, true) != null)

	debug_check_ladder.visible = is_on_ladder
	debug_check_ladder_up.visible = is_head_on_ladder
	debug_check_ladder_down.visible = is_ladder_below
	debug_check_ladder_active.visible = is_laddering

	var accel = run_accel;
	if is_in_water:
		accel = water_dive_accell

	if Input.is_action_pressed("right"):
		wanted_velocity.x += accel
		fric = false
	if Input.is_action_pressed("left"):
		wanted_velocity.x -= accel
		fric = false
	if Input.is_action_pressed("down") and is_in_water:
		wanted_velocity.y += accel
		fric = false
	if Input.is_action_pressed("up") and is_in_water:
		wanted_velocity.y -= accel
		fric = false
	
	if fric:
		var fricBoost = 1.0
		if is_in_water:
			fricBoost *= water_friction_boost
			if (real_velocity.y > 0):
				real_velocity.y = clamp(real_velocity.y - water_vertical_friction, 0, max_dive_speed)
			if (real_velocity.y < 0):
				real_velocity.y = clamp(real_velocity.y + water_vertical_friction, -max_dive_speed, 0)
		if (real_velocity.x > 0):
			real_velocity.x = clamp(real_velocity.x - run_friction*fricBoost, 0, max_run_speed)
		if (real_velocity.x < 0):
			real_velocity.x = clamp(real_velocity.x + run_friction*fricBoost, -max_run_speed, 0)

	real_velocity.x = clamp(real_velocity.x, -max_run_speed, max_run_speed)
	
	# allow jump if on floor or head is poking out of water
	if Input.is_action_just_pressed("jump") and (is_on_floor() or (!is_head_in_water and is_in_water)):
		wanted_velocity.y -= jump_strength
	
	if !is_in_water:
		real_velocity.y += gravity
	else:
		real_velocity.y -= bouyancy

	if is_laddering:
		wanted_velocity.y = 0
		wanted_velocity.x = 0
		# "ladder state" exit point
		if Input.is_action_pressed("jump"):
			_exit_ladder_state()
			wanted_velocity.y -= jump_strength

		if Input.is_action_pressed("up") and is_on_ladder:
			wanted_velocity.y = -ladder_climb_speed
		if Input.is_action_pressed("down") and is_ladder_below:
			wanted_velocity.y = ladder_climb_speed	

		real_velocity = move_and_slide(wanted_velocity, UP)

	else:
		real_velocity = move_and_slide(wanted_velocity + real_velocity, UP)

	if ((is_on_ladder or is_head_on_ladder) and Input.is_action_pressed("up"))\
	or (is_ladder_below and Input.is_action_pressed("down")):
		# "ladder state" entry point
		# if Input.is_action_pressed("up") or (Input.is_action_pressed("down") and is_ladder_below):
		_enter_ladder_state()
	# TODO move the conditions to automatically exit the ladder state to the `if is_laddering` above
	# else:
	# 	_exit_ladder_state()
		
# TODO could use something to set up easier state-machines
func _enter_ladder_state():
	self.collision_mask = 0
	self.collision_layer = 0
	is_laddering = true

func _exit_ladder_state():
	self.collision_mask = 1
	self.collision_layer = 1
	is_laddering = false
	wanted_velocity.y = 0
