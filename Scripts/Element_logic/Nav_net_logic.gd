extends Node2D


onready var point_count: int = get_child_count()
onready var points: Array = get_children()


func get_random_point():
	var random_point: int = rand_range(0, point_count)

	return points[random_point]
