extends Node2D


onready var camera = $Camera2D
onready var player = $Player


func _ready():
	randomize()

	initialize_nodes()


func initialize_nodes():
	pass

