extends KinematicBody2D


export (PackedScene) var bullet: PackedScene
export (PackedScene) var explosion: PackedScene

onready var anims = $AnimationPlayer
onready var hitstop = $Hitstop_tween
onready var tween = $Rotate_tween
onready var sprite = $Sprite

onready var move_timer = $Move_timer
onready var life_timer = $Life_timer
onready var fire_timer = $Fire_timer

onready var rotater = $Firing_rotater

onready var sound_2 = $RandomAudioStreamPlayer2D2
onready var sound_3 = $RandomAudioStreamPlayer2D3

var main = null

export (int) var hp: int = 20
export (int) var max_hp: int = 20
export (int, 0, 1) var team: int = 1

export (float) var weight: float = 360
export (float) var gravity: float = 360
var velocity = Vector2()

var alive: bool = true

# Firing variables
export (float) var rotate_speed: float = 100
export (float) var firing_time: float = 0.1
export (int) var spawn_count: int = 4
export (float) var radius: float = 10


func initialize(main_object, null_value):
	self.main = main_object


# Positioning
func _ready():
	move_timer.wait_time = rand_range(1, 1.8)
	move_timer.start()

	sprite.rotation = rand_range(0, 360)

	# Setting up the firing radius
	var step = 2 * PI / spawn_count

	for i in range(spawn_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)

	fire_timer.wait_time = firing_time


func _physics_process(delta):
	if alive:
		if !move_timer.is_stopped():
			velocity.y -= (gravity / 2) * delta
		elif move_timer.is_stopped():
			velocity.y += gravity * delta
			if velocity.y > weight:
				velocity.y = weight

		move_and_slide(velocity)


# Damage handling 
func handle_hit(damage: int, projectile_team: int):
	if projectile_team != self.team and alive:
		hp -= damage
		anims.play("Hit")

		hitstop.interpolate_property(Engine, "time_scale", 0, 1, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		hitstop.start()
		GlobalSignals.emit_signal("camera_shake", 200, 0.05, 200)

		if hp <= 0:
			activate()

func activate():
	alive = false
	life_timer.start()
	sound_3.play()

	tween.interpolate_property(sprite, "rotation_degrees", sprite.rotation_degrees, 0, 0.1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()

	attack()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Life_timer_timeout():
	die()

func die():
	if is_instance_valid(main):
		var explosion_inst = explosion.instance()
		explosion_inst.global_position = self.global_position
		main.call_deferred("add_child", explosion_inst)

	queue_free()


# Emitting the bullets
func _process(delta):
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation = fmod(new_rotation, 360)

func attack():
	fire_timer.start()

func _on_Fire_timer_timeout():
	if is_instance_valid(main):
		for s in rotater.get_children():
			var bullet_inst = bullet.instance()

			bullet_inst.position = s.global_position
			bullet_inst.rotation = s.global_rotation
			bullet_inst.team = self.team

			main.add_child(bullet_inst)

			fire_timer.start()
			anims.play("Fire")
			sound_2.play()




