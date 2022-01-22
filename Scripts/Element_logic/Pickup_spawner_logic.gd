extends Node2D


onready var timer = $Spawn_timer

export (PackedScene) var pickup: PackedScene

func _ready():
	timer.start()


func _on_Spawn_timer_timeout():
	timer.wait_time = rand_range(0.5, 7)

	var pickup_inst = pickup.instance()
	pickup_inst.global_position = Vector2(rand_range(-336, 336), rand_range(-176, 176))
	add_child(pickup_inst)
