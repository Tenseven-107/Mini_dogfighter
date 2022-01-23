extends CanvasLayer


var player = null

onready var hp = $HUD/HP_bar
onready var fuel = $HUD/Fuel_bar

onready var tween = $HUD/Health_tween
onready var vignette = $HUD/Vignette

var hp_value
var vignette_mat


func _ready():
	vignette_mat = vignette.get_material()
	vignette_mat.set_shader_param("vignette_opacity", 0)

	GlobalSignals.connect("game_over", self, "dissapear")


func _process(delta):
	if is_instance_valid(player):
		hp_value = player.hp
		if hp.value != hp_value:
			tween.interpolate_property(hp, "value", hp.value, hp_value, 0.01, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
			tween.start()

			if player.hp <= 30:
				vignette_mat.set_shader_param("vignette_opacity", 0.7)
			else:
				vignette_mat.set_shader_param("vignette_opacity", 0)

		fuel.value = player.fuel

		hp.max_value = player.max_hp
		fuel.max_value = player.max_fuel


func initialize(player_object):
	self.player = player_object


func dissapear():
	queue_free()


