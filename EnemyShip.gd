extends KinematicBody2D

var move_speed = 320
var direction = 1
var drop_height = 100
var descend_speed = 80
var leave_speed = 80
var spawn_height = 300
enum stateTypes {entering,spawning,leaving}
var state=stateTypes.entering
export var asteroid_path: NodePath
onready var Asteroid = get_node(asteroid_path)
onready var Animate = $AnimationPlayer
onready var Sprite = $Sprite
var rng = RandomNumberGenerator.new()
var velocity = Vector2.ZERO

var alien = preload("res://Alien.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	Animate.play("Idle")
	var spawn_angle=rng.randf_range(0,2*PI)
	position = Vector2(1,0).rotated(spawn_angle)*spawn_height+Asteroid.position
	direction = rng.randi_range(0,1)
	if direction==0: direction=-1

func _physics_process(delta):
	#unit vector pointing right along the asteroid
	var rightvec=(Asteroid.position - position).rotated(-PI/2).normalized()
	#same but pointing left
	var leftvec=(Asteroid.position - position).rotated(PI/2).normalized()
	
	#spawn alien dude and fly away
	if state==stateTypes.spawning and Animate.is_playing()==false:
		state=stateTypes.leaving
		var new_alien = alien.instance()
		new_alien.Asteroid = Asteroid
		new_alien.position = position + (Asteroid.position - position).normalized()*5
		new_alien.direction = rng.randi_range(0,1)
		if new_alien.direction == 0: new_alien.direction=-1
		get_tree().current_scene.add_child(new_alien)
	
	if state==stateTypes.entering:
		velocity = rightvec*direction*move_speed
		velocity += (Asteroid.position - position).normalized()*descend_speed
	elif state==stateTypes.spawning:
		velocity=Vector2.ZERO
	elif state==stateTypes.leaving:
		velocity = rightvec*direction*move_speed
		velocity += -(Asteroid.position - position).normalized()*leave_speed
		
	#ease in/out
	velocity *= pow(((Asteroid.position - position).length()/150),2)
	#move right and left
	velocity = move_and_slide(velocity)
	
	var amount_over = (Asteroid.position - position).length()-drop_height
	if amount_over<=0 and state==stateTypes.entering:
		state=stateTypes.spawning
		Animate.play("Drop")
	
	look_at(Asteroid.position)
	rotation-=PI/2


func die():
	queue_free()
