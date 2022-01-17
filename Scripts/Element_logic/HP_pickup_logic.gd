extends Area2D


onready var anims = $AnimationPlayer
onready var tween = $Appear_tween
onready var tween2 = $Dissapear_tween
onready var timer = $Timer

export (int) var added_hp: int = 10


func _ready():
	anims.play("Spin")
	tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(1, 1), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween.start()

	timer.start()


func _on_HP_pickup_body_entered(body: Node):
	if body.is_in_group("Player"):
		body.handle_heal(added_hp)
		anims.play("Pickup")


func _on_Timer_timeout():
	tween2.interpolate_property(self, "scale", scale, Vector2(0, 0), 0.8, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	tween2.start()

func _on_Dissapear_tween_tween_all_completed():
	queue_free()
