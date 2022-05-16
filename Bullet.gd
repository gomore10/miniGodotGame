extends KinematicBody2D
onready var Sprite = $Sprite

var speed = 200
var velocity = Vector2.ZERO
var asteroid_position = 1
var gun_distance = 1
var his_facing = "right"

func b_init(asteroid_p, asteroid_r, facing):
	asteroid_position = asteroid_p
	gun_distance = asteroid_r
	his_facing = facing
	if his_facing == "left":
		$Sprite.flip_h = true
	else:
		pass

func _ready():
	pass


func _physics_process(delta):
	var rightvec=(asteroid_position - position).rotated(-PI/2).normalized()
	var leftvec=(asteroid_position - position).rotated(PI/2).normalized()
	var newvelocity = rightvec
	if his_facing == "right":
		newvelocity = rightvec
	else:
		newvelocity = leftvec
	velocity = newvelocity * speed
	velocity = move_and_slide(velocity)
	
	
	
	
	look_at(asteroid_position)
	rotation-=PI/2
	
	var amount_over = (asteroid_position - position).length()-gun_distance
	
	position = asteroid_position + -(asteroid_position - position).normalized()*gun_distance
	



func _on_Area2D_area_entered(area):
	if area.is_in_group("enemy_hitbox"):
		area.get_parent().die()
		queue_free()
	elif area.is_in_group("character_hurtbox"):
		area.get_parent().damage()
		queue_free()
