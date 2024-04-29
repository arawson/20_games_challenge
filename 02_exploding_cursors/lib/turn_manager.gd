extends Node


@export var turn_order: Array[Faction] = []


var turn_index: int = 0


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func start():
	assert(turn_order.size() > 0)
	pass
