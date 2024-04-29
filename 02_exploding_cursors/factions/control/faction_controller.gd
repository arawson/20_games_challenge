class_name FactionController
extends Node


@export var faction: String


signal turn_completed(faction: String)


func turn_ready(start_faction: String):
	if start_faction == faction:
		turn_completed.emit(faction)


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass
