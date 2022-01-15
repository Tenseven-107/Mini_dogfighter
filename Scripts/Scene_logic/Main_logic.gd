extends Node2D


onready var camera = $Camera2D
onready var player = $Player
onready var player_hud = $Player_hud

onready var point_net = $Nav_points
onready var enemy_container = $Enemy_container


func _ready():
	randomize()

	initialize_nodes()


func initialize_nodes():
	enemy_container.initialize(point_net)
	player_hud.initialize(player)

