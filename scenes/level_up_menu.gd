extends Control


var is_open = false
var player

signal damage_button()
signal attack_speed_button()
signal projectile_speed_button()
signal attack_number_button()
signal health_button()

func _ready():
	player = get_parent()
	close()
	
func _process(delta):
	if is_open:
		$RichTextLabel.text = "Level Up points: " + str(player.level_up_points)
		$ColorRect/DamageButton.text = "Add Damage: " + str(player.attack_damage)
		$ColorRect/AttackSpeedButton.text = "Add Attack Speed: " + str(player.attack_speed)
		$ColorRect/ProjectileSpeedButton.text = "Add Projectile Speed: " + str(player.projectile_speed)
		$ColorRect/HealthButton.text = "Add Health: " + str(player.max_health)
		$ColorRect/AttackNumberButton.text = "Add Attack Number: " + str(player.attack_number)
	if Input.is_action_just_pressed("i"):
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
