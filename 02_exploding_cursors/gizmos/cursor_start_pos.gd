extends Sprite2D


func _ready() -> void:
	MainBus.input_inject_selection.emit.call_deferred(global_position)
	queue_free()
