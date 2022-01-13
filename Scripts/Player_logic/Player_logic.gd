extends KinematicBody2D

onready var sprite = $AnimatedSprite
onready var flame = $Flame
onready var reticle = $Reticle

onready var i_frame = $I_frame_timer

onready var gun = $Gun
onready var gun2 = $Gun2

onready var main = get_parent()

export (int) var hp: int = 100
export (int) var max_hp: int = 100

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
		if Input.is_action_pressed("Boost"):
			flame.playing = true
			flame.show()

			position -= transform.y * (wind_speed + boost)
		elif Input.is_action_pressed("Fire"):
			gun.attack()
			gun2.attack()
			flame.hide()

			position -= transform.y * (wind_speed / 2)
		else:
			flame.hide()

			position -= transform.y * wind_speed

		# General
		rotation += rotation_direction * rotation_speed

		velocity.y += gravity * delta
		if velocity.y > weight:
			velocity.y = weight

		velocity = move_and_slide(velocity, UP)

		if global_position.y >= 446 or global_position.y <= -446:
			queue_free()

		set_rot()
		reticle.rotation += 0.005

		# Screenwrapping
		global_position.x = wrapf(position.x, -380, 380)


# Damage control
func handle_hit(damage: int):
	if i_frame.is_stopped():
		hp -= damage
		i_frame.start()

		if hp <= 0:
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


