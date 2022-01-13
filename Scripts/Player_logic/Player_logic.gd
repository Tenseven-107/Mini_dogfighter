extends KinematicBody2D


onready var sprite = $AnimatedSprite
onready var reticle = $Reticle

export (float) var wind_speed: float = 7
export (float) var boost: float = 4
export (float) var rotation_speed: float = 10
export (float) var weight: float = 25
export (float) var gravity: float = 25
export (bool) var alive: bool = true

var velocity = Vector2()
const UP = Vector2(0, -1)
var rotation_direction = 0

func _physics_process(delta):
	if alive:
		rotation_direction = 0

		if Input.is_action_pressed("left"):
			rotation -= 0.15
		elif Input.is_action_pressed("right"):
			rotation += 0.15

		if Input.is_action_pressed("Boost"):
			position -= transform.y * (wind_speed + boost)
		else:
			position -= transform.y * wind_speed

		rotation += rotation_direction * rotation_speed

		velocity.y += gravity * delta
		if velocity.y > weight:
			velocity.y = weight

		velocity = move_and_slide(velocity, UP)

		if global_position.y >= 446 or global_position.y <= -446:
			queue_free()

		# Screenwrapping
		global_position.x = wrapf(position.x, -380, 380)

		set_rot()

		reticle.rotation += 0.005


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


