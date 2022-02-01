extends Area2D


export (PackedScene) var explosion: PackedScene = preload("res://Prefabs/FX/Explosion.tscn")

export (float) var bomb_weight: float = 500
export (float) var bomb_gravity: float = 300
var velocity = Vector2()

var main = null

func _physics_process(delta):
	position.y += bomb_gravity * delta
	if position.y > bomb_weight:
		position.y = bomb_weight

func _on_Bomber_bomb_body_entered(body: Node):
	if body.is_in_group("Player") and is_instance_valid(main):
		var explosion_inst = explosion.instance()
		explosion_inst.global_position = self.global_position
		main.call_deferred("add_child", explosion_inst)

		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func initialize(main_object, null_value):
	self.main = main_object

