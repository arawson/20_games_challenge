class_name Faction
extends Node


signal turn_completed(faction: String)


@export var faction_base: FactionBase
@export var map_controller: MapController
@export var unit_container: Node


@onready var faction: String = faction_base.name


func _ready() -> void:
	assert(faction_base != null)
	assert(map_controller != null)
	assert(unit_container != null)

	for c in unit_container.get_children():
		# unit_container is already a list of our units so just validate them
		var unit = c as Unit
		assert(unit != null)
		unit.faction = self
		map_controller.collect_unit_blocks(unit)
		for block in unit.blocks:
			block.faction = self
			block.unit = unit
			block.unit_base = unit.base


func _process(_delta: float) -> void:
	pass


func turn_ready():
	print("dummy faction starts and ends turn immediately")
	turn_completed.emit(faction)


func turn_top(_turn_number: int):
	pass
