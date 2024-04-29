class_name Faction
extends Node


@export var faction_base: FactionBase
@export var controller: FactionController
@export var map_controller: MapController


func _ready() -> void:
	FactionManager.register.call_deferred(self)


func _process(_delta: float) -> void:
	pass
