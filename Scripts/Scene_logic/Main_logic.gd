extends Node2D


onready var pause_menu = preload("res://Prefabs/UI/Pause_menu.tscn")

export (PackedScene) var player_object: PackedScene = preload("res://Prefabs/Player/Player.tscn")
export (PackedScene) var hud_object: PackedScene = preload("res://Prefabs/UI/HUD.tscn")

export (PackedScene) var game_over_object: PackedScene = preload("res://Prefabs/UI/Game_over_menu.tscn")
export (PackedScene) var main_menu_object: PackedScene = preload("res://Prefabs/UI/Main_menu.tscn")

onready var camera = $Camera2D
onready var player = null
onready var player_container = $Player_container
onready var player_hud = null

onready var point_net = $Nav_points
onready var enemy_container = $Enemy_container
onready var enemy_spawner = $Enemy_spawner

onready var scoreholder = $Scoreholder
onready var musicplayer = $Musicplayer


func _ready():
	SaveState.load_game()
	goto_main_menu()
	randomize()

	GlobalSignals.connect("game_start", self, "start_game")
	GlobalSignals.connect("game_over", self, "stop_game")
	GlobalSignals.connect("main_menu", self, "goto_main_menu")


# Instance main menu
func goto_main_menu():
	var main_menu_inst = main_menu_object.instance()
	main_menu_inst.initialize(scoreholder)
	add_child(main_menu_inst)


# Starting the game
func start_game():
	Engine.time_scale = 1
	musicplayer.start()

	# Adding game elements
	var player_inst = player_object.instance()
	player_inst.global_position = Vector2(0, 150)
	player = player_inst

	var hud_inst = hud_object.instance()
	player_hud = hud_inst

	player_container.add_child(player_inst)
	player_inst.i_frame.start()

	add_child(hud_inst)

	initialize_nodes()

	# Deleting projectiles
	var projectiles = get_tree().get_nodes_in_group("Projectiles")
	if projectiles:
		for projectile in projectiles:
			projectile.activate_tween()


# Game over
func stop_game():
	Engine.time_scale = 1
	musicplayer.stop()

	var game_over_inst = game_over_object.instance()
	game_over_inst.initialize(scoreholder)
	add_child(game_over_inst)


# Initializing the scene
func initialize_nodes():
	enemy_container.initialize(point_net)
	enemy_spawner.initialize(enemy_container)

	player_hud.initialize(player, scoreholder)
	musicplayer.initialize(player)


# Pausing
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Pause"):
		var pause = pause_menu.instance()
		add_child(pause)
