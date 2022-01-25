extends CanvasLayer

var scoreholder = null
var player = null

onready var hp = $HUD/HP_bar
onready var fuel = $HUD/Fuel_bar
onready var score = $HUD/Score_label
onready var highscore = $HUD/High_score_label

onready var tween = $HUD/Health_tween
onready var score_tween = $HUD/Score_tween
onready var high_score_tween = $HUD/High_score_tween
onready var vignette = $HUD/Vignette

var hp_value
var score_value
var high_score_value
var vignette_mat


func _ready():
	vignette_mat = vignette.get_material()
	vignette_mat.set_shader_param("vignette_opacity", 0)

	GlobalSignals.connect("game_over", self, "dissapear")


func _process(delta):
	if is_instance_valid(player):
		hp_value = player.hp
		if hp.value != hp_value:
			tween.interpolate_property(hp, "modulate:r", 100, 1, 0.01, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
			tween.start()
			hp.value = hp_value

			if player.hp <= 30:
				vignette_mat.set_shader_param("vignette_opacity", 0.7)
			else:
				vignette_mat.set_shader_param("vignette_opacity", 0)

		fuel.value = player.fuel

		hp.max_value = player.max_hp
		fuel.max_value = player.max_fuel

	if is_instance_valid(scoreholder):
		var current_score = scoreholder.current_score
		if score_value != current_score:
			score_tween.interpolate_property(score, "rect_scale", Vector2(3, 3), Vector2(1, 1), 0.2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
			score_tween.start()

			score_value = current_score
			score.text = "Score: " + str(current_score)

		var current_high_score = scoreholder.high_score
		if high_score_value != current_high_score:
			high_score_tween.interpolate_property(highscore, "rect_scale", Vector2(3, 3), Vector2(1, 1), 0.2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
			high_score_tween.start()

			high_score_value = current_high_score
			highscore.text = "Highscore: " + str(current_high_score)


func initialize(player_object, scoreholder_object):
	self.player = player_object
	self.scoreholder = scoreholder_object


func dissapear():
	queue_free()


