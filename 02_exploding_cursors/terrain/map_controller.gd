class_name MapController
extends TileMap


@export var blocks: Node


var block_store: Dictionary = {}


func _ready() -> void:
	MainBus.input_inject_selection.connect(_on_input_inject_selection)


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
		MainBus.input_unit_selected.emit(block.unit)
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
	pass
