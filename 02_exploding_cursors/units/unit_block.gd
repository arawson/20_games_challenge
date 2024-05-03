## A tracker for a Unit's blocks which lives under the map.
class_name UnitBlock
extends Node2D


@onready var border: Sprite2D = $Border
@onready var faction_background: Sprite2D = $FactionBackground
@onready var unit_icon: Sprite2D = $UnitIcon


var border_head = preload("res://placeholders/fantasy_borders/unit-head.png")
var border_body = preload("res://units/unit_block.tscn")


# Maintain a back-reference to the unit which created us.
@export var unit: Unit


@export var is_head: bool = false:
	get:
		return is_head
	set(value):
		if unit_icon:
			unit_icon.visible = value
		if border:
			if value:
				border.texture = border_head
			else:
				border.texture = border_body
		is_head = value


@export var unit_base: UnitBase:
	get:
		return unit_base
	set(value):
		if unit_icon:
			unit_icon.texture = value.icon
		unit_base = value


@export var faction: Faction:
	get:
		return faction
	set(value):
		faction_background.texture = faction.faction_base.background
		faction = value


@export var coords: Vector2i = Vector2i.ZERO


func _ready() -> void:
	assert(unit_icon != null)
	assert(border_head != null)
	assert(border_body != null)
	assert(faction_background != null)
