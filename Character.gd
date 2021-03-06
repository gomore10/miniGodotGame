extends KinematicBody2D

var health=3
export var walk_speed = 130
export var air_speed = 130
export var ground_accel = 25
export var air_accel = 10
export var jump_force = 100

var facing = "right"

export var gravity = 7

export var asteroid_path: NodePath
onready var Asteroid = get_node(asteroid_path)
export var ui_path: NodePath
onready var UI = get_node(ui_path)
onready var Animate = $AnimationPlayer
onready var Sprite = $Sprite
onready var Gun_right = get_child(0).get_child(0)
onready var Gun_left = get_child(0).get_child(1)
var Gun = position


onready var test = Asteroid.position

var bullet = preload("res://Bullet.tscn")

var velocity = Vector2.ZERO
var onground = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var input_vec = Vector2.ZERO
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if Input.is_action_pressed("ui_right"):
		input_vec.x=1
	elif Input.is_action_pressed("ui_left"):
		input_vec.x=-1
	else:
		input_vec.x=0
	input_vec.y = 0
	input_vec=input_vec.normalized()
	
	#move right and left
	var move_velocity = Vector2.ZERO
	if onground:
		#unit vector pointing right along the asteroid
		var rightvec=(Asteroid.position - position).rotated(-PI/2).normalized()
		#same but pointing left
		var leftvec=(Asteroid.position - position).rotated(PI/2).normalized()
		#direction of current movement
		var angl=(velocity.angle_to(Asteroid.position - position)) 
		#only accelerate if not already moving at max speed in that direction
		if input_vec != Vector2.ZERO:
			if Animate.current_animation!="Walk": Animate.play("Walk")
			Sprite.flip_h=false
			if input_vec.x>0: #walk right
				if angl<0 or velocity.project(rightvec).length()<walk_speed:
					move_velocity = rightvec*input_vec.x*ground_accel
					velocity+=move_velocity
				if angl>0 and velocity.project(rightvec).length()>walk_speed: #don't go over max speed
					var newwalkvec=velocity.project(rightvec)/velocity.project(rightvec).length()*walk_speed
					velocity=velocity-velocity.project(rightvec)+newwalkvec
			else: #walk left
				Sprite.flip_h=true
				if angl>0 or velocity.project(leftvec).length()<walk_speed:
					move_velocity = rightvec*input_vec.x*ground_accel
					velocity+=move_velocity
				if angl<0 and velocity.project(leftvec).length()>walk_speed: #don't go over max speed
					var newwalkvec=velocity.project(leftvec)/velocity.project(leftvec).length()*walk_speed
					velocity=velocity-velocity.project(leftvec)+newwalkvec
		else: #slow down if on ground and not trying to move
			if angl < 0: #if going left, slow towards right
				move_velocity = rightvec*ground_accel
			else: #if going right, slow towards left
				move_velocity = leftvec*ground_accel
			velocity+=move_velocity
			#if reversed direction, stop
			var newangl=(velocity.angle_to(Asteroid.position - position))
			if (angl<0 and newangl>0) or (angl>0 and newangl<0):
				velocity=velocity-velocity.project(rightvec)
				Animate.play("Idle")
	else: #move in midair
		#unit vector pointing right along the asteroid
		var rightvec=(Asteroid.position - position).rotated(-PI/2).normalized()
		#same but pointing left
		var leftvec=(Asteroid.position - position).rotated(PI/2).normalized()
		#direction of current movement
		var angl=(velocity.angle_to(Asteroid.position - position)) 
		#only accelerate if not already moving at max speed in that direction
		if input_vec != Vector2.ZERO:
			if input_vec.x>0: #move right in air
				Sprite.flip_h=false
				if angl<0 or velocity.project(rightvec).length()<air_speed:
					move_velocity = rightvec*input_vec.x*air_accel
					velocity+=move_velocity
					if angl>0 and velocity.project(rightvec).length()>air_speed: #don't go over max speed
						var newairmovevec=velocity.project(rightvec)/velocity.project(rightvec).length()*air_speed
						velocity=velocity-velocity.project(rightvec)+newairmovevec
			else: #move left in air
				Sprite.flip_h=true
				if angl>0 or velocity.project(leftvec).length()<air_speed:
					move_velocity = rightvec*input_vec.x*air_accel
					velocity+=move_velocity
					if angl<0 and velocity.project(leftvec).length()>air_speed: #don't go over max speed
						var newairmovevec=velocity.project(leftvec)/velocity.project(leftvec).length()*air_speed
						velocity=velocity-velocity.project(leftvec)+newairmovevec
	
	#jump
	if onground and Input.is_action_pressed("ui_accept"):
		Animate.play("Jump")
		onground=false
		velocity+=(position - Asteroid.position).normalized()*jump_force
	
	#gravity to asteroid
	var gravity_vector = (Asteroid.position - position).normalized() * gravity
	
	velocity = velocity + gravity_vector
	
	velocity = move_and_slide(velocity)
	if get_slide_count()>0: #hit ground
		onground=true
		velocity=velocity-velocity.project((position - Asteroid.position))
		if Animate.current_animation=="Jump":
			Animate.play("Idle")
	else:
		onground=false
	#THIS IS WHERE HE SHOOTETH
	
	if Sprite.flip_h:
		facing = "left"
		Gun = Gun_left
	else:
		facing = "right"
		Gun = Gun_right
		
	if Input.is_action_just_pressed("shoot"):
		
		var new_bullet = bullet.instance()
		new_bullet.b_init(Asteroid.position, (Asteroid.position - (Gun.global_position)).length(), facing)
		new_bullet.position = Gun.global_position
		get_parent().add_child(new_bullet)
	
	look_at(Asteroid.position)
	
	rotation-=PI/2

	
func _on_hurtbox_area_entered(area):
	if area.is_in_group("enemy_hitbox"):
		damage()

func damage():
	health-=1
	UI.set_health(health)
	if health==0:
		#for testing
		health=3
