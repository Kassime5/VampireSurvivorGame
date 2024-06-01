extends CharacterBody2D

class_name Enemy

var attack_offset = 25
var is_chasing = false
var player = null
var tilemap
var position_last_frame = Vector2(0,0)
var current_frame = 0
var frame_update
var attacking = false

var speed = 250
var max_speed = 450
var damage = 10
var max_health = 100
var health = max_health



# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	frame_update = rng.randi_range(15,25)
	player = get_node("/root/Game/Player")
	
func set_enemy_level(level):
	speed = 250 + 25*level
	max_speed = 450 + 25*level
	damage = 10 + 5*level
	max_health = 100 + 10*level
	health = max_health
	$ProgressBar.max_value = max_health
	$ProgressBar.value = health
	
func _on_collision_damage_body_entered(body):
	if body.is_in_group("Arrow"):
		#print("Damaged")
		get_damaged(body.damage)
		body.queue_free()
		return
	if body.is_in_group("Player"):
		attacking = true
		attack()

func attack():
	if player.position.y <= position.y + attack_offset and player.position.y >= position.y - attack_offset:
		$AnimatedSprite2D.play("attack_horizontal")
		return
	if player.position.y < position.y:
		$AnimatedSprite2D.play("attack_up")
		return
	if player.position.y > position.y:
		$AnimatedSprite2D.play("attack_down")
		return

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "running" or $AnimatedSprite2D.animation == "idle":
		return
	if $AnimatedSprite2D.frame == 3:
		if $CollisionDamage.get_overlapping_bodies().has(player):
			player.get_damaged(10)
		return

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "running" or $AnimatedSprite2D.animation == "idle":
		return
	if !$CollisionDamage.get_overlapping_bodies().has(player):
		attacking = false
		$AnimatedSprite2D.play("running")
		return
	attack()

func _physics_process(delta):
	current_frame += 1
	if current_frame < frame_update:
		return
	var direction_to_player = (player.global_position - global_position).normalized()
	if attacking:
		velocity = direction_to_player * speed/2
		move_and_collide(velocity * delta)
		return
	if direction_to_player.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	velocity = direction_to_player * speed
	if position_last_frame != global_position:
		$AnimatedSprite2D.play("running")
	else:
		$AnimatedSprite2D.play("idle")
	position_last_frame = global_position
	move_and_collide(velocity * delta)

func get_damaged(damage):
	health -= damage
	if(health <= 0):
		die()
	$ProgressBar.value = health

func die():
	player.get_xp(50)
	$"..".enemy_died()
	queue_free()

func _on_speed_timer_timeout():
	if(speed >= max_speed):
		return
	speed += 20
	$SpeedTimer.start(3)
