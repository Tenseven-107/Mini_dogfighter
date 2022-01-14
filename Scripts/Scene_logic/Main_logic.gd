extends Node2D


onready var camera = $Camera2D
onready var player = $Player

onready var point_net = $Nav_points
onready var enemy_container = $Enemy_container


func _ready():
	randomize()

	initialize_nodes()


func initialize_nodes():
	enemy_container.initialize(point_net)

