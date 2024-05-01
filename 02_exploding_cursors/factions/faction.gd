class_name Faction
extends Node


signal turn_completed(faction: String)


@export var faction_base: FactionBase
@export var map_controller: MapController


@onready var faction: String = faction_base.name


func _ready() -> void:
	assert(faction_base != null)
	assert(map_controller != null)


func _process(_delta: float) -> void:
	pass


func turn_ready():
	print("dummy faction starts and ends turn immediately")
	turn_completed.emit(faction)


func turn_top(_turn_number: int):
	pass
