extends KinematicBody2D


export (PackedScene) var explosion: PackedScene = preload("res://Prefabs/FX/Explosion.tscn")

onready var anims = $AnimationPlayer
onready var sprite = $AnimatedSprite

onready var laser = $Gun_laser
onready var gun = $Gun
onready var gun2 = $Gun2
onready var cannon = $Cannon

onready var enter_timer = $Enter_timer
onready var enter_tween = $Enter_tween

export (int) var hp: int = 100
export (int) var max_hp: int = 100
export (int, 0, 1) var team: int = 1

export (float) var speed: float = 0.5
export (float) var acceleration: float = 0.1
var velocity: Vector2 = Vector2(0, 0)

export (int) var score: int = 20

var main = null
var player = null

func _ready():
	global_position.y = 192

	gun.team = team
	gun2.team = team
	cannon.team = team

	enter_tween.interpolate_property(sprite, "scale", Vector2(0, 0), Vector2(1, 1), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	enter_tween.start()

	enter_timer.wait_time = rand_range(1, 2)
	enter_timer.start()

	sprite.playing = true


# Movement
func _physics_process(delta):
	# Level entering
	if !enter_timer.is_stopped():
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
		gun2.attack()


# Cannon detection zone
func _on_Detect_zone_body_entered(body: Node):
	if body.is_in_group("Player"):
		cannon.attack()


# Damage handling
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


# Initialization
func initialize(main_object, null_value):
	self.main = main_object

	gun.initialize(main_object)
	gun2.initialize(main_object)
	cannon.initialize(main_object)



