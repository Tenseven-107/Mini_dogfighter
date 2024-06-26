extends Control


onready var back = $VBoxContainer/Back
onready var discord = $VBoxContainer/CenterContainer/LinkButton

onready var appear = $Appear
onready var disappear = $Disappear

onready var hover = $Hover
onready var press = $Press

func _ready():
	appear.interpolate_property(self, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.7, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	appear.start()

	back.grab_focus()

	play_button_sounds()

func play_button_sounds():
	back.connect("mouse_entered", hover, "play")
	discord.connect("mouse_entered", hover, "play")

	back.connect("pressed", press, "play")
	discord.connect("pressed", press, "play")


func _on_LinkButton_pressed():
	OS.shell_open("https://discord.gg/FdzxQZw6ph")


func _on_Back_pressed():
	disappear.interpolate_property(self, "rect_scale", self.rect_scale, Vector2(0, 0), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	disappear.start()

	GlobalSignals.emit_signal("camera_shake", 1000, 0.05, 1000)


func _on_Disappear_tween_all_completed():
	queue_free()



