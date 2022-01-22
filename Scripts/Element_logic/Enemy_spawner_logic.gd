extends Node2D

onready var spawn_locs = $Spawn_locations

onready var spawn_timer = $Spawn_timer
onready var difficulty_timer = $Difficulty_timer
onready var bomb_timer = $Bomb_timer

onready var spawn_count = spawn_locs.get_child_count()
onready var spawn_points: Array = spawn_locs.get_children()

var container = null
export (float) var minimum_wave: float = 0
export (float) var wave: float = 0
export (int) var max_wave: int = 9

export (Array, PackedScene) var enemies
export (PackedScene) var bomb: PackedScene


# Spawning the enemies
func _ready():
	spawn_timer.wait_time = 5
	bomb_timer.start()
	difficulty_timer.start() # Placeholder start

func _process(delta):
	if spawn_timer.is_stopped():
		spawn_timer.start()

		pick_spawn_point()

func pick_spawn_point():
	var random_point: int = rand_range(0, spawn_count)
	var picked_point = spawn_points[random_point]

	var random_enemy: int = clamp(int(round(wave)), int(round(minimum_wave)), max_wave)

	var plane = enemies[rand_range(0, random_enemy)]
	var plane_object = plane.instance()
	plane_object.global_position = picked_point.position
	container.add_child(plane_object)

func _on_Difficulty_timer_timeout():
	if spawn_timer.wait_time > 1:
		spawn_timer.wait_time -= 0.025
		wave += 0.1
		minimum_wave += 0.025


# Initialization
func initialize(container_object):
	self.container = container_object


# Spawning bombs
func _on_Bomb_timer_timeout():
	var bomb_inst = bomb.instance()
	bomb_inst.position.x = rand_range(-370, 370)
	bomb_inst.position.y = 225

	container.add_child(bomb_inst)

	bomb_timer.wait_time = rand_range(1, 7)
	bomb_timer.start()




