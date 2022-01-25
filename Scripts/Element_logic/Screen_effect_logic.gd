extends WorldEnvironment



enum THEMES {
	DEFAULT,
	CANDY,
	GAMEBOY,
	INVERTED,
	RED,
	SEPIA,
	WASHED_OUT
}

var THEME_DATA = {
	THEMES.DEFAULT: [preload("res://Screen_effects/Default_effect.tres")],
	THEMES.CANDY: [preload("res://Screen_effects/Candy.tres")],
	THEMES.GAMEBOY: [preload("res://Screen_effects/Game_boy.tres")],
	THEMES.INVERTED: [preload("res://Screen_effects/Inverted.tres")],
	THEMES.RED: [preload("res://Screen_effects/Red.tres")],
	THEMES.SEPIA: [preload("res://Screen_effects/Sepia.tres")],
	THEMES.WASHED_OUT : [preload("res://Screen_effects/Washed_out.tres")]
}


var current_theme: int = THEMES.DEFAULT


func _process(delta):
	current_theme = GlobalSignals.theme_skin

	var themes: Array = THEME_DATA[current_theme]
	self.environment = themes[randi() % themes.size()]
