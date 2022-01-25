extends CanvasLayer


export (PackedScene) var options_object: PackedScene = preload("res://Prefabs/UI/Options.tscn")

onready var control = $Control
onready var retry = $Control/Retry

onready var score = $Control/Text_container/Score_label
onready var highscore = $Control/Text_container/High_score_label

var scoreholder = null

var options_menu = null
var menu_open: bool = false


func _ready():
	if is_instance_valid(scoreholder):
		score.text = "Score: " + str(scoreholder.current_score)
		highscore.text = "Highscore: " + str(scoreholder.high_score)

	control.show()
	menu_open = false
	retry.grab_focus()


func _on_Home_pressed():
	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)
	GlobalSignals.emit_signal("main_menu")
	queue_free()


func _on_Retry_pressed():
	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)
	GlobalSignals.emit_signal("game_start")
	queue_free()


func _on_Options_pressed():
	var options_inst = options_object.instance()
	options_menu = options_inst
	add_child(options_menu)

	menu_open = true
	control.hide()

	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)


 # Menu handling
func _process(delta):
	if !is_instance_valid(options_menu) and menu_open == true:
		menu_open = false

		control.show()

		retry.grab_focus()


# Initiailization
func initialize(score_object):
	self.scoreholder = score_object

