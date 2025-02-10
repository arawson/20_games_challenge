extends Area2D


@export_file("*.tscn") var destination: String
@export var direction: String
@export var parameter: String


func is_portal() -> bool:
	return true


func get_destination() -> String:
	return destination


func get_direction() -> String:
	return direction


func get_parameter() -> String:
	return parameter
