extends Node


signal room_change(destination_scene: String, direction: String, parameter: String)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Tell the bus that a room change should happen. The bus then filters and tweaks
# room changes to make sure that they are valid.
func request_room_change(destination: String, direction: String, parameter: String):
	room_change.emit(destination, direction, parameter)
