class_name RoomLevelLoader
extends SceneLister


signal level_load_started
signal level_loaded


# Container where the level instance will be added.
@export var level_container : Node


var current_level: Node


@export var files_by_name : Dictionary



func _ready():
	if Engine.is_editor_hint():
		_refresh_files()
		files_by_name.clear()
