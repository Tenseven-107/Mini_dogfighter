extends CanvasLayer



func _on_Home_pressed():
	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)
	GlobalSignals.emit_signal("main_menu")
	queue_free()


func _on_Retry_pressed():
	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)
	GlobalSignals.emit_signal("game_start")
	queue_free() # placeholder



