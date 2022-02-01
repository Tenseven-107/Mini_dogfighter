extends KinematicBody2D


export (PackedScene) var bullet: PackedScene
export (PackedScene) var explosion: PackedScene = preload("res://Prefabs/FX/Explosion.tscn")

onready var hitstop = $Hitstop
onready var appear_tween = $Tween
onready var anims = $AnimationPlayer
onready var field = $Mine_indicator

onready var rotater = $Rotater
onready var fire_timer = $Timer

var main = null

export (int) var hp: int = 20
export (int) var max_hp: int = 20
export (int, 0, 1) var team: int = 1
export (bool) var activated: bool = false

# Firing variables
export (float) var rotate_speed: float = 100
export (float) var firing_time: float = 0.1
export (int) var spawn_count: int = 8
export (float) var radius: float = 5


# Setting up the firing radius
func _ready():
	appear_tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(1, 1), 0.4, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	appear_tween.start()

	var step = 2 * PI / spawn_count

	for i in range(spawn_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)

	fire_timer.wait_time = firing_time


# Rotation
func _physics_process(delta):
	field.rotation_degrees += 1


# Damage handling
func handle_hit(damage: int, projectile_team: int):
	if projectile_team != self.team and !activated:
		hp -= damage
		anims.play("Hit")

		hitstop.interpolate_property(Engine, "time_scale", 0, 1, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		hitstop.start()
		GlobalSignals.emit_signal("camera_shake", 200, 0.05, 200)

		if hp <= 0:
			activated = true
			fire_timer.start()

func _on_Timer_timeout():
		if is_instance_valid(main):
			for s in rotater.get_children():
				var bullet_inst = bullet.instance()

				bullet_inst.position = s.global_position
				bullet_inst.rotation = s.global_rotation
				bullet_inst.team = self.team

				main.call_deferred("add_child", bullet_inst)

			die()

func die():
	if is_instance_valid(main):
		var explosion_inst = explosion.instance()
		explosion_inst.global_position = self.global_position
		main.call_deferred("add_child", explosion_inst)

	queue_free()


# Player detection
func _on_Detection_zone_body_entered(body: Node):
	if body.is_in_group("Player"):
		activated = true
		fire_timer.start()


# Initialization
func initialize(main_object, null_value):
	self.main = main_object











