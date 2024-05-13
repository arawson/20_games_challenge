## A tracker for a Unit's blocks which lives under the map.
class_name UnitBlock
extends Node2D


@onready var border: Sprite2D = $Border
@onready var faction_background: Sprite2D = $FactionBackground
@onready var unit_icon: Sprite2D = $UnitIcon


var border_head = preload("res://placeholders/fantasy_borders/unit-head.png")
var border_body = preload("res://placeholders/fantasy_borders/unit-block.png")


# Maintain a back-reference to the unit which created us.
@export var unit: Unit

@export var turn_created: int


@export var is_head: bool = false:
	get:
		return is_head
	set(value):
		is_head = value
		if is_inside_tree():
			unit_icon.visible = value
			if value:
				border.texture = border_head
			else:
				border.texture = border_body


@export var unit_base: UnitBase:
	get:
		return unit_base
	set(value):
		unit_base = value
		if is_inside_tree():
			unit_icon.texture = value.icon


@export var faction: Faction:
	get:
		return faction
	set(value):
		assert(value != null)
		faction = value
		if is_inside_tree():
			faction_background.texture = faction.faction_base.background


@export var coords: Vector2i = Vector2i.ZERO


func _ready() -> void:
	assert(unit_icon != null)
	assert(border_head != null)
	assert(border_body != null)
	assert(faction_background != null)


func reinit() -> void:
	unit_icon.visible = is_head
	if is_head:
		border.texture = border_head
	else:
		border.texture = border_body
	unit_icon.texture = unit_base.icon
	faction_background.texture = faction.faction_base.background	
