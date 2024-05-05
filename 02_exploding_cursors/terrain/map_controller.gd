class_name MapController
extends TileMap


@export var blocks: Node


var block_store: Dictionary = {}


func move_unit(unit: Unit, dir: Util.Direction, cursor_pos: Vector2):
	# get unit head
	var head = unit.get_head()
	# check if head would land on open terrain
	# TODO grab the occupancy checking code out of rainshadow
	# check if head would collide with another unit



func _ready() -> void:
	assert(blocks != null)
	MainBus.input_inject_selection.connect(_on_input_inject_selection)

	for c in blocks.get_children():
		var b = c as UnitBlock
		assert(b != null)
		
		var coords = local_to_map(to_local(b.global_position))
		assert(!block_store.has(coords))
		block_store[coords] = b


func _process(_delta: float) -> void:
	pass


func place_block(block: UnitBlock, coords: Vector2i):
	assert(!block_store.has(coords))
	block_store[coords] = block
	block.coordinates = coords


func _on_input_inject_selection(global_pos: Vector2) -> void:
	var coords = local_to_map(to_local(global_pos))
	var block = block_store.get(coords)
	if block:
		MainBus.input_unit_selected.emit(block.unit, block)
	else:
		MainBus.input_nothing_selected.emit(
			coords, to_global(map_to_local(coords)))


func _unhandled_input(event: InputEvent) -> void:
	if (
	event.is_action_pressed("pointer_action")
	&& event is InputEventMouseButton):
		# lookup the mouse location when the ui doesn't take it
		# var mouse = event as InputEventMouseButton
		var coords = local_to_map(get_local_mouse_position())
		var block = block_store.get(coords)
		if block:
			MainBus.input_unit_selected.emit(block.unit, block)
		else:
			MainBus.input_nothing_selected.emit(
				coords, to_global(map_to_local(coords)))


func _align_node(n: Node2D) -> Vector2i:
	var coords = local_to_map(to_local(n.global_position))
	n.global_position = to_global(map_to_local(coords))
	return coords


func collect_unit_blocks(unit: Unit):
	for n in blocks.get_children():
		var block = n as UnitBlock
		assert(block != null)

		# we're gonna use the name of the faction+unit (just the unit)
		# to figure out the blocks which belong to it on startup
		if (block.name.begins_with(unit.name)):
			unit.blocks.append(block)
			block.coords = _align_node(block)
