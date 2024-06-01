extends Enemy

class_name EnemyBig

func _ready():
	speed = 200
	max_speed = 300
	max_health = 400
	health = max_health
	super._ready()
