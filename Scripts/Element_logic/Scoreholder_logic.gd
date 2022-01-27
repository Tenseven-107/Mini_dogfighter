extends Node


var current_score: int = 0
var high_score: int = 0


func _ready():
	GlobalSignals.connect("game_start", self, "reset")
	GlobalSignals.connect("update_score", self, "add_score")


# Resetting the score
func reset():
	current_score = 0


# Setting the score
func add_score(added_score):
	current_score += added_score
	if current_score > high_score:
		high_score = current_score


# Saving the highscore
func get_save_stats():
	return {
		"stats" : {
			"high_score" : high_score
		}
	}

func load_save_stats(stats):
	high_score = stats.stats.high_score





