extends CanvasLayer


export (PackedScene) var customization_object: PackedScene = preload("res://Prefabs/UI/Customization.tscn")
export (PackedScene) var options_object: PackedScene = preload("res://Prefabs/UI/Options.tscn")
export (PackedScene) var credits_object: PackedScene = preload("res://Prefabs/UI/Credits.tscn")

onready var appear = $Appear
onready var disappear = $Disappear
onready var transition = $Transition

onready var main_control = $Main_Control
onready var start = $Main_Control/CenterContainer/VBoxContainer/Start
onready var customization = $Main_Control/CenterContainer/VBoxContainer/Customization
onready var options = $Main_Control/CenterContainer/VBoxContainer/Options
onready var credits = $Main_Control/CenterContainer/VBoxContainer/Credits
onready var quit = $Main_Control/CenterContainer/VBoxContainer/Quit

onready var highscore = $Main_Control/CenterContainer/VBoxContainer/High_score_label

var scoreholder = null

var options_menu = null
var credits_menu = null
var customization_menu = null

var menu_open: bool = false
var menu_open_2: bool = false
var menu_open_3: bool = false


func _ready():
	if is_instance_valid(scoreholder):
		highscore.text = "Highscore: " + str(scoreholder.high_score)

	menu_open = false

	appear.interpolate_property(main_control, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.7, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	appear.start()

	start.grab_focus()
	


# Start
func _on_Start_pressed():
	disappear.interpolate_property(main_control, "rect_scale", main_control.rect_scale, Vector2(0, 0), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	disappear.start()

	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)
	GlobalSignals.emit_signal("game_start")

func _on_Disappear_tween_all_completed():
	queue_free()


# Customization
func _on_Customization_pressed():
	var customization_inst = customization_object.instance()
	customization_menu = customization_inst
	add_child(customization_menu)

	menu_open_3 = true

	transition.interpolate_property(main_control, "rect_scale", main_control.rect_scale, Vector2(0, 0), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	transition.start()

	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)


# Options
func _on_Options_pressed():
	var options_inst = options_object.instance()
	options_menu = options_inst
	add_child(options_menu)

	menu_open = true

	transition.interpolate_property(main_control, "rect_scale", main_control.rect_scale, Vector2(0, 0), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	transition.start()

	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)


# Credits
func _on_Credits_pressed():
	var credits_inst = credits_object.instance()
	credits_menu = credits_inst
	add_child(credits_menu)

	menu_open_2 = true

	transition.interpolate_property(main_control, "rect_scale", main_control.rect_scale, Vector2(0, 0), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	transition.start()

	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)


# Quit
func _on_Quit_pressed():
	get_tree().quit()


 # Menu handling
func _process(delta):
	if !is_instance_valid(options_menu) and menu_open == true:
		menu_open = false

		transition.interpolate_property(main_control, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		transition.start()

		start.grab_focus()

	elif !is_instance_valid(credits_menu) and menu_open_2 == true:
		menu_open_2 = false

		transition.interpolate_property(main_control, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		transition.start()

		start.grab_focus()

	elif !is_instance_valid(customization_menu) and menu_open_3 == true:
		menu_open_3 = false

		transition.interpolate_property(main_control, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		transition.start()

		start.grab_focus()


# Initiailization
func initialize(score_object):
	self.scoreholder = score_object
















