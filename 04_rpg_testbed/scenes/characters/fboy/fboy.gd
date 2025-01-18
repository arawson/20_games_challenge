extends CharacterBody2D

@export var pointing: Vector2i = Vector2i(1, 0)
@export var move_speed: Vector2 = Vector2(60, 40)
@export var interact_distance: float = 20


@onready var interaction_cast = %InteractionCast
@onready var animation: AnimatedSprite2D = %FboyAnimation


func _ready() -> void:
	pass


var _horizontal: int
var _vertical: int
func _physics_process(delta: float) -> void:
	velocity = Vector2(_horizontal*move_speed.x, _vertical*move_speed.y)

	if _horizontal != 0 or _vertical != 0:
		interaction_cast.target_position = Vector2(_horizontal, _vertical).normalized() * interact_distance

	if _horizontal != pointing.x or _vertical != pointing.y:
		print("_horizontal = ", _horizontal)
		print("fboy: pointing was ", pointing)
		print("fboy: mismatch pointing vector")
		match _horizontal:
			-1:
				animation.play("walk_left")
			1:
				animation.play("walk_right")
			0:
				print("fboy: _horizontal 0")
				print("fboy: pointing was ", pointing)
				match pointing.x:
					-1:
						animation.play("idle_left")
					1:
						animation.play("idle_right")
		pointing = Vector2i(_horizontal, _vertical)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	_horizontal = int(Input.get_axis("move_left", "move_right"))
	_vertical = int(Input.get_axis("move_up", "move_down"))

	if Input.is_action_just_pressed("interact"):
		print("fboy: test interaction")
		interaction_cast.enabled = true
		interaction_cast.force_raycast_update()
		interaction_cast.enabled = false
		var collider = interaction_cast.get_collider()
		if collider == null:
			return
		print("fboy: collider found")
		
		if "activate" in collider:
			print("fboy: activate the thing")
			collider.activate()
			DialogueManager.show_example_dialogue_balloon(load("res://dialog/opengltestroom.dialogue"), "start")
