extends StaticBody2D


func open():
	self.process_mode = Node.PROCESS_MODE_DISABLED


func close():
	self.process_mode = Node.PROCESS_MODE_INHERIT
