extends Node2D


onready var water_splash = preload("res://Prefabs/FX/Water_splash.tscn")


func _on_Area2D_body_entered(body: Node):
	var splash = water_splash.instance()
	splash.position.x = body.global_position.x
	splash.position.y = -33

	add_child(splash)


func _on_Area2D_body_exited(body: Node):
	var splash = water_splash.instance()
	splash.position.x = body.global_position.x
	splash.position.y = -33

	add_child(splash)


func _on_Area2D_area_entered(area: Area2D):
	var splash = water_splash.instance()
	splash.position.x = area.global_position.x
	splash.position.y = -33

	add_child(splash)
