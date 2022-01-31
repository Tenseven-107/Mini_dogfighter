extends Camera2D

var target = null

onready var timer = $Timer
onready var tween = $Tween

var amount: float = 0
var normal_offset = offset

var shaking: bool = false


func _ready():
	shaking = false
	set_as_toplevel(true)

	GlobalSignals.connect("camera_shake", self, "shake")


func _process(delta):
	if shaking:
		offset = Vector2(rand_range(-amount, amount), rand_range(amount, -amount)) * delta


func shake(new_shake, shake_time, shake_limit):
	var fps = Engine.get_frames_per_second()
	if fps <= 60:
		new_shake /= 2
		shake_limit /= 2

	shaking = true
	amount += new_shake
	if amount > shake_limit:
		amount = shake_limit

	timer.wait_time = shake_time
	tween.stop_all()
	timer.start()


func _on_Timer_timeout():
	amount = 0
	shaking = false

	tween.interpolate_property(self, "offset", offset, normal_offset, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
