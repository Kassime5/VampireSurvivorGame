extends Node2D

var enemy = preload ("res://scenes/enemy.tscn")
var enemyBig = preload ("res://scenes/enemyBig.tscn")
var rng = RandomNumberGenerator.new()
var min_distance = 500.0
var total_time = 0
var enemy_spawn = 1
var time_wave = 4
var player = null

var enemy_spawned = 0
var max_enemy = 50

var enemy_level = 1

func _ready():
	$Timer.start(1)
	player = get_node("/root/Game/Player")
	
func _process(_delta):
	pass

func _on_timer_timeout():
	for i in range(enemy_spawn):
		spawn_enemy(enemy)
	total_time += 1
	if total_time >= 3:
		enemy_spawn += 1
		total_time = 0
		enemy_level += 1
		spawn_enemy(enemyBig)
	$Timer.start(time_wave)

func spawn_enemy(enemy_object):
	if max_enemy <= enemy_spawned:
		return
	enemy_spawned += 1
	var enemy_instance = enemy_object.instantiate()
	enemy_instance.set_enemy_level(enemy_level)
	var offset_x
	var offset_y
	var valid_position = false
	
	while not valid_position:
		offset_x = randf_range(0.0, 1500.0)
		offset_y = randf_range(0.0, 1500.0)
		
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

	enemy_instance.position.x = $Player.position.x + offset_x
	enemy_instance.position.y = $Player.position.y + offset_y

	add_child(enemy_instance)

func enemy_died():
	enemy_spawned -= 1

func restart():
	get_tree().reload_current_scene()
