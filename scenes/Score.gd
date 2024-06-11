extends Label

var score = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Score: " + str(score)

func add_score(points):
	score += points

func _on_score_timer_timeout():
	score += 1
	
func player_hit():
	score -= 20
	if score < 0:
		score = 0
