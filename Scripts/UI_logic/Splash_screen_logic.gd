extends Node2D

var game: PackedScene = preload("res://Scenes/Main.tscn")
var explosion = preload("res://Prefabs/FX/Explosion.tscn")

onready var tween = $Tween
onready var tween2 = $Tween2
onready var timer = $Timer

onready var logo = $Logo
onready var title = $Title
onready var sound = $RandomAudioStreamPlayer


func _ready():
	add_child(explosion.instance())

	tween.interpolate_property(logo, "scale",  Vector2(0, 0), Vector2(1, 1), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(logo, "rotation_degrees",  180, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_tween_all_completed():
	tween2.interpolate_property(title, "scale",  Vector2(0, 0), Vector2(1, 1), 0.2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween2.start()


func _on_Tween2_tween_all_completed():
	sound.play()
	timer.start()


func _on_Timer_timeout():
	get_tree().change_scene_to(game)


