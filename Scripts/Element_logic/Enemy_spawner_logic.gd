extends Node2D

onready var spawn_locs = $Spawn_locations

onready var spawn_timer = $Spawn_timer
onready var difficulty_timer = $Difficulty_timer

onready var spawn_count = spawn_locs.get_child_count()
onready var spawn_points: Array = spawn_locs.get_children()

var container = null
export (float) var wave: float = 0
export (int) var max_wave: int = 4

export (Array, PackedScene) var enemies


func _ready():
	spawn_timer.wait_time = 5

	difficulty_timer.start() # Placeholder start

func _process(delta):
	if spawn_timer.is_stopped():
		spawn_timer.start()

		pick_spawn_point()

func pick_spawn_point():
	var random_point: int = rand_range(0, spawn_count)
	var picked_point = spawn_points[random_point]

	var random_enemy: int = clamp(int(round(wave)), 0, max_wave)

	var plane = enemies[rand_range(0, random_enemy)]
	var plane_object = plane.instance()
	plane_object.global_position = picked_point.position
	container.add_child(plane_object)

func _on_Difficulty_timer_timeout():
	if spawn_timer.wait_time > 1:
		spawn_timer.wait_time -= 0.05
		wave += 0.1


# Initialization
func initialize(container_object):
	self.container = container_object



