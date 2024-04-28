class_name Faction
extends Node


@export var faction_base: FactionBase


func _ready() -> void:
	FactionManager.register.call_deferred(self)


func _process(_delta: float) -> void:
	pass
