extends Node2D


@export var navigation_service: NavigationService
@export var faction: Faction


@onready var arrow_group: Node2D = %ArrowGroup
@onready var overlay: TileMapLayer = %CursorOverlay


const tile_action_highlight = Vector2i(0, 0)
const tile_action_source = 1


# Design Problem as of 2024-05-12: Shouldn't the map cursor have all of its
# motion code in here? I went looking for it and couldn't figure out how the
# heck the cursor moved around. Turns out it's in the UI controller. How are the
# arrow keys handled? By injecting a bus signal input_inject_selection which
# tells the map how to re-adjust the selection cursor. Isn't that a bit silly?


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MainBus.input_unit_selected.connect(_on_input_unit_selected)
	MainBus.input_nothing_selected.connect(_on_input_nothing_selected)


func _on_input_unit_selected(_unit: Unit, unit_block: UnitBlock):
	_clear_action()
	if unit_block.is_head:
		arrow_group.visible = true
	else:
		arrow_group.visible = false


func _on_input_nothing_selected(_coords: Vector2i, _global_pos: Vector2):
	_clear_action()
	arrow_group.visible = false


func _on_move_arrow_clicked(event: InputEvent, dir: Util.Direction):
	if (event is InputEventMouseButton
	and Input.is_action_just_pressed("pointer_action")):
		LogDuck.d("_on_move_arrow_clicked")
		MainBus.input_action_move.emit(dir, global_position)


func _on_rect_n_gui_input(event:InputEvent) -> void:
	_on_move_arrow_clicked(event, Util.Direction.NORTH)


func _on_rect_s_gui_input(event:InputEvent) -> void:
	_on_move_arrow_clicked(event, Util.Direction.SOUTH)


func _on_rect_w_gui_input(event:InputEvent) -> void:
	_on_move_arrow_clicked(event, Util.Direction.WEST)


func _on_rect_e_gui_input(event:InputEvent) -> void:
	_on_move_arrow_clicked(event, Util.Direction.EAST)


func _clear_action():
	overlay.visible = false
	overlay.clear()

	for c in overlay.get_children():
		c.queue_free()


func activate_action(unit: Unit, action: Action):
	_clear_action()
	overlay.visible = true
	arrow_group.visible = false

	var d2 = action.distance**2
	for x in range(-action.distance, action.distance + 1, 1):
		for y in range(-action.distance, action.distance+ 1, 1):
			var coords = Vector2i(x,y)
			LogDuck.d("Set overlay on ", coords)

			var block = navigation_service.block_at(coords, global_position)

			if coords.distance_squared_to(Vector2i.ZERO) <= d2 and not coords == Vector2i.ZERO:
				if action.target_empties and not block == null:
					continue

				if action.target_friendlies and (
					block == null
					or block.faction != faction
				):
					continue

				if action.target_enemies and (
					block == null
					or block.faction == faction
				):
					continue
				
				overlay.set_cell(coords, tile_action_source, tile_action_highlight)

				var click_rect = TextureRect.new()
				# click_rect.global_position = overlay.map_to_global(coords)
				click_rect.position = overlay.map_to_local(coords) - Util.HalfDisplacement
				click_rect.size.x = 48
				click_rect.size.y = 48
				click_rect.mouse_filter = Control.MOUSE_FILTER_STOP
				# click_rect.texture = Util.Godot
				click_rect.gui_input.connect(
					_on_action_target_input.bind(unit, action, coords, block)
				)
				overlay.add_child(click_rect)


func _on_action_target_input(event: InputEvent, unit: Unit, action: Action,
coords: Vector2i, block: UnitBlock) -> void:
	if (event is InputEventMouseButton
	and Input.is_action_just_pressed("pointer_action")):
		LogDuck.d("_on_action_target_input")
		MainBus.input_action_confirmed.emit(unit, action, coords, block)
