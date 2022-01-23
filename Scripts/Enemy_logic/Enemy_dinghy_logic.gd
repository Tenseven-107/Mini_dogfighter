extends KinematicBody2D


export (PackedScene) var explosion: PackedScene = preload("res://Prefabs/FX/Explosion.tscn")

onready var anims = $AnimationPlayer
onready var sprite = $AnimatedSprite

onready var laser = $Gun_laser
onready var gun = $Gun

onready var enter_timer = $Enter_timer

export (int) var hp: int = 30
export (int) var max_hp: int = 30
export (int, 0, 1) var team: int = 1

export (float) var speed: float = 2
export (float) var acceleration: float = 0.1
var velocity: Vector2 = Vector2(0, 0)

var main = null
var player = null

func _ready():
	global_position.y = 192
	gun.team = team

	enter_timer.wait_time = rand_range(1, 2)
	enter_timer.start()

	sprite.playing = true


# Movement
func _physics_process(delta):
	# Level entering
	if !enter_timer.is_stopped():
		if position.x < 0:
			velocity.x -= acceleration
		elif position.x > 0:
			velocity.x += acceleration

	# Player following
	if is_instance_valid(player):
		if player.position.x < self.position.x:
			velocity.x -= acceleration
		elif player.position.x > self.position.x:
			velocity.x += acceleration

	clamp(velocity.x, -speed, speed)
	move_and_slide(velocity)

	global_position.x = wrapf(position.x, -380, 380)


# Attacking
func _process(delta):
	var collider = laser.collider
	if collider:
		player = collider
		gun.attack()


# Damage handling
func handle_hit(damage: int, projectile_team: int):
	if projectile_team != self.team:
		hp -= damage
		anims.play("Hit")

		if hp <= 0:
			die()

func die():
	if is_instance_valid(main):
		var explosion_inst = explosion.instance()
		explosion_inst.global_position = self.global_position
		main.call_deferred("add_child", explosion_inst)

	queue_free()


# Initialization
func initialize(main_object, null_value):
	self.main = main_object
	gun.initialize(main_object)
