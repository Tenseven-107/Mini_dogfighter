extends Node2D

onready var firerate = $Timer
onready var muzzle = $Position2D

onready var anims = $AnimationPlayer
onready var sound = $RandomAudioStreamPlayer2D

export (PackedScene) var bullet: PackedScene

export (int) var new_shake: int = 100
export (float) var shake_time: float = 0.06
export (int) var shake_limit: int = 200
export (bool) var screenshake: bool = true

export (float) var fire_rate: float = 0.1
var team: int = 0

var main = null


func _ready():
	firerate.wait_time = fire_rate


func attack():
	if firerate.is_stopped() and is_instance_valid(main):
		firerate.start()

		var bullet_inst = bullet.instance()
		bullet_inst.global_transform = muzzle.global_transform
		bullet_inst.rotation += rand_range(0.0, 0.1)
		bullet_inst.team = self.team

		main.call_deferred("add_child", bullet_inst)

		sound.play()
		anims.play("Fire")
		if screenshake:
			GlobalSignals.emit_signal("camera_shake", new_shake, shake_time, shake_limit)


func initialize(main_object):
	self.main = main_object
