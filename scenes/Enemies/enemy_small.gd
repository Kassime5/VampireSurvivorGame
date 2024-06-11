extends Enemy

class_name EnemySmall

func _ready():
	speed = 300
	max_speed = 400
	max_health = 100
	xp_given = 100
	health = max_health
	super._ready()
