extends KinematicBody2D


export (PackedScene) var explosion: PackedScene = preload("res://Prefabs/FX/Explosion.tscn")

onready var sprite = $Sprite
onready var flame = $Flame

onready var gun = $Gun

onready var fly_timer = $Fly_timer

var main = null
var point_net = null

export (int) var hp: int = 20
export (int) var max_hp: int = 20
export (int, 0, 1) var team: int = 1

export (float) var wind_speed: float = 8
export (float) var rotation_speed: float = 10
export (bool) var alive: bool = true

var velocity = Vector2()
var rotation_direction = 0
var point


func _ready():
	gun.team = team


func _physics_process(delta):
	if alive and is_instance_valid(point_net):
		rotation_direction = 0

		# Rotation
		if fly_timer.is_stopped():
			point = point_net.get_random_point()
			fly_timer.start()

			gun.attack()

		if point.global_position.y < self.global_position.y:
			rotation += 0.15
		if point.global_position.y > self.global_position.y:
			rotation -= 0.15

		# General
		position -= transform.y * wind_speed
		rotation += rotation_direction * rotation_speed

		velocity = move_and_slide(velocity)

		set_rot()

		# Screenwrapping
		global_position.x = wrapf(position.x, -380, 380)


# Damage control
func handle_hit(damage: int, projectile_team: int):
	if projectile_team != self.team:
		hp -= damage

		if hp <= 0:
			die()

func die():
	var explosion_inst = explosion.instance()
	explosion_inst.global_position = self.global_position
	main.call_deferred("add_child", explosion_inst)

	queue_free()


# Setting the plane sprites
func set_rot():
	sprite.global_rotation = 0

	if rotation >= 0.0 and rotation <= 0.5 and rotation >= -0.5:
		sprite.frame = 0
	elif rotation >= 1.0 and rotation <= 1.5:
		sprite.frame = 1
	elif rotation >= 1.5 and rotation <= 2.0:
		sprite.frame = 2
	elif rotation >= 2.0 and rotation <= 3.0:
		sprite.frame = 3
	elif rotation >= 2.5 and rotation >= 3.0 or rotation <= -2.5:
		sprite.frame = 4
	elif rotation <= -1.5 and rotation <= 0.0:
		sprite.frame = 5
	elif rotation <= -1.0 and rotation >= -1.5:
		sprite.frame = 6
	elif rotation <= -0.5 and rotation <= 0.0:
		sprite.frame = 7


func initialize(main_object, point_net_object):
	self.main = main_object
	self.point_net = point_net_object

	gun.initialize(main)




