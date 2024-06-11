extends PowerUp

class_name Flash

func _ready():
	# Make player invincible
	power_name = "Flash"
	power_description = "They're too slow!"
	stat_increase = 200
	duration = 10
	super._ready()
