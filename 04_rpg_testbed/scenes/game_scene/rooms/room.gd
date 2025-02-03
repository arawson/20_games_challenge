extends Node2D


signal room_exited(destination: String, direction: String, parameter: String)


@export_file("*.tscn") var room_name: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
