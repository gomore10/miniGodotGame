extends KinematicBody2D

export var walk_speed = 150
export var ground_accel = 20
export var air_accel = 2
export var jump_force = 2

export var gravity = 10

export var path_to_my_node: NodePath
onready var Asteroid = get_node(path_to_my_node)

var velocity = Vector2.ZERO
var onground = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var input_vec = Vector2.ZERO
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec.y = 0
	input_vec=input_vec.normalized()
	
	var move_velocity = Vector2.ZERO
	if onground:
		if input_vec != Vector2.ZERO:
			move_velocity = (Asteroid.position - position).normalized().rotated(-PI/2)*input_vec.x*ground_accel
			velocity+=move_velocity
		else:
			var angl=(velocity.angle_to(Asteroid.position - position))
			if angl < 0:
				move_velocity = (Asteroid.position - position).normalized().rotated(-PI/2)*ground_accel
			else:
				move_velocity = (Asteroid.position - position).normalized().rotated(PI/2)*ground_accel
			velocity+=move_velocity
			if velocity.length()<25.0:
				velocity = Vector2.ZERO
		velocity=velocity.clamped(walk_speed)
	
	#gravity to asteroid
	var gravity_vector = (Asteroid.position - position).normalized() * gravity
	
	if onground:
		pass
	else:
		velocity = velocity + gravity_vector
	
	velocity = move_and_slide(velocity)
	if get_slide_count()>0:
		onground=true
	else:
		onground=false
	look_at(Asteroid.position)
	rotation-=PI/2
