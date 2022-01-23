extends Area2D


onready var life_time = $Life_time
onready var tween = $Tween

export (int) var damage: int = 10
export (int) var speed = 1000
var team: int = 0


func _ready():
	life_time.start()


func _physics_process(delta):
	position += transform.x * speed * delta

	global_position.x = wrapf(position.x, -380, 380)


func _on_Life_time_timeout():
	activate_tween()

func activate_tween():
	tween.interpolate_property(self, "scale", Vector2(scale.x, scale.y), Vector2(0, 0), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_all_completed():
	queue_free()


func _on_Bullet_body_entered(body: Node):
	if body.has_method("handle_hit"):
		body.handle_hit(damage, team)
