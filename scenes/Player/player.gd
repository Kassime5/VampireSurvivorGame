extends CharacterBody2D

var arrow = preload ("res://scenes/Player/arrow.tscn")
var can_attack = true
var level_up_points = 0
var health_bar = null
var player_xp = 0
var required_xp = 100
var score = null
var invu = false
var blink_state = false
var power_active = false
var power_name = ""
var power_effect = 0
var power_duration = 0

# Stats that can be upgraded
var max_health = 100
var health = max_health
var max_upgrade_health = 300
var cost_health = 5
var cost_health_step = 1

var speed = 400
var max_upgrade_speed = 700
var cost_speed = 1
var cost_speed_step = 2

var attack_speed = 2 # per second
var max_upgrade_AS = 30
var cost_AS = 1
var cost_AS_step = 3
var attack_cooldown = snapped(1.0 / attack_speed, 0.01)

var attack_number = 1
var max_upgrade_AN = 6
var cost_AN = 5
var cost_AN_step = 3

var attack_damage = 20
var max_upgrade_damage = 200
var cost_attack = 1
var cost_attack_step = 2

var projectile_speed = 1000
var max_upgrade_PS = 2000
var cost_PS = 2
var cost_PS_step = 2

func _ready():
	$ProgressBar.max_value = required_xp
	$ProgressBar.value = 0
	health_bar = get_node("HealthBar")
	health_bar.max_value = max_health
	health_bar.value = health
	score = get_node("Score")
	$PowerUpBar.visible = false

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
	if damage > 0:
		if invu:
			return
		invu = true
		$InvuTimer.start(1)
		$BlinkTimer.start(0.1)
		score.player_hit()
	health -= damage
	health_bar.value = health
	if health <= 0:
		$"..".death()
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
	if level_up_points < cost_attack:
		return
	if max_upgrade_damage <= attack_damage:
		return
	attack_damage += 5
	level_up_points -= cost_attack
	cost_attack += cost_attack_step
	
func _on_level_up_menu_attack_speed_button():
	if level_up_points < cost_AS:
		return
	if max_upgrade_AS <= attack_speed:
		return
	attack_speed += 0.5
	attack_cooldown = snapped(1.0 / attack_speed, 0.01)
	level_up_points -= cost_AS
	cost_AS += cost_AS_step

func _on_level_up_menu_projectile_speed_button():
	if level_up_points < cost_PS:
		return
	if max_upgrade_PS <= projectile_speed:
		return
	$Bow._arrow_speed += 100
	projectile_speed = $Bow._arrow_speed
	level_up_points -= cost_PS
	cost_PS += cost_PS_step
	
func _on_level_up_menu_health_button():
	if level_up_points < cost_health:
		return
	if max_upgrade_health <= max_health:
		return
	max_health += 20
	health += 20
	level_up_points -= cost_health
	cost_health += cost_health_step
	health_bar.max_value = max_health
	health_bar.value = health
	
func _on_level_up_menu_attack_number_button():
	if level_up_points < cost_AN:
		return
	if max_upgrade_AN <= attack_number:
		return
	attack_number += 1
	level_up_points -= cost_AN
	cost_AN += cost_AN_step
	
func _on_level_up_menu_speed_button():
	if level_up_points < cost_speed:
		return
	if max_upgrade_speed <= speed:
		return
	speed += 50
	level_up_points -= cost_speed
	cost_speed += cost_speed_step

func _on_heal_timer_timeout():
	get_damaged(-1)
	$HealTimer.start(2)

func _on_invu_timer_timeout():
	invu = false
	
func _on_blink_timer_timeout():
	blink_state = !blink_state
	$AnimatedSprite2D.visible = blink_state
	if invu:
		$BlinkTimer.start(0.1)
	else:
		$AnimatedSprite2D.visible = true

func _on_pick_up_area_area_entered(area):
	if area.is_in_group("PowerUp"):
		if !power_active:
			powerup(area.get_parent())
			area.get_parent().queue_free()

func powerup(power):
	power_active = true
	power_name = power.power_name
	power_duration = power.duration
	score.add_score(15)
	$InformationLabel.text = power_name + "\n" + power.power_description
	$InformationLabel/InformationTimer.start(3)
	$PowerUpBar.visible = true
	$PowerUpBar.max_value = power_duration * 10
	$PowerUpBar.value = power_duration * 10
	$PowerUpBar/Timer.start(0.01)
	power_effect = power.stat_increase
	match power_name:
		"Berserker":
			attack_damage += power_effect
			$AnimatedSprite2D.modulate = Color(1, 0.3, 0.3)
			$Bow/BowSprite.modulate = Color(1, 0.3, 0.3)
		"Chariot":
			invu = true
			$InvuTimer.start(power_duration)
			$BlinkTimer.start(0.05)
			$AnimatedSprite2D.modulate = Color(0.3, 1, 0.3)
			$Bow/BowSprite.modulate = Color(0.3, 1, 0.3)
		"Deadeye":
			attack_speed += power_effect
			attack_cooldown = snapped(1.0 / attack_speed, 0.01)
			$AnimatedSprite2D.modulate = Color(0.5, 0.5, 1)
			$Bow/BowSprite.modulate = Color(0.5, 0.5, 1)
		"Flash":
			speed += power_effect
			$AnimatedSprite2D.modulate = Color(0.3, 0.3, 1)
			$Bow/BowSprite.modulate = Color(0.3, 0.3, 1)
	$PowerTimer.start(power.duration)

func _on_power_timer_timeout():
	power_active = false
	match power_name:
		"Berserker":
			attack_damage -= power_effect
		"Deadeye":
			attack_speed -= power_effect
			attack_cooldown = snapped(1.0 / attack_speed, 0.01)
		"Flash":
			speed -= power_effect
	power_name = ""
	power_effect = 0
	power_duration = 0
	$AnimatedSprite2D.modulate = Color(1, 1, 1)
	$Bow/BowSprite.modulate = Color(1, 1, 1)
	$PowerUpBar.visible = false

func _on_information_timer_timeout():
	$InformationLabel.text = ""

func _on_timer_timeout():
	$PowerUpBar.value = $PowerUpBar.value - (power_duration/10)
	if power_name != "":
		$PowerUpBar/Timer.start(0.1)
