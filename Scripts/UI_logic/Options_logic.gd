extends Control


onready var music = $VBoxContainer/Music
onready var sfx = $VBoxContainer/SFX

onready var fullscreen = $VBoxContainer/Fullscreen

onready var appear = $Appear
onready var disappear = $Disappear


func _ready():
	music.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	sfx.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX_Master"))

	appear.interpolate_property(self, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.7, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	appear.start()

	if OS.window_fullscreen:
		fullscreen.pressed = true


# Fullscreen
func _on_Fullscreen_toggled(button_pressed):
	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)
	if button_pressed:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false


# Audio
func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_SFX_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX_Master"), value)


# Back
func _on_Back_pressed():
	disappear.interpolate_property(self, "rect_scale", self.rect_scale, Vector2(0, 0), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	disappear.start()

	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)


func _on_Disappear_tween_all_completed():
	queue_free()
