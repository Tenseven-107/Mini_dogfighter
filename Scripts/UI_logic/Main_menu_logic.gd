extends CanvasLayer


onready var appear = $Appear
onready var disappear = $Disappear
onready var transition = $Transition

onready var main_control = $Main_Control
onready var start = $Main_Control/CenterContainer/VBoxContainer/Start
onready var customization = $Main_Control/CenterContainer/VBoxContainer/Customization
onready var options = $Main_Control/CenterContainer/VBoxContainer/Options
onready var credits = $Main_Control/CenterContainer/VBoxContainer/Credits
onready var quit = $Main_Control/CenterContainer/VBoxContainer/Quit


func _ready():
	appear.interpolate_property(main_control, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.7, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	appear.start()


# Start
func _on_Start_pressed():
	disappear.interpolate_property(main_control, "rect_scale", main_control.rect_scale, Vector2(0, 0), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	disappear.start()

	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)
	GlobalSignals.emit_signal("game_start")

func _on_Disappear_tween_all_completed():
	queue_free()
