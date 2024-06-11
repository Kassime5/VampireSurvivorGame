extends RigidBody2D

var velocity = Vector2()

var damage = 5
@onready var raycast = $RayCast2D

func _ready():
	add_to_group("Arrow")
	rotation = velocity.angle()

func _process(_delta):
	if raycast.is_colliding():
		queue_free()

func _physics_process(delta):
	move_and_collide(velocity * delta)

func _on_body_entered(body):
	if body is TileMap:
		print("Tilemap")
	#print("Arrow: " + body.name)
	if body.is_in_group("Arrow"):
		return
	if !body.is_in_group("Player"):
		queue_free()
