extends PowerUp

class_name Chariot

func _ready():
	# Make player invincible
	power_name = "Chariot"
	power_description = "Embrace invincibility!"
	#var damage_increase = 50
	duration = 10
	super._ready()
