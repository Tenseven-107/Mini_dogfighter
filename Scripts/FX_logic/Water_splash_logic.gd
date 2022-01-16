extends Node2D


onready var anims = $AnimationPlayer

func _ready():
	anims.play("Splash")
