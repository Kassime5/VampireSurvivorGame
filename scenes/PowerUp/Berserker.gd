extends PowerUp

class_name Berserker

func _ready():
	# Make player invincible
	power_name = "Berserker"
	power_description = "Your rage shall know no bounds!"
	stat_increase = 50
	duration = 10
	super._ready()
