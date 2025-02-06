## Manages movement between rooms and picking the initial room on load.
extends Node


func _ready() -> void:
	RoomBus.room_change.connect


## Handles all moving
func _on_room_change(destination_scene: String, direction: String, parameter: String) -> void:
	pass


