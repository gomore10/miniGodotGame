extends KinematicBody2D
#
#var velocity = Vector2.ZERO
#
#export var path_to_my_node: NodePath
#onready var Asteroid = get_node(path_to_my_node)
#
#export var gravity = 10
#
#
#func _ready():
#	pass
#
#
#func _physics_process(delta):
#	var gravity_vector = (Asteroid.position - position).normalized() * gravity
#	velocity += gravity_vector
#	move_and_slide(velocity)
