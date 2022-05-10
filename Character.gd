extends KinematicBody2D

export var walk_speed = 10
export var ground_accel = 5
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
	input_vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vec=input_vec.normalized()
	
	var move_velocity = Vector2.ZERO
	if input_vec != Vector2.ZERO:
		move_velocity = (Asteroid.position - position).normalized().rotated(-PI/2)*input_vec.x*ground_accel
		move_velocity=move_velocity.clamped(walk_speed)
	
	#gravity to asteroid
	var gravity_vector = (Asteroid.position - position).normalized() * gravity
	
	velocity = velocity + gravity_vector + move_velocity
	
	velocity = move_and_slide(velocity)
