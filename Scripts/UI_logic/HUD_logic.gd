extends CanvasLayer


var player = null

onready var hp = $HUD/HP_bar
onready var fuel = $HUD/Fuel_bar


func _process(delta):
	if is_instance_valid(player):
		hp.value = player.hp
		fuel.value = player.fuel

		hp.max_value = player.max_hp
		fuel.max_value = player.max_fuel


func initialize(player_object):
	self.player = player_object
