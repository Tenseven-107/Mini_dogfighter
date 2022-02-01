extends Node


onready var music = $Music
onready var menu_music = $Menu_music
onready var lose_jingle = $Lose_jingle
onready var start_sound = $Start_sound
onready var tween = $Tween

var normal_music_volume: int = 2

var player = null


# Playing music 
func _ready():
	music.pitch_scale = 1
	menu_music.play()

func start():
	start_sound.play()
	menu_music.stop()

	music.play()
	tween.interpolate_property(music, "volume_db", -80, normal_music_volume, 0.5, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()

func stop():
	lose_jingle.play()
	music.stop()

	menu_music.play()
	tween.interpolate_property(menu_music, "volume_db", -80, normal_music_volume, 0.5, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()


# Setting the pitch
func _process(delta):
	if is_instance_valid(player):
		if player.hp <= 30:
			music.pitch_scale = 1.5
		else:
			music.pitch_scale = 1

func initialize(player_object):
	self.player = player_object