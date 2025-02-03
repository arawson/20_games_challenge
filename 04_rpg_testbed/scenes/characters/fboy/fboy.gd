extends CharacterBody2D

@export var pointing: Vector2 = Vector2(1, 0)
@export var move_speed: Vector2 = Vector2(60, 40)
@export var interact_distance: float = 20


@onready var interaction_cast = %InteractionCast
@onready var animation: AnimatedSprite2D = %FboyAnimation


func _ready() -> void:
	pass


var _horizontal: float
var _vertical: float
func _physics_process(_delta: float) -> void:
	var sub_velocity = Vector2(_horizontal, _vertical).normalized()
	velocity = Vector2(sub_velocity.x*move_speed.x, sub_velocity.y*move_speed.y)

	if _horizontal != 0 or _vertical != 0:
		interaction_cast.target_position = Vector2(_horizontal, _vertical).normalized() * interact_distance

	if _horizontal != pointing.x or _vertical != pointing.y:
		# print("_horizontal = ", _horizontal)
		# print("fboy: pointing was ", pointing)
		# print("fboy: mismatch pointing vector")
		if _horizontal < 0:
			animation.play("walk_left")
		elif _horizontal > 0:
			animation.play("walk_right")
		else:
			# print("fboy: _horizontal 0")
			# print("fboy: pointing was ", pointing)
			if pointing.x < 0:
				animation.play("idle_left")
			elif pointing.x > 0:
				animation.play("idle_right")
		pointing = Vector2(_horizontal, _vertical)

	move_and_slide()

	# move on to deal with automatic collision interactions
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)


func _unhandled_input(_event: InputEvent) -> void:
	_horizontal = Input.get_axis("move_left", "move_right")
	_vertical = Input.get_axis("move_up", "move_down")
	# print("fboy: axis: ", Input.get_axis("move_up", "move_down")*1.65, " ", Input.get_axis("move_left", "move_right")*1.65)
	# print("fboy: real axis: ", _vertical, " ", _horizontal)

	if Input.is_action_just_pressed("interact"):
		# print("fboy: test interaction")
		interaction_cast.enabled = true
		interaction_cast.force_raycast_update()
		interaction_cast.enabled = false
		var collider = interaction_cast.get_collider()
		if collider == null:
			return
		# print("fboy: collider found")
		
		if "activate" in collider:
			# print("fboy: activate the thing")
			collider.activate()
