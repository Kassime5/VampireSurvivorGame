extends CharacterBody2D

var arrow = preload ("res://scenes/arrow.tscn")
var can_attack = true
var level_up_points = 0
var health_bar = null
var player_xp = 0
var required_xp = 100

# Stats taht can be upgraded
var max_health = 100
var health = max_health
var max_upgrade_health = 200

var speed = 400
var max_upgrade_speed = 600

var attack_speed = 2 # per second
var max_upgrade_AS = 10
var attack_cooldown = snapped(1.0 / attack_speed, 0.01)

var attack_number = 1
var max_upgrade_AN = 3

var attack_damage = 20
var max_upgrade_damage = 150

var projectile_speed = 1000
var max_upgrade_PS = 2000




func _ready():
	$ProgressBar.max_value = required_xp
	$ProgressBar.value = 0
	health_bar = get_node("HealthBar")
	health_bar.max_value = max_health
	health_bar.value = health

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if velocity[0] < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity[0] > 0:
		$AnimatedSprite2D.flip_h = false
	if velocity[0] != 0 or velocity[1] != 0:
		$AnimatedSprite2D.animation = "running"
	else:
		$AnimatedSprite2D.animation = "idle"
	
	if Input.is_action_pressed("shoot"):
		shoot()
	move_and_collide(velocity * delta)
		
func shoot():
	if !can_attack:
		return
	can_attack = false
	$Bow.prepare_shoot(attack_cooldown, attack_number, attack_damage)
	$ShootTimer.start(attack_cooldown)
	
func _on_shoot_timer_timeout():
	can_attack = true

func get_xp(xp):
	player_xp += xp
	$ProgressBar.value = player_xp
	if player_xp >= required_xp:
		level_up()

func get_damaged(damage):
	health -= damage
	health_bar.value = health
	if health <= 0:
		$"..".restart()
		return
	if health > max_health:
		health = max_health

func level_up():
	player_xp -= required_xp
	required_xp += 50
	$ProgressBar.max_value = required_xp
	$ProgressBar.value = player_xp
	level_up_points += 1

func _on_level_up_menu_damage_button():
	if level_up_points <= 0:
		return
	if max_upgrade_damage <= attack_damage:
		return
	attack_damage += 5
	level_up_points -= 1
	
func _on_level_up_menu_attack_speed_button():
	if level_up_points <= 0:
		return
	if max_upgrade_AS <= attack_speed:
		return
	attack_speed += 0.5
	attack_cooldown = snapped(1.0 / attack_speed, 0.01)
	level_up_points -= 1

func _on_level_up_menu_projectile_speed_button():
	if level_up_points <= 0:
		return
	if max_upgrade_PS <= projectile_speed:
		return
	$Bow._arrow_speed += 100
	projectile_speed = $Bow._arrow_speed
	level_up_points -= 1
	
func _on_level_up_menu_health_button():
	if level_up_points <= 0:
		return
	if max_upgrade_health <= max_health:
		return
	max_health += 20
	health += 20
	level_up_points -= 1

func _on_level_up_menu_attack_number_button():
	if level_up_points <= 0:
		return
	if max_upgrade_AN <= attack_number:
		return
	attack_number += 1
	level_up_points -= 1
	
func _on_level_up_menu_speed_button():
	if level_up_points <= 0:
		return
	if max_upgrade_speed <= speed:
		return
	speed += 50
	level_up_points -= 1

func _on_heal_timer_timeout():
	get_damaged(-1)
	$HealTimer.start(2)
