extends Node2D

var save_path = "user://score.tres"
var enemy = preload ("res://scenes/Enemies/enemy.tscn")
var enemyBig = preload ("res://scenes/Enemies/enemyBig.tscn")
var enemySmall = preload ("res://scenes/Enemies/enemy_small.tscn")
const ScoreData = preload("res://scenes/score_data.gd")

var powerupbase = preload ("res://scenes/PowerUp/PowerUp.tscn")
var powerups = ["res://scenes/PowerUp/Berserker.gd","res://scenes/PowerUp/Chariot.gd", "res://scenes/PowerUp/Deadeye.gd", "res://scenes/PowerUp/Flash.gd"]

var rng = RandomNumberGenerator.new()
var min_distance = 600.0
var total_time = 0
var enemy_spawn = 1
var time_wave = 3
var player = null
var dead = false

var enemy_spawned = 0
var max_enemy = 30

var enemy_level = 1

var enemy_killed = 0

func _ready():
	$Timer.start(1)
	player = get_node("/root/Game/Player")
	
func _process(_delta):
	pass

func _on_timer_timeout():
	if(dead):
		return
	for i in range(enemy_spawn):
		spawn_enemy(enemy)
	total_time += 1
	if total_time >= 5:
		enemy_spawn += 1
		total_time = 0
		enemy_level += 1
		spawn_enemy(enemyBig)
		spawn_enemy(enemySmall)
		spawn_power_up()
	$Timer.start(time_wave)

func spawn_enemy(enemy_object):
	if max_enemy <= enemy_spawned:
		return
	enemy_spawned += 1
	var enemy_instance = enemy_object.instantiate()
	enemy_instance.set_enemy_level(enemy_level)
	spawn_object(enemy_instance)
	
func spawn_object(instance):
	var offset_x
	var offset_y
	var valid_position = false
	
	while not valid_position:
		offset_x = randf_range(0.0, 1800.0)
		offset_y = randf_range(0.0, 1800.0)
		
		if randi_range(0, 1) == 0:
			offset_x = -offset_x
		if randi_range(0, 1) == 0:
			offset_y = -offset_y
		var player_pos = $Player.global_position
		var spawn_position = Vector2i(player_pos.x + offset_x, player_pos.y + offset_y)
		var local_position = $TileMap.to_local(spawn_position)
		var cell_position = $TileMap.local_to_map(local_position)
		
		var tile_data = $TileMap.get_cell_tile_data(0, cell_position)
		if tile_data == null:
			continue
		if tile_data.get_collision_polygons_count(0) > 0:
			continue
			
		var distance = sqrt(offset_x * offset_x + offset_y * offset_y)
		if distance >= min_distance:
			valid_position = true

	instance.position.x = $Player.position.x + offset_x
	instance.position.y = $Player.position.y + offset_y

	add_child(instance)

func spawn_power_up():
	var power_script = powerups[randi_range(0, len(powerups)-1)]
	var power_instance = powerupbase.instantiate()
	power_instance.set_script(load(power_script))
	spawn_object(power_instance)

func enemy_died():
	enemy_spawned -= 1
	enemy_killed += 1
	$Player/Score.add_score(10)

func restart():
	get_tree().reload_current_scene()

func death():
	dead = true
	get_enemies()
	Engine.time_scale = 0.5
	$Player/InformationLabel.text = "YOU DIED"
	if FileAccess.file_exists(save_path):
		var score_data = ResourceLoader.load(save_path)
		if score_data is ScoreData:
			if score_data.highscore > $Player/Score.score:
				print("Current highscore is better!")
			else:
				$Player/InformationLabel.text = "New HighScore!!"
				var new_score = ScoreData.new("Player", $Player/Score.score, enemy_killed, 0)
				ResourceSaver.save(new_score, save_path)
		else:
			pass
	else:
		pass
	#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func get_enemies():
	for child in get_children():
		if child.is_in_group("Enemy"):
			child.queue_free()
