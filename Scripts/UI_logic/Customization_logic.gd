extends Control


onready var back = $VBoxContainer/Back
onready var skin_left = $VBoxContainer/CenterContainer2/HBoxContainer/Skin_left
onready var skin_right = $VBoxContainer/CenterContainer2/HBoxContainer/Skin_right
onready var theme_left = $VBoxContainer/CenterContainer/HBoxContainer/Theme_left
onready var theme_right = $VBoxContainer/CenterContainer/HBoxContainer/Theme_right

onready var appear = $Appear
onready var disappear = $Disappear
onready var skin_change = $Skin_change

onready var sprite = $VBoxContainer/CenterContainer2/HBoxContainer/Plane_example

onready var hover = $Hover
onready var press = $Press

var score = null

export (int) var current_skin: int = 0
var skin_value: int
export (int, 0, 5) var max_skin: int = 0
export (int, 0, 5) var max_unlocked_skins: int = 0

export (int) var current_theme: int = 0
export (int) var max_theme: int = 6


func _ready():
	set_unlocks()
	current_skin = GlobalSignals.player_skin
	current_theme = GlobalSignals.theme_skin

	appear.interpolate_property(self, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.7, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	appear.start()

	back.grab_focus()
	play_button_sounds()

func play_button_sounds():
	back.connect("mouse_entered", hover, "play")
	skin_left.connect("mouse_entered", hover, "play")
	skin_right.connect("mouse_entered", hover, "play")
	theme_left.connect("mouse_entered", hover, "play")
	theme_right.connect("mouse_entered", hover, "play")

	back.connect("pressed", press, "play")
	skin_left.connect("pressed", press, "play")
	skin_right.connect("pressed", press, "play")
	theme_left.connect("pressed", press, "play")
	theme_right.connect("pressed", press, "play")


# Skins
func _on_Skin_right_pressed():
	if !current_skin <= 0:
		current_skin -= 1
		GlobalSignals.player_skin = current_skin
		GlobalSignals.emit_signal("camera_shake", 1000, 0.05, 1000)


func _on_Skin_left_pressed():
	if !current_skin >= max_skin:
		current_skin += 1
		GlobalSignals.player_skin = current_skin
		GlobalSignals.emit_signal("camera_shake", 1000, 0.05, 1000)

func _process(delta):
	if skin_value != current_skin:
		skin_change.interpolate_property(sprite, "scale", Vector2(0, 0), Vector2(1, 1), 0.4, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		skin_change.start()
		skin_value = current_skin

	var skin = str(current_skin)
	sprite.set_animation(skin)


# Themes
func _on_Theme_right_pressed():
	if !current_theme <= 0:
		current_theme -= 1
		GlobalSignals.theme_skin = current_theme
		GlobalSignals.emit_signal("camera_shake", 1000, 0.05, 1000)


func _on_Theme_left_pressed():
	if !current_theme >= max_theme:
		current_theme += 1
		GlobalSignals.theme_skin = current_theme
		GlobalSignals.emit_signal("camera_shake", 1000, 0.05, 1000)


# Back
func _on_Back_pressed():
	disappear.interpolate_property(self, "rect_scale", self.rect_scale, Vector2(0, 0), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	disappear.start()

	GlobalSignals.emit_signal("camera_shake", 1000, 0.05, 1000)


func _on_Disappear_tween_all_completed():
	queue_free()


# Setting the skin unlocks
func initialize(score_object):
	self.score = score_object

func set_unlocks():
	if is_instance_valid(score):
		if score.high_score >= 50:
			max_unlocked_skins = 1
		if score.high_score >= 100:
			max_unlocked_skins = 2
		if score.high_score >= 150:
			max_unlocked_skins = 3
		if score.high_score >= 300:
			max_unlocked_skins = 4
		if score.high_score >= 400:
			max_unlocked_skins = 5

		clamp(max_skin, 0, 5)
		clamp(max_unlocked_skins, 0, 5)
		max_skin = max_unlocked_skins








