extends Node2D

export(NodePath) var leader_path
onready var leader: Node2D = get_node(leader_path)

export(float) var extent_radius = 300.0

onready var viewport: Vector2 = get_viewport_rect().size / 2.0

var input: Vector2

func _input(event):
	if not event is InputEventMouseMotion:
		return
	
	input = Vector2( \
		(event.position.x - viewport.x) / viewport.x, \
		(event.position.y - viewport.y) / viewport.y \
	) \
	* extent_radius

func _process(_delta):
	position = input + leader.global_position
