extends Node2D

var arrow = preload ("res://scenes/Player/arrow.tscn")
var _arrow_speed = 1000
var _attack_number = 0
var _arrow_spawners = []
var _attack_damage = 5
var player

func _ready():
	player = get_node("/root/Game/Player")
	for child in get_children():
		if child.name.contains("ArrowSpawner"):
			_arrow_spawners.append(child)

func _process(delta):
	look_at(get_global_mouse_position())
	
func prepare_shoot(attack_cooldown, attack_number, attack_damage):
	var animation_speed = 0.8 / attack_cooldown
	_attack_number = attack_number
	_attack_damage = attack_damage
	$BowSprite.play("shoot", animation_speed)

func _on_bow_sprite_frame_changed():
	if $BowSprite.animation != "shoot" or $BowSprite.frame != 6:
		return
	shoot()

func shoot():
	var offset_distance_step = 10
	for i in range(_attack_number):
		var offset_distance = (i - _attack_number / 2.0) * offset_distance_step
		shoot_arrow(_arrow_spawners[i], offset_distance)

func shoot_arrow(arrow_spawner, offset_distance):
	var arrow_instance = arrow.instantiate()
	var mouse_position = get_global_mouse_position()
	var direction_to_mouse = (mouse_position - arrow_spawner.global_position).normalized()
	var offset_direction = Vector2(direction_to_mouse.y, -direction_to_mouse.x) * offset_distance
	arrow_instance.position = arrow_spawner.global_position + offset_direction
	arrow_instance.velocity = direction_to_mouse * _arrow_speed
	arrow_instance.velocity += $"..".velocity/4
	arrow_instance.damage = _attack_damage
	get_tree().get_root().get_child(0).add_child(arrow_instance)
