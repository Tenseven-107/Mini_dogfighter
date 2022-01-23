extends Node2D


onready var pause_menu = preload("res://Prefabs/UI/Pause_menu.tscn")

export (PackedScene) var player_object: PackedScene = preload("res://Prefabs/Player/Player.tscn")
export (PackedScene) var hud_object: PackedScene = preload("res://Prefabs/UI/HUD.tscn")
export (PackedScene) var game_over_object: PackedScene = preload("res://Prefabs/UI/Game_over_menu.tscn")

onready var camera = $Camera2D
onready var player = null
onready var player_container = $Player_container
onready var player_hud = null

onready var point_net = $Nav_points
onready var enemy_container = $Enemy_container
onready var enemy_spawner = $Enemy_spawner


func _ready():
	randomize()
	$Music_placeholder.play() # Placeholder

	GlobalSignals.connect("game_start", self, "start_game")
	GlobalSignals.connect("game_over", self, "stop_game")


# Starting the game
func start_game():
	var player_inst = player_object.instance()
	player_inst.global_position = Vector2(0, 150)
	player = player_inst

	var hud_inst = hud_object.instance()
	player_hud = hud_inst

	player_container.add_child(player_inst)
	player_inst.i_frame.start()

	add_child(hud_inst)

	initialize_nodes()


# Game over
func stop_game():
	var game_over_inst = game_over_object.instance()
	add_child(game_over_inst)


# Initializing the scene
func initialize_nodes():
	enemy_container.initialize(point_net)
	enemy_spawner.initialize(enemy_container)

	player_hud.initialize(player)


# Pausing
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Pause"):
		var pause = pause_menu.instance()
		add_child(pause)
