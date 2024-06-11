extends AnimatedSprite2D

class_name PowerUp

var power_name = ""
var power_description = ""
var stat_increase = 0
var duration = 0

func _ready():
	animation = power_name
