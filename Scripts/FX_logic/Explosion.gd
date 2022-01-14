extends Node2D


onready var anim = $AnimationPlayer

export (int) var damage: int = 30


func _ready():
	anim.play("Explosion")
	GlobalSignals.emit_signal("camera_shake", 1500, 0.05, 1500)


func _on_Area2D_body_entered(body: Node):
	if body.has_method("handle_hit"):
		body.handle_hit(damage)
