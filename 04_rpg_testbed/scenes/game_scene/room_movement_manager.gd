@tool
## Manages movement between rooms and picking the initial room on load.
extends Node

# TODO refer to level_list_manager.gd while working on this

# TODO connect room_load_started, room_loaded in game ui scene
# TODO decide what should be the equivalent of levels_finished

signal room_load_started
signal room_loaded


@export_group("Plumbing")
@export_dir var directory: String :
	set(value):
		directory = value
		_refresh_files()
@export var files : Dictionary
@export var room_container: Node


@export_group("Settings IDK")
@export var auto_load : bool = true
@export_file("*.tscn") var force_room: String


var current_room: Node
var current_room_name: String:
	set(value):
		current_room_name = value


func _ready() -> void:
	if Engine.is_editor_hint():
		files.clear()
		_refresh_files()
	else:
		RoomBus.room_change.connect(_on_room_change)

		if auto_load:
			load_current_room()


## Handles all moving between rooms
func _on_room_change(destination_scene: String, direction: String, parameter: String) -> void:
	print("RMM: Room Change: destination: ", destination_scene, " direction: ",
	direction, " parameter: ", parameter)


func get_current_level_name() -> String:
	return current_room_name if force_room == "" else force_room


func load_current_room():
	load_room(get_current_level_name())


func load_room(room_name: String):
	if is_instance_valid(current_room):
		current_room.queue_free()
		await current_room.tree_exited
		current_room = null
	var room_file = get_room_file(room_name)
	if room_file == null:
		# TODO error handling around bad rooms!
		return
	SceneLoader.load_scene(room_file, true)
	room_load_started.emit()
	await SceneLoader.scene_loaded
	current_room = _attach_room(SceneLoader.get_resource())
	room_loaded.emit()


func _attach_room(room_resource: Resource):
	assert(room_container != null, "room container is null")
	var instance = room_resource.instantiate()
	room_container.call_deferred("add_child", instance)
	return instance


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
