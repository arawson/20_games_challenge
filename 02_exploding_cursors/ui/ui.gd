class_name UI
extends Control


signal turn_completed()


func _on_end_turn_pressed() -> void:
	print("ui turn end")
	turn_completed.emit()
