extends Area2D

var speed = 100

var asteroid_position = 1
var asteroid_radius = 1


func b_init(asteroid_p, asteroid_r):
	asteroid_position = asteroid_p
	asteroid_radius = asteroid_r

func _ready():
	pass


func _physics_process(delta):
	var amount_over = (asteroid_position - position).length()-asteroid_radius
	if amount_over>0:
		position = asteroid_position + -(asteroid_position - position).normalized()*asteroid_radius


func _on_Bullet_body_entered(body):
	if body.is_in_group("enemy"):
		print("bulletdead")
		queue_free()
