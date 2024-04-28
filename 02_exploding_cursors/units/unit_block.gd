class_name UnitBlock
extends Node2D


@onready var border: Sprite2D = $Border
@onready var faction_background: Sprite2D = $FactionBackground
@onready var unit_icon: Sprite2D = $UnitIcon


var border_head = preload("res://placeholders/fantasy_borders/unit-head.png")
var border_body = preload("res://units/unit_block.tscn")


@export var is_head: bool:
	get:
		return is_head
	set(value):
		unit_icon.visible = value
		if value:
			border.texture = border_head
		else:
			border.texture = border_body
		is_head = value


@export var unit_base: UnitBase:
	get:
		return unit_base
	set(value):
		unit_icon.texture = value.icon
		unit_base = value


@export var faction: Faction:
	get:
		return faction
	set(value):
		faction_background.texture = faction.faction_base.background
		faction = value


@export var grid_position: Vector2i = Vector2i.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
