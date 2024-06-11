# score_data.gd
extends Resource

class_name ScoreData

@export var player_name = ""
@export var highscore = 0
@export var kills = 0
@export var powerups = 0

func _init(name="",highscore=0, kills=0, powerups=0):
	self.player_name = name
	self.highscore = highscore
	self.kills = kills
	self.powerups = powerups
