extends Label

var time_elapsed = 0.0
var minutes = 0
var seconds = 0

func _process(delta):
	time_elapsed += delta
	minutes = time_elapsed / 60
	seconds = fmod(time_elapsed, 60)
	var time_string := "%02d:%02d" % [minutes, seconds]
	text = time_string
