extends KinematicBody2D


export (PackedScene) var explosion: PackedScene = preload("res://Prefabs/FX/Explosion.tscn")

onready var sprite = $Sprite
onready var flame = $Flame
onready var reticle = $Reticle

onready var i_frame = $I_frame_timer

onready var gun = $Gun
onready var gun2 = $Gun2

onready var sound_1 = $AudioStreamPlayer2D
onready var anim = $Anim_player
onready var hitstop = $Hitstop
onready var low_hp = $Low_hp_particles

onready var main = get_parent()

export (int) var hp: int = 100
export (int) var max_hp: int = 100
export (int, 0, 1) var team: int = 0

export (float) var fuel: float = 100
export (float) var max_fuel: float = 100
export (bool) var immortal: bool = false
export (bool) var fuel_max: bool = true

export (float) var wind_speed: float = 7
export (float) var boost: float = 6
export (float) var rotation_speed: float = 10
export (float) var weight: float = 25
export (float) var gravity: float = 25
export (bool) var alive: bool = true

var velocity = Vector2()
const UP = Vector2(0, -1)
var rotation_direction = 0


func _ready():
	gun.initialize(main)
	gun2.initialize(main)

	gun.team = team
	gun2.team = team

	set_skin()
	sound_1.playing = true
	anim.play("Spawn")


func _physics_process(delta):
	if alive:
		rotation_direction = 0
		#look_at(get_global_mouse_position()) | Interesting controls

		# Rotation
		if Input.is_action_pressed("left"):
			rotation -= 0.15
		elif Input.is_action_pressed("right"):
			rotation += 0.15

		# Actions
		if Input.is_action_pressed("Boost") and !fuel <= 0 and fuel_max:
			flame.playing = true
			flame.show()
			sound_1.pitch_scale = 1.5

			immortal = true
			fuel -= 0.5
			position -= transform.y * (wind_speed + boost)
		elif Input.is_action_pressed("Fire"):
			gun.attack()
			gun2.attack()

			flame.hide()
			sound_1.pitch_scale = 1

			immortal = false
			position -= transform.y * (wind_speed / 2)
		else:
			flame.hide()
			sound_1.pitch_scale = 1

			immortal = false
			position -= transform.y * wind_speed

		# General
		rotation += rotation_direction * rotation_speed

		velocity.y += gravity * delta
		if velocity.y > weight:
			velocity.y = weight

		velocity = move_and_slide(velocity, UP)


		if global_position.y > 225 or global_position.y <= -225:
			if i_frame.is_stopped():
				anim.play("Stalling")
		if global_position.y >= 245 or global_position.y <= -245:
			die()

		set_rot()
		reticle.rotation += 0.005

		# Screenwrapping
		global_position.x = wrapf(position.x, -380, 380)

		# Fuel regeneration
		if not immortal and fuel < max_fuel:
			fuel += 0.2
			fuel_max = false
		elif fuel >= max_fuel:
			fuel_max = true

		# Low hp indicator
		if hp <= 30:
			low_hp.emitting = true
		else:
			low_hp.emitting = false


# Damage control
func handle_heal(added_hp: int):
	if !hp >= max_hp:
		hp += added_hp
		GlobalSignals.emit_signal("camera_shake", 150, 0.05, 150)

func handle_hit(damage: int, projectile_team: int):
	if i_frame.is_stopped() and projectile_team != self.team and not immortal:
		hp -= damage
		i_frame.start()

		hitstop.interpolate_property(Engine, "time_scale", 0, 1, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		hitstop.start()
		GlobalSignals.emit_signal("camera_shake", 2000, 0.05, 2000)
		anim.play("Hit")

		if hp <= 0:
			die()

func die():
	var explosion_inst = explosion.instance()
	explosion_inst.global_position = self.global_position
	main.call_deferred("add_child", explosion_inst)

	GlobalSignals.emit_signal("game_over")
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

func set_skin():
	var skin = str(GlobalSignals.player_skin)
	sprite.set_animation(skin)






