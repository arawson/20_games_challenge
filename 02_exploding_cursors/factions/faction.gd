class_name Faction
extends Node


signal turn_completed(faction: String)


@export var navigation_service: NavigationService
@export var faction_base: FactionBase
@export var unit_container: Node


@onready var faction: String = faction_base.name


var _my_turn: bool = false
var turn_number: int = 0


func _ready() -> void:
	assert(faction_base != null)
	assert(navigation_service != null)
	assert(unit_container != null)

	for c in unit_container.get_children():
		# unit_container is already a list of our units so just validate them
		var unit = c as Unit
		assert(unit != null)
		unit.faction = self
		navigation_service.collect_unit_blocks(unit)
		for block in unit.blocks:
			block.faction = self
			block.unit = unit
			block.unit_base = unit.base
			block.is_head = block.is_head
		unit.health = unit.blocks.size()


func turn_ready():
	_my_turn = true
	_turn_ready()


func _turn_ready():
	pass


func turn_top(the_turn_number: int):
	self.turn_number = the_turn_number
	_turn_top(turn_number)


func _turn_top(_turn_number: int):
	pass


func _turn_end():
	_my_turn = false
	turn_completed.emit(faction)
