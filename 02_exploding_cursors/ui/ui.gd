extends Control


func _on_end_turn_pressed() -> void:
	print("ui turn end")
	MainBus.ui_turn_completed.emit()
