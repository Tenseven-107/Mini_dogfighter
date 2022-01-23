extends CanvasLayer


var player = null

onready var hp = $HUD/HP_bar
onready var fuel = $HUD/Fuel_bar

onready var tween = $HUD/Health_tween

var hp_value


func _ready():
	GlobalSignals.connect("game_over", self, "dissapear")


func _process(delta):
	if is_instance_valid(player):
		hp_value = player.hp
		if hp.value != hp_value:
			tween.interpolate_property(hp, "value", hp.value, hp_value, 0.01, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
			tween.start()

		fuel.value = player.fuel

		hp.max_value = player.max_hp
		fuel.max_value = player.max_fuel


func initialize(player_object):
	self.player = player_object


func dissapear():
	queue_free()


