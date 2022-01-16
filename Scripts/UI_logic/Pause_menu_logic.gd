extends CanvasLayer


onready var time_label = $Pause/Label
onready var pause_button = $Pause/Button
onready var timer = $Timer
onready var sound = $AudioStreamPlayer

var time_left: int = 4


func _ready():
	get_tree().paused = true

	time_label.hide()
	pause_button.show()
	sound.pitch_scale = 1


# Unpausing
func _on_Button_pressed():
	pause_button.hide()
	time_label.show()
	timer.start()

func _on_Timer_timeout():
	get_tree().paused = false

	queue_free()

func _process(delta):
	var current_time = int(round(timer.time_left))
	time_label.text = str(current_time)

	# Playing the timer blip
	if !timer.is_stopped():
		if time_left != current_time:
			time_left = current_time
			sound.play()
		if time_left <= 0:
			sound.pitch_scale = 2
