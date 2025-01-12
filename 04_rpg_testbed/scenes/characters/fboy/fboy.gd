extends CharacterBody2D

@export var move_speed: Vector2 = Vector2(60, 40)


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var horizontal = Input.get_axis("move_left", "move_right")
	var vertical = Input.get_axis("move_up", "move_down")

	velocity = Vector2(horizontal*move_speed.x, vertical*move_speed.y)

	move_and_slide()
