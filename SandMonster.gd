extends KinematicBody2D

var velocity = Vector2.ZERO
var onground = false

export var path_to_my_node: NodePath
onready var Asteroid = get_node(path_to_my_node)

export var gravity = 10


func _ready():
	pass
	

func _physics_process(delta):
	var gravity_vector = (Asteroid.position - position).normalized() * gravity
	velocity += gravity_vector
	move_and_slide(velocity)

	
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
