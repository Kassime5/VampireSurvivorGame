extends Control


var is_open = false
var player

signal damage_button()
signal attack_speed_button()
signal projectile_speed_button()
signal attack_number_button()
signal health_button()
signal speed_button()

func _ready():
	player = get_parent()
	close()
	
func _process(delta):
	if is_open:
		$RichTextLabel.text = "Level Up points: " + str(player.level_up_points)
		$ColorRect/DamageButton.text = "Add Damage: " + str(player.attack_damage) + "\nCost: " + str(player.cost_attack)
		$ColorRect/AttackSpeedButton.text = "Add Attack Speed: " + str(player.attack_speed) + "\nCost: " + str(player.cost_AS)
		$ColorRect/ProjectileSpeedButton.text = "Add Projectile Speed: " + str(player.projectile_speed) + "\nCost: " + str(player.cost_PS)
		$ColorRect/HealthButton.text = "Add Health: " + str(player.max_health) + "\nCost: " + str(player.cost_health)
		$ColorRect/AttackNumberButton.text = "Add Attack Number: " + str(player.attack_number) + "\nCost: " + str(player.cost_AN)
		$ColorRect/SpeedButton.text = "Add Speed: " + str(player.speed) + "\nCost: " + str(player.cost_speed)
	if Input.is_action_just_pressed("levelUp"):
		if is_open:
			close()
		else:
			open()
	
func close():
	get_tree().paused = false
	visible = false
	is_open = false
	
func open():
	get_tree().paused = true
	visible = true
	is_open = true

func _on_damage_button_pressed():
	damage_button.emit()

func _on_attack_speed_button_pressed():
	attack_speed_button.emit()

func _on_projectile_speed_button_pressed():
	projectile_speed_button.emit()

func _on_cancel_pressed():
	close()

func _on_health_button_pressed():
	health_button.emit()

func _on_attack_number_button_pressed():
	attack_number_button.emit()

func _on_speed_button_pressed():
	speed_button.emit()
