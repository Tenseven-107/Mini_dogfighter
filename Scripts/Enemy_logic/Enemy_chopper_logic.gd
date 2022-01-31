extends KinematicBody2D


export (PackedScene) var explosion: PackedScene = preload("res://Prefabs/FX/Explosion.tscn")

onready var sprite = $Sprite
onready var anims = $Anims
onready var move_anims = $Movement_anims

onready var fly_timer = $Fly_timer

onready var gun = $Gun

var main = null
var player = null

export (int) var hp: int = 50
export (int) var max_hp: int = 50
export (int, 0, 1) var team: int = 1

export (float) var speed: float = 200
export (float) var acceleration: float = 10
export (float) var max_speed: float = 200
export (float) var min_speed: float = 175

export (bool) var alive: bool = true
export (int) var score: int = 5

var velocity = Vector2()
export (bool) var right: bool = true

func _ready():
	gun.team = team
	speed = rand_range(min_speed, max_speed)
	fly_timer.start()


func _physics_process(delta):
	if alive:

		if !fly_timer.is_stopped():
			if position.x < 0:
				velocity.x -= acceleration
			elif position.x > 0:
				velocity.x += acceleration

		if is_instance_valid(player):
			if player.position.x > position.x:
				velocity.x += acceleration
			if player.position.x < position.x:
				velocity.x -= acceleration
			if player.position.y > position.y:
				velocity.y += acceleration
			if player.position.y < position.y:
				velocity.y -= acceleration

			gun.look_at(player.global_position)

		# General
		velocity.x = clamp(velocity.x, -speed, speed)
		velocity.y = clamp(velocity.y, -speed, speed)

		velocity = move_and_slide(velocity)
		set_anims()

		# Screenwrapping
		global_position.x = wrapf(position.x, -380, 380)


# Damage control
func handle_hit(damage: int, projectile_team: int):
	if projectile_team != self.team:
		hp -= damage
		anims.play("Hit")

		if hp <= 0:
			die()

func die():
	GlobalSignals.emit_signal("update_score", score)
	if is_instance_valid(main):
		var explosion_inst = explosion.instance()
		explosion_inst.global_position = self.global_position
		main.call_deferred("add_child", explosion_inst)

	queue_free()


# Setting the chopper sprites
func set_anims():
	sprite.playing = true

	if velocity.x >= 1:
		sprite.rotation_degrees = 30

		if !right:
			move_anims.play("Turn_right")
	elif velocity.x <= -1:
		sprite.rotation_degrees = -30

		if right:
			move_anims.play("Turn_left")


# Initialization
func initialize(main_object, null_object):
	self.main = main_object

	gun.initialize(main)


# Player detection
func _on_Detection_zone_body_entered(body: Node):
	if body.is_in_group("Player"):
		player = body
		gun.attack()





