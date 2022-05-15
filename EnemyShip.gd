extends KinematicBody2D

export var walk_speed = 60
var direction = 1
export var ground_accel = 25
export var jump_force = 210

export var gravity = 15

export var asteroid_path: NodePath
onready var Asteroid = get_node(asteroid_path)
onready var Animate = $AnimationPlayer
onready var Sprite = $Sprite

var velocity = Vector2.ZERO
var onground = false
var jump = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	#move right and left
	var move_velocity = Vector2.ZERO
	if onground:
		#unit vector pointing right along the asteroid
		var rightvec=(Asteroid.position - position).rotated(-PI/2).normalized()
		#same but pointing left
		var leftvec=(Asteroid.position - position).rotated(PI/2).normalized()
		#direction of current movement
		var angl=(velocity.angle_to(Asteroid.position - position)) 
		
		if direction==1: #walk right
			if Animate.current_animation!="walk": Animate.play("walk")
			Sprite.flip_h=true
			if angl<0 or velocity.project(rightvec).length()<walk_speed:
				move_velocity = rightvec*direction*ground_accel
				velocity+=move_velocity
			if angl>0 and velocity.project(rightvec).length()>walk_speed: #don't go over max speed
				var newwalkvec=velocity.project(rightvec)/velocity.project(rightvec).length()*walk_speed
				velocity=velocity-velocity.project(rightvec)+newwalkvec
		elif direction==-1: #walk left
			if Animate.current_animation!="walk": Animate.play("walk")
			Sprite.flip_h=false
			if angl>0 or velocity.project(leftvec).length()<walk_speed:
				move_velocity = rightvec*direction*ground_accel
				velocity+=move_velocity
			if angl<0 and velocity.project(leftvec).length()>walk_speed: #don't go over max speed
				var newwalkvec=velocity.project(leftvec)/velocity.project(leftvec).length()*walk_speed
				velocity=velocity-velocity.project(leftvec)+newwalkvec
	
	#jump
	if onground and jump:
		Animate.play("jump")
		onground=false
		velocity+=(position - Asteroid.position).normalized()*jump_force
	
	#gravity to asteroid
	var gravity_vector = (Asteroid.position - position).normalized() * gravity
	
	velocity = velocity + gravity_vector
	
	velocity = move_and_slide(velocity)
	if get_slide_count()>0: #hit ground
		onground=true
		velocity=velocity-velocity.project((position - Asteroid.position))
		if Animate.current_animation=="jump":
			Animate.play("idle")
	else:
		onground=false
	look_at(Asteroid.position)
	rotation-=PI/2


func _on_hitbox_area_entered(area):
	if area.is_in_group("bullet"):
		print("dead")
		queue_free()
		
