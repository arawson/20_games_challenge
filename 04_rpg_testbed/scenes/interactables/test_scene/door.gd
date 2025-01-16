extends StaticBody2D


@export var hide_this: Node2D
@export var initially_open: bool = false


func _ready() -> void:
	if initially_open:
		open()
	else:
		close()


func open():
	print("door: open")
	self.process_mode = Node.PROCESS_MODE_DISABLED
	if hide_this != null:
		hide_this.visible = false


func close():
	print("door: close")
	self.process_mode = Node.PROCESS_MODE_INHERIT
	if hide_this != null:
		hide_this.visible = true
