extends CharacterBody2D

@export var pointing: Vector2i = Vector2i(1, 0)
@export var move_speed: Vector2 = Vector2(60, 40)
@export var interact_distance: float = 20


@onready var interaction_cast = %InteractionCast
@onready var animation: AnimatedSprite2D = %FboyAnimation


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var horizontal = int(Input.get_axis("move_left", "move_right"))
	var vertical = int(Input.get_axis("move_up", "move_down"))

	velocity = Vector2(horizontal*move_speed.x, vertical*move_speed.y)

	if horizontal != 0 or vertical != 0:
		interaction_cast.target_position = Vector2(horizontal, vertical).normalized() * interact_distance

	if horizontal != pointing.x or vertical != pointing.y:
		print("horizontal = ", horizontal)
		print("fboy: pointing was ", pointing)
		print("fboy: mismatch pointing vector")
		match horizontal:
			-1:
				animation.play("walk_left")
			1:
				animation.play("walk_right")
			0:
				print("fboy: horizontal 0")
				print("fboy: pointing was ", pointing)
				match pointing.x:
					-1:
						animation.play("idle_left")
					1:
						animation.play("idle_right")
		pointing = Vector2i(horizontal, vertical)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
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
