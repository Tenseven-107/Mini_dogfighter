extends CanvasLayer





func _on_Retry_pressed():
	GlobalSignals.emit_signal("game_start")
	queue_free() # placeholder
