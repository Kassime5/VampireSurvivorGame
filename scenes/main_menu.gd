extends Node2D

var game = "res://scenes/game.tscn"
var save_path = "user://score.tres"
const ScoreData = preload("res://scenes/score_data.gd")

func _ready():
	if FileAccess.file_exists(save_path):
		var score_data = ResourceLoader.load(save_path)
		if score_data is ScoreData:
			$Panel/HighScore.text = score_data.player_name + "'s High Score: " + str(score_data.highscore) + " Kills: " + str(score_data.kills) + " Powerups: " + str(score_data.powerups)
	else:
		#print("file not found")
		var score_data = ScoreData.new("Test", 100, 10, 1)
		var result = ResourceSaver.save(score_data, save_path)
		print(result)
		$Panel/HighScore.text = "High Score: " + str(score_data.highscore) + " Kills: " + str(score_data.kills) + " Powerups: " + str(score_data.powerups)

func _on_play_button_pressed():
	get_tree().change_scene_to_file(game)

func _on_quit_button_pressed():
	get_tree().quit()
