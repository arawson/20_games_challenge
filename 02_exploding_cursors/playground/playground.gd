extends Node2D


func _ready() -> void:
	# once we are ready, we tell the TurnManager, since global objects
	# are initialized before the tree
	TurnManager.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
