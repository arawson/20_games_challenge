class_name MapController
extends TileMap


@export var blocks: Node


var block_store: Dictionary = {}


func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass


func place_block(block: UnitBlock, coords: Vector2i):
	assert(!block_store.has(coords))
	block_store[coords] = block
	block.coordinates = coords
	pass
