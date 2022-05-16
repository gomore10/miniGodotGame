extends KinematicBody2D

var velocity = Vector2.ZERO
var direction = -1 #-1 is left, +1 is right
var walk_speed = 35
var rise_speed = 20
var sink_speed = 25
var rng = RandomNumberGenerator.new()
enum stateTypes {rising, sinking, walking}
var state = stateTypes.walking
var walktime = 4
var undergroundtime = 1
var walk_range = 2
var underground_range = .5
#gets Asteroid node
export var path_to_my_node: NodePath
onready var Asteroid = get_node(path_to_my_node)
onready var asteroid_radius = Asteroid.get_child(0).get_child(0).get_child(0).get_shape().get_radius()
onready var timer = $Timer
onready var dirtanim = $dirtanim


func _ready():
	rng.randomize()
	state=stateTypes.walking
	timer.start(rng.randf_range(walktime-walk_range,walktime+walk_range))

func _physics_process(delta):
	#unit vector pointing right along the asteroid
	var rightvec=(Asteroid.position - position).rotated(-PI/2).normalized()
	#same but pointing left
	var leftvec=(Asteroid.position - position).rotated(PI/2).normalized()
	
	var move_velocity = rightvec * walk_speed * direction
	#sink into the ground after a time
	if state==stateTypes.walking and timer.time_left<=0:
		timer.start(10000)
		state=stateTypes.sinking
	elif state==stateTypes.sinking and timer.time_left<=0:
		state=stateTypes.rising
	#sink/rise
	if state==stateTypes.rising:
		velocity = (Asteroid.position - position).normalized() * -rise_speed
	elif state==stateTypes.sinking:
		velocity = (Asteroid.position - position).normalized() * sink_speed
	else:
		velocity = Vector2.ZERO
	
	velocity += move_velocity
	velocity = move_and_slide(velocity)
	
	#stay on the ground
	var amount_over = (Asteroid.position - position).length()-asteroid_radius
	if amount_over>0:
		position = Asteroid.position + -(Asteroid.position - position).normalized()*asteroid_radius
		if state==stateTypes.rising:
			state=stateTypes.walking
			timer.start(rng.randf_range(walktime-walk_range,walktime+walk_range))
	elif amount_over<-50:
		if timer.time_left>100:
			timer.start(rng.randf_range(undergroundtime-underground_range,undergroundtime+underground_range))
	
	

	
	#rotates monster to asteroid
	look_at(Asteroid.position)
	rotation-=PI/2
	
	#dirt animation
	dirtanim.position = Vector2(0,amount_over)
	if state==stateTypes.sinking and amount_over<-30:
		dirtanim.hide()
	elif state==stateTypes.rising and amount_over>-30:
		dirtanim.show()
	
func die():
	queue_free()
