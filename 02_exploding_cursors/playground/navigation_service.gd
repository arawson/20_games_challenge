# Confine the chaos of wide-reaching navigation requirements to one place.
class_name NavigationService
extends Node


@export var layer_navigation: TileMapLayer
@export var blocks: Node


var block_store: Dictionary = {}


func _ready():
	assert(layer_navigation != null)
	assert(blocks != null)
	MainBus.input_inject_selection.connect(_on_input_inject_selection)

	for c in blocks.get_children():
		var b = c as UnitBlock
		assert(b != null)
		
		var coords = layer_navigation.local_to_map(layer_navigation.to_local(b.global_position))
		assert(!block_store.has(coords))
		block_store[coords] = b


#region Unit Motion

func can_move_unit(unit: Unit, dir: Util.Direction, cursor_pos: Vector2) -> bool:
	var coords = layer_navigation.local_to_map(
		layer_navigation.to_local(cursor_pos + Util.displacement(dir))
	)

	# check if head would land on open terrain
	var tiledata = layer_navigation.get_cell_tile_data(coords)
	if (not tiledata or not tiledata.get_custom_data("open")):
		return false
	
	# check if head would collide with another unit
	var existing_block = block_store.get(coords)
	if existing_block and existing_block.unit != unit:
		return false

	# unit move is valid!
	return true

#endregion


#region Initialization Helpers

func collect_unit_blocks(unit: Unit):
	for n in blocks.get_children():
		var block = n as UnitBlock
		assert(block != null)

		# we're gonna use the name of the faction+unit (just the unit)
		# to figure out the blocks which belong to it on startup
		if (block.name.begins_with(unit.name)):
			unit.blocks.append(block)
			block.coords = layer_navigation.align_node(block)

#endregion


#region Block Data Management


func attach_block(block: UnitBlock, coords: Vector2i):
	assert(!block_store.has(coords))
	# for some reason this emits an error about not being found
	# assert(blocks.get_node(NodePath(block.name)) == null)
	block_store[coords] = block
	block.coords = coords
	block.global_position = layer_navigation.map_to_global(coords)
	blocks.add_child(block)


func detach_block(block: UnitBlock):
	assert(blocks.get_node(NodePath(block.name)))
	assert(block_store.has(block.coords))
	blocks.remove_child(block)
	block_store.erase(block.coords)


func block_at(coords: Vector2i, pos: Vector2 = Vector2.ZERO) -> UnitBlock:
	var map_coords = layer_navigation.global_to_map(pos) + coords
	return block_store.get(map_coords)


#endregion


#region MainBuss event handling


func _on_input_inject_selection(global_pos: Vector2) -> void:
	var coords = layer_navigation.local_to_map(layer_navigation.to_local(global_pos))
	var block = block_store.get(coords)
	if block:
		MainBus.input_unit_selected.emit(block.unit, block)
	else:
		MainBus.input_nothing_selected.emit(
			coords, layer_navigation.to_global(layer_navigation.map_to_local(coords)))


#endregion


#region Input Handling


func _unhandled_input(event: InputEvent) -> void:
	if (
	event.is_action_pressed("pointer_action")
	&& event is InputEventMouseButton):
		# lookup the mouse location when the ui doesn't take it
		# var mouse = event as InputEventMouseButton
		var coords = layer_navigation.local_to_map(layer_navigation.get_local_mouse_position())
		var block = block_store.get(coords)
		if block:
			MainBus.input_unit_selected.emit(block.unit, block)
		else:
			MainBus.input_nothing_selected.emit(
				coords, layer_navigation.map_to_global(coords)
			)


#endregion
