# @tool TODO turn this on when I'm ready
## Manages movement between rooms and picking the initial room on load.
extends Node


signal room_load_started
signal level_loaded


@export_dir var directory: String :
	set(value):
		directory = value
		_refresh_files()
@export var room_container: Node


var current_room: Node
var files : Dictionary


func _ready() -> void:
	if Engine.is_editor_hint():
		_refresh_files()
		files.clear()
	else:
		RoomBus.room_change.connect(_on_room_change)


## Handles all moving
func _on_room_change(destination_scene: String, direction: String, parameter: String) -> void:
	pass


func _refresh_files():
	if not is_inside_tree() or directory.is_empty(): return
	var dir_access = DirAccess.open(directory)
	if dir_access:
		files.clear()
		for file in dir_access.get_files():
			if not file.ends_with(".tscn"): continue
			files[file] = directory + "/" + file


func get_room_file(room_name: String):
	if files.is_empty():
		push_error("rooms set is empty")
		return
	if not room_name in files.keys():
		push_error("room_name is not in the room set " + room_name)
		return
	return files[room_name]
