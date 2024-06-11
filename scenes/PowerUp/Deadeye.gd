extends PowerUp

class_name Deadeye

func _ready():
	# Make player invincible
	power_name = "Deadeye"
	power_description = "Unlimited arrows!"
	stat_increase = 10
	duration = 10
	super._ready()
