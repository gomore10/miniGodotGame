extends KinematicBody2D

export var walk_speed = 2
export var ground_accel = 2
export var air_accel = 2
export var jump_force = 2
export var path_to_my_node: NodePath
onready var my_node = get_node(path_to_my_node)

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
	
	if input_vec != Vector2.ZERO:
		pass
	
	#gravity to asteroid
	velocity += position
	
	velocity = move_and_slide(velocity)
#velocity = velocity.move_toward(input_vec*walk_speed,ground_accel*delta)
#			velocity = velocity.clamped(walk_speed)
