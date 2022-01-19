extends Node2D


export var max_length = 2000
var beam_pos: Vector2

onready var beam  = $Beam
onready var end  = $End
onready var raycast = $RayCast2D

var collider

func _ready():
	beam_pos = Vector2(100, 0)


func _physics_process(_delta):
	var max_cast_to = beam_pos.normalized() * max_length
	raycast.cast_to = max_cast_to

	if raycast.is_colliding():
		end.global_position = raycast.get_collision_point()
	else:
		end.global_position = raycast.cast_to

	beam.rotation = raycast.cast_to.angle()
	beam.region_rect.end.x = end.position.length()

	collider = raycast.get_collider()


