extends Control


onready var back = $VBoxContainer/Back

onready var appear = $Appear
onready var disappear = $Disappear

var score = null

export (int) var current_skin: int = 0
export (int, 0, 6) var max_skin: int = 0
export (int, 0, 6) var max_unlocked_skins: int = 0

export (int) var current_theme: int = 0
export (int) var max_theme: int = 6


func _ready():
	set_unlocks()
	current_skin = GlobalSignals.player_skin
	current_theme = GlobalSignals.theme_skin

	appear.interpolate_property(self, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.7, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	appear.start()

	back.grab_focus()


# Skins
func _on_Skin_right_pressed():
	if !current_skin <= 0:
		current_skin -= 1
		GlobalSignals.player_skin = current_skin
		GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)


func _on_Skin_left_pressed():
	if !current_skin >= max_skin:
		current_skin += 1
		GlobalSignals.player_skin = current_skin
		GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)


# Themes
func _on_Theme_right_pressed():
	if !current_theme <= 0:
		current_theme -= 1
		GlobalSignals.theme_skin = current_theme
		GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)


func _on_Theme_left_pressed():
	if !current_theme >= max_theme:
		current_theme += 1
		GlobalSignals.theme_skin = current_theme
		GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)


# Back
func _on_Back_pressed():
	disappear.interpolate_property(self, "rect_scale", self.rect_scale, Vector2(0, 0), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	disappear.start()

	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)


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
		if score.high_score >= 200:
			max_unlocked_skins = 4
		if score.high_score >= 250:
			max_unlocked_skins = 5
		if score.high_score >= 300:
			max_unlocked_skins = 6

		clamp(max_unlocked_skins, 0, 6)
		max_skin = max_unlocked_skins








