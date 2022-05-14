extends KinematicBody2D

var velocity = Vector2.ZERO
var gravity = 200
var direction = -1
var walk_speed = 0.1
var rng = RandomNumberGenerator.new()
var popup_amount = 200
var wait = 0
var inside = 0
var onground = false
#gets Asteroid node
export var path_to_my_node: NodePath
onready var Asteroid = get_node(path_to_my_node)

const change_direction = 2

const change_inside = 5

var time_direction = 0
var time_inside = 0



func _ready():
	rng.randomize()
	

func _physics_process(delta):
	
	time_direction += delta
	if time_direction > change_direction:
		direction = rng.randi_range(1, -1)
		time_direction = 0
		
	time_inside += delta
	if time_inside > change_inside:
		inside = rng.randi_range(1, 0)
		time_inside = 0
		
	if inside == 1:
		velocity+=(position - Asteroid.position).normalized()*popup_amount
		wait += delta
		if wait > 2:
			set_collision_mask_bit(0, true)
			wait = 0
	else:
		set_collision_mask_bit(0, false)


	print(wait)
	print(inside)
		

	
	
	
	#unit vector pointing right along the asteroid
	var rightvec=(Asteroid.position - position).rotated(-PI/2).normalized()
	#same but pointing left
	var leftvec=(Asteroid.position - position).rotated(PI/2).normalized()
	

	
	var move_velocity = Vector2.ZERO
	if direction == 1:
		$AnimatedSprite.flip_h=true
		move_velocity = rightvec * walk_speed
		velocity += move_velocity
	elif direction == -1:
		$AnimatedSprite.flip_h=false
		move_velocity = leftvec * walk_speed
		velocity += move_velocity
	
	
	
	#gravity to asteroid
	var gravity_vector = (Asteroid.position - position).normalized() * gravity
	
	velocity = velocity + gravity_vector
	
	velocity = move_and_slide(velocity)




	#rotates monster to asteroid
	look_at(Asteroid.position)
	rotation-=PI/2
