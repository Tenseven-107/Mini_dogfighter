extends Node2D


onready var pause_menu = preload("res://Prefabs/UI/Pause_menu.tscn")

onready var camera = $Camera2D
onready var player = $Player
onready var player_hud = $Player_hud

onready var point_net = $Nav_points
onready var enemy_container = $Enemy_container


func _ready():
	randomize()
	$Music_placeholder.play() # Placeholder

	initialize_nodes()


func initialize_nodes():
	enemy_container.initialize(point_net)
	player_hud.initialize(player)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Pause"):
		var pause = pause_menu.instance()
		add_child(pause)
