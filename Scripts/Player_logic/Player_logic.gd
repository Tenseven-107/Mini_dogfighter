extends KinematicBody2D


onready var sprite = $AnimatedSprite

onready var screen = get_viewport_rect().size

export (float) var wind_speed: float = 10
export (float) var wind_speed_value: float = 11
export (float) var rotation_speed: float = 10
export (float) var weight: float = 100
export (float) var gravity: float = 100
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

		rotation += rotation_direction * rotation_speed

		velocity.y += gravity * delta
		if velocity.y > weight:
			velocity.y = weight

		velocity = move_and_slide(velocity, UP)
		
		position -= transform.y * wind_speed

		position.x = wrapf(position.x, -512, screen.x)
		position.y = wrapf(position.y, -512, screen.y)

		set_rot()


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


