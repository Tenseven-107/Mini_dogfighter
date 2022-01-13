extends Node2D

onready var firerate = $Timer
onready var muzzle = $Position2D

export (PackedScene) var bullet: PackedScene

onready var main = null

func attack():
	if firerate.is_stopped() and is_instance_valid(main):
		firerate.start()

		var bullet_inst = bullet.instance()
		bullet_inst.global_transform = muzzle.global_transform
		bullet_inst.rotation += rand_range(0.0, 0.1)

		main.add_child(bullet_inst)


func initialize(main_object):
	self.main = main_object
