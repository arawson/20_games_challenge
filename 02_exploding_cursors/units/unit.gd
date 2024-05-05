class_name Unit
extends Node


@export var base: UnitBase


var faction: Faction
var blocks: Array[UnitBlock] = []
var health: int = 1
var movement_left: int
var actions_left: int


func _ready() -> void:
	assert(base != null)


func turn_ready() -> void:
	movement_left = base.move_speed
	actions_left = 1


func get_head() -> UnitBlock:
	for b in blocks:
		if b.is_head == true:
			return b

	assert(false, "headless unit")
	return null
