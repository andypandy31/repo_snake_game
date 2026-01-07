extends CanvasLayer

signal restart


func _on_game_over_button_pressed() -> void:
	restart.emit()
